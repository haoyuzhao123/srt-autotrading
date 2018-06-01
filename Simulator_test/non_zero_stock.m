function ret = non_zero_stock(vec)
    %return the number of num zero stocks
    global MAX_STOCKS;
    eps = 1e-1;
    vec1 = vec < eps;
    vec2 = vec > -eps;
    vec3 = vec1 .* vec2;
    ret = MAX_STOCKS - sum(vec3, 'omitnan');
end