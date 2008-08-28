function index = tideplotamp(freqn, amp, opts, sortit)
%function index = tideplotamp(freqn, amp, opts, sortit)
%
%Plots the amplitude vs frequencyname of the tide results from t_tide.
%
%ex:
% index = tideplotamp(freqname, amplitude1, ':.k', 1);
% hold on; tideplotamp(freqname(index,:), amplitude2(index), ':+b');

index = 1:length(amp);
if nargin == 4
    if sortit == true
        [ampl,index]=sort(amp,1,'descend');
    end
end

siz=size(freqn);
cell_freq=mat2cell(freqn,ones(siz(1),1),siz(2));
N=find(strcmp(cell_freq(index),'M4  ')==true); %number of main components
index=index(1:N);

plot(amp(index),opts);
%errorbar(amp(index),amperror(index),opts);
xlim([0 N+1]);
ylim ([0.0001 10]);
ylabel('Amplitude');
set(gca, 'YScale', 'log', 'YMinorTick', 'on', 'YGrid', 'off');
set(gca , 'XTickLabel', cell_freq(index(1:N))...   
        , 'XTick',1:N);