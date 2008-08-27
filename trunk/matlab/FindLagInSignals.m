function [lag, lagcorr, lagrmse, lagover] = FindLagInSignals(t, y1, y2)
%function [lag, lagcorr, lagrmse] = FindLagInSignals(t, y1, y2)
%
%Insert two signals with same dt interval. The routine will return their
%optimal correlation coefficient and their corresponding lag time,
%lag RMSE, as well as the remaining overlap over the lagged domains.

bias=mean(y1)-mean(y2);
corr=corrcoef(y1,y2);
rmse=std(y1-mean(y1) - y2+mean(y2));

N=length(t);
tlag = linspace(-t(N/2),t(N/2),N+1);
crosscorr=xcorr(y1,y2,N/2,'coeff'); 
imax = find(crosscorr==max(crosscorr));
lag = tlag(imax); % s - lag times
lagcorr = crosscorr(imax);
x = imax - N/2;
%x ranges in [0 .. N-1]
if (x>0)
    st1=1+x; nd1=N;
    st2=1; nd2=N-x;
else
    st1=1; nd1=N+x;
    st2=1-x; nd2=N;
end
lagrmse = std(y1(st1:nd1)-mean(y1(st1:nd1)) ...
            - y2(st2:nd2)+mean(y2(st2:nd2)));
lagover = (N-abs(x))/N;

%Plotting
subplot(2,1,1);hold off;plot(t,y1,'k');
subplot(2,1,1);hold on;plot(t,y2,'b');
title([ 'Signals'...
        ,'. Bias: '...
        , num2str(bias,2) ...
        ,'; correlation: '...
        , num2str(corr(2,1),2) ...
        ,'; rmse: '...
        , num2str(rmse,2) ...
        ,'.'...
    ]);
xlabel('time');ylabel('amplitude');

subplot(2,1,2);hold off;plot(tlag,crosscorr, 'k');
subplot(2,1,2);hold on;stem(lag,lagcorr,':');
title([ 'Normalized cross-correlation.' ...
        ,' Lag: ', num2str(lag(1),2) ...
        ,'; correlation: ', num2str(lagcorr(1),2)...
        ,'; rmse: ', num2str(lagrmse(1),2)...
        ,'; overlap: ', num2str(lagover*100,2)...
        ,'%.' ...
    ]);
xlabel('Phase in time units');ylabel('coefficient');

