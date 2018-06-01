function [idx] = ts_argmax(x,d)
    %argmax of the time series of the value x in the past d days
    x_1 = x(:,end-d+1:end);
    x_1 = x_1';
    [tsm,idx] = max(x_1,[],'omitnan');
    idx = idx';
    idx(isnan(idx)) = 0;
end