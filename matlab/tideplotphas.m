function tideplotphas(freqn,phase,phaserror,opts)
%function tideplotphas(freqn,phase,phaserror,opts)
%
%Must be invoked after tideplotamp

siz=size(freqn);
cell_freq=mat2cell(freqn,ones(siz(1),1),siz(2));
index=find(phaserror<120);

errorbar( index, ...
          phase(index),...
          phaserror(index),...
          opts);
      
xlim([0 length(phase)+1]);
ylim([0 360]);
ylabel('Phase');
set(gca , 'XTickLabel', cell_freq...   
        , 'XTick',1:length(phase));
