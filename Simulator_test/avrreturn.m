function avr_return = avrreturn(money)
    returnval = (money - money(1)) / money(1);
    [m,n] = size(money);
    tot_size = m * n;
    avr_return = returnval ./ reshape(1:tot_size,m,n) * 220;
end