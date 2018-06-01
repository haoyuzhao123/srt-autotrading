function [del] = delta(x,d)
    %difference of the value in 2 days
    del = x(:,end) - x(:,end-d+1);
    del(isnan(del)) = 0;
end