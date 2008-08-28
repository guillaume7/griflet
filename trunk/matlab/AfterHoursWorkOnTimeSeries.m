%Generate the data on the workspace (uncomment next line)
%%WorkOnTideAnalysis;

%Plot amplitude
subplot(2,1,1);
hold off;index=tideplotamp(s_Xresref.freqname, s_Yresref.amplitude, ':.k', 1);
hold on;tideplotamp(s_Xres1.freqname(index,:), s_Yres1.amplitude(index), ':xb');
hold on;tideplotamp(s_Xres2.freqname(index,:), s_Yres2.amplitude(index), ':+r');
title('Gijon tidal station. Insitu (black), level1 (blue), level2 (red)');

%Plot phase
subplot(2,1,2);
hold off;tideplotphas(s_Xresref.freqname(index,:), s_Yresref.phase(index), s_Ystatsref.phaserror(index), ':ok');
hold on; tideplotphas(s_Xres2.freqname(index,:), s_Yres2.phase(index), s_Ystats2.phaserror(index), ':+r');
hold on; tideplotphas(s_Xres1.freqname(index,:), s_Yres1.phase(index), s_Ystats1.phaserror(index), ':xb');
