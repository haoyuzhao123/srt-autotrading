function [y] = signedpower(x,a)
    %the power x .^ a
    y = x .^ a;
    y(isnan(y)) = 0;
end