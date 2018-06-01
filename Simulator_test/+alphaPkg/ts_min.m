function [tsm] = ts_min(x,d)
    %min of the time series of the value x in the past d days
    x_1 = x(:,end-d+1:end);
    x_1 = x_1';
    tsm = min(x_1,[],'omitnan');
    tsm = tsm';
    tsm(isnan(tsm)) = 0;
end