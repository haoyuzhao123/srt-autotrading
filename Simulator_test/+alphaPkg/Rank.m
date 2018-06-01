function [ Index ] = Rank(x)
 % return the rank of the vector x
 % the return value Index is the cross-sectional rank for all of the
 % elements
    [y,Index] = sort(x);
    Index(isnan(Index)) = 0;
end

