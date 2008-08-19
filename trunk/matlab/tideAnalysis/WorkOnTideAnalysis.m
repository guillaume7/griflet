%Generic input data
s_params = struct( ...
        'startdate', [2004 2 1 0 0 0] ...
    ,   'dt', 600 ... %s
    ,   'lat', 43.5 ... %ºN
    ,   'snr_crit', 2. ... %Chosen signal-2-noise ratio
    ,   'delta', 0. ...%Offset relative to start date in netcdf time units
    ,   'count', (365-32)*24.0*6. ... %How many instants to retrieve
    ,   'factor', 1. ... % Factor to convert the netcdf time into seconds
    );

%%%%CALCULATIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Gijon level1
[s_Yres1, s_Ystats1, s_Xres1] = ...
    NcTideAnalysis('mohidgijon_level1.nc', s_params);

%Gijon level2
[s_Yres2, s_Ystats2, s_Xres2] = ...
    NcTideAnalysis('mohidgijon_level2.nc', s_params);

%Gijon in-situ
%Our model is in seconds since 2004-02-01 00:00
%The correspondance with Timeref is 19724.0 days.
s_params.dt = 3600.;
s_params.delta = ( (366 + 365*3)/4. * 54 + 31 - 16587.0 ) * 24.0;
s_params.count = 365*24.0;
s_params.factor = 86400.;
[s_Yresref, s_Ystatsref, s_Xresref] = ...
    NcTideAnalysis('Gijon.nc', s_params);
[s_Yresref, s_Xresref] = ...
    TideInterp(s_Xresref, s_Yresref, s_Xres2);

%Gijon in-situ residual signal
s_params.special_ssh = 'res_ssh';
[s_Yresrefres, s_Ystatsrefres, s_Xresrefres] = ...
    NcTideAnalysis('Gijon.nc', s_params);
[s_Yresrefres, s_Xresrefres] = ...
    TideInterp(s_Xresrefres, s_Yresrefres, s_Xres2);

%Calculate the differences level2 - level1
disp('Calculate the differences level2 - level1');
[s_Yresdiff21, s_Ystatsdiff21, s_Xresdiff21] = ...
    TideDiff( s_Yres2, s_Yres1, s_Ystats2, s_Ystats1, s_Xres2 );

%Calculate the differences insitu level ref - level2
disp('Calculate the differences insitu level ref - level2');
[s_Yresdiffref2, s_Ystatsdiffref2, s_Xresdiffref2] = ...
    TideDiff( s_Yresref, s_Yres2, s_Ystatsref, s_Ystats2, s_Xresref );

%Calculate the differences insitu level ref - refres
disp('Calculate the differences insitu level ref - refres');
[s_Yresdiffrefres, s_Ystatsdiffrefres, s_Xresdiffrefres] = ...
    TideDiff( s_Yresrefres, s_Yresref, s_Ystatsrefres, s_Ystatsref, s_Xresrefres );

%%%%PLOTTING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Define here the moving averages coefficients
filterresiduals = true;
movdays = 3.; %days
movincs = movdays * 24 * 6; %600 seconds increments

%Filter residuals
if filterresiduals
    s_Yres1.residual = filter( ones(movincs,1)/movincs, 1, s_Yres1.residual );
end

%plot
TidePlot(s_Yres1, s_Ystats1, s_Xres1, 'b');

hold on;

%Filter residuals
if filterresiduals
    s_Yres2.residual = filter( ones(movincs,1)/movincs, 1, s_Yres2.residual );
end

%plot
TidePlot(s_Yres2, s_Ystats2, s_Xres2, 'r');

%Filter residuals
if filterresiduals
    s_Yresref.residual = filter( ones(movincs,1)/movincs, 1, s_Yresref.residual );
end

%plot
h = TidePlot(s_Yresref, s_Ystatsref, s_Xres1, 'k');
%Save image
saveas(h, 'Analysis_all_waterlevel.png', 'png');
hold off;
clf;

%Filter residuals
if filterresiduals
    s_Yresdiff21.residual = filter( ones(movincs,1)/movincs, 1, s_Yresdiff21.residual );
end

%plot
TidePlot(s_Yresdiff21, s_Ystatsdiff21, s_Xresdiff21, 'r');
%Save image
saveas(gcf, 'RMSE_21.png', 'png');
clf;

%Filter residuals
if filterresiduals
    s_Yresdiffref2.residual = filter( ones(movincs,1)/movincs, 1, s_Yresdiffref2.residual );
end

%plot
TidePlot(s_Yresdiffref2, s_Ystatsdiffref2, s_Xresdiffref2, 'k');
%Save image
saveas(gcf, 'RMSE_ref2.png', 'png');
clf;

%Filter residuals
if filterresiduals
    s_Yresdiffrefres.residual = filter( ones(movincs,1)/movincs, 1, s_Yresdiffrefres.residual );
end

%plot
TidePlot(s_Yresdiffrefres, s_Ystatsdiffrefres, s_Xresdiffrefres, 'k');
%Save image
saveas(gcf, 'RMSE_refres.png', 'png');
clf;