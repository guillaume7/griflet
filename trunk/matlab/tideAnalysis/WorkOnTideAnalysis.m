%Generic input data
s_params = struct( ...
        'startdate', [2004 2 1 0 0 0] ...
    ,   'dt', 600 ... %s
    ,   'lat', 43.5 ... %ºN
    ,   'snr_crit', 2. ... %Chosen signal-2-noise ratio
    ,   'delta', 0. ...
    ,   'count', (365-32)*24.0*6. ...
    ,   'factor', 1. ...
    );

%Gijon level1
[s_Yres1, s_Ystats1, s_Xres1] = ...
    NcTideAnalysis('mohidgijon_level1.nc', s_params);
%plot
TidePlot(s_Yres1, s_Ystats1, s_Xres1, 'b');

hold on;

%Gijon level2
[s_Yres2, s_Ystats2, s_Xres2] = ...
    NcTideAnalysis('mohidgijon_level2.nc', s_params);
%plot
TidePlot(s_Yres2, s_Ystats2, s_Xres2, 'r');

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

%plot
h = TidePlot(s_Yresref, s_Ystatsref, s_Xres1, 'k');
%Save image
saveas(h, 'Analysis_all_waterlevel.png', 'png');
hold off;
clf;

%Calculate the differences level2 - level1
[s_Yresdiff21, s_Ystatsdiff21, s_Xresdiff21] = ...
    TideDiff( s_Yres2, s_Yres1, s_Ystats2, s_Ystats1, s_Xres2 );

%plot
TidePlot(s_Yresdiff21, s_Ystatsdiff21, s_Xresdiff21, 'r');
%Save image
saveas(gcf, 'RMSE_21.png', 'png');
clf;

%Calculate the differences insitu level ref - level2
[s_Yresdiffref2, s_Ystatsdiffref2, s_Xresdiffref2] = ...
    TideDiff( s_Yresref, s_Yres2, s_Ystatsref, s_Ystats2, s_Xresref );

%plot
TidePlot(s_Yresdiffref2, s_Ystatsdiffref2, s_Xresdiffref2, 'k');
%Save image
saveas(gcf, 'RMSE_ref2.png', 'png');
clf;
