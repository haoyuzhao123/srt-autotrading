function [ cor ] = Correlation( x,y,d )
    %the correlation of the data x,y,d
    [m,n] = size(x);
    x_1 = x(:,end-d+1:end);
    y_1 = y(:,end-d+1:end);
    cor = zeros(m,1);
    for i=1:m,
        a = x_1(i,:);
        a = a';
        b = y_1(i,:);
        b = b';
        cor(i,1) = corr(a,b);
    end
end

