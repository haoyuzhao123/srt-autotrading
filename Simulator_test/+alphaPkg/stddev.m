function [stdev] = stddev(x,d)
    %compute the standard deviation of each row
    x_1 = x(:,end-d+1:end);
    x_1 = x_1';
    std_1 = std(x_1);
    stdev = std_1';
    stdev(isnan(stdev)) = 0;
end