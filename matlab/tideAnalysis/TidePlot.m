function  h = tideplot(s_Yres, s_Ystats, s_Xres, color)
%function  h = tideplot(s_Xres, s_Yres, s_Ystats, color)
%Tideplot

snr_crit = 2;
lim = [-3 5];
timeoffset = 32;
xlim = [0 365];
stride = 100;
%color = 'k';

orient tall;

if isfield(s_Ystats,'rmsesignal')
    statlevel = [   '; RMSE: ', num2str(s_Ystats.rmsesignal,2), ...
                    ' m, Corr: ', num2str(s_Ystats.corrsignal(1,2),2)];
else
    statlevel = '';
end

if isfield(s_Ystats,'rmsetidepred')
    stattide = [   '; RMSE: ', num2str(s_Ystats.rmsetidepred,2), ...
                    ' m, Corr: ', num2str(s_Ystats.corrtidepred(1,2),2)];
else
    stattide = '';
end

if isfield(s_Ystats,'rmseresidual')
    statresid = [   '; RMSE: ', num2str(s_Ystats.rmseresidual,2), ...
                    ' m, Corr: ', num2str(s_Ystats.corrresidual(1,2),2)];
else
    statresid = '';
end

%Signal
subplot(4,1,1);
plot(   s_Xres.time(1:stride:end)/86400. + timeoffset,...
        s_Yres.signal(1:stride:end) + 3, color);
hold on;
plot(xlim, [3 3], ':k');
plot(s_Xres.time(1:stride:end)/86400. + timeoffset,...
    s_Yres.tidepred(1:stride:end), color);
plot(xlim, [0 0], ':k');
set(gca,'xlim', xlim, 'YLimMode', 'manual', 'YLim', lim);
title([ '3 m biased water level (top)', statlevel, ...
        '. Reconstituded tide (bottom)', stattide,'.']);
ylabel('Elevation (m)');

%Residual, TidePred
subplot(4,1,2);
plot(s_Xres.time(1:stride:end)/86400. + timeoffset,...
    s_Yres.residual(1:stride:end), color); 
hold on;
plot(xlim, [0 0], ':k');
set(gca,'xlim', xlim);
title(['Unbiased residual water level with 3 day moving average', ...
        statresid, '.']);
ylabel('Elevation (m)');
xlabel('Yearday');

%Amp (signif constituents (snr_crit))
subplot(4,1,3);
index = find(s_Ystats.snr > snr_crit);
semilogy(s_Xres.freq(index), s_Yres.amplitude(index),['.:',color]);
%stem(s_Xres2.freq(index), s_Yres2.amplitude(index), 'color', color);
hold on;
set(gca, 'ylim',[1e-5 0.5e1]);
set(gca,'YTick', [0.0 1e-4 1e-2 1.0]);
title(['Amplitude of significant constituents']);
ylabel('Amplitude (m)');

%Phase + errorbars (signif constituents (snr_crit))
subplot(4,1,4);
errorbar(s_Xres.freq(index),...
                s_Yres.phase(index),...
                s_Ystats.phaserror(index)...
                ,['.:',color]);
title(['Phase and error bars of significant constituents']);
ylabel('Phase (deg)');
xlabel('frequency (cph)');
set(gca,'ylim',[0 380]);

h = gcf;
