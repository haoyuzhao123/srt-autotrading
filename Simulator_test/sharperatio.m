function sharpe_val = sharperatio(money)
    returnval = (money - money(1)) / money(1);
    [m,n] = size(money);
    tot_size = m * n;
    avr_return = returnval ./ reshape(1:tot_size,m,n) * 220;
    
    temp = zeros(size(money));
    for i=1:tot_size,
        temp(i) = std(returnval(1:i));
    end
    sharpe_val = avr_return(200:end) ./ temp(200:end);
end