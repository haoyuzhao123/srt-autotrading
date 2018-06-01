function [ Index ] = sigmoid(x, scale)
 % return the rank of the vector x
 % the return value Index is the cross-sectional rank for all of the
 % elements
    Index = 1 ./ ( 1 + exp(-x / scale));
    Index(isnan(Index)) = 0;
end

