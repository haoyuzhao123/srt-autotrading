function [max_withdraw, vec_withdraw] = withdraw(money, max_interval)
    %compute the maximum withdraw given the momey of each day
    %
    %money is the money of each day
    %max_interval is the number of days we consider
    %
    %the goal is to max(money(i) - money(j)), s.t. j - i <= max_interval
    
    %we have to make sure that the parameter money is given in as a column
    %vector
    [n,m] = size(money);
    if m ~= 1,
        error('the vector must be a column vector')
    end
    
    %base case
    opt = zeros(n,2);
    opt(1,1) = 1;
    
    %dp recursion
    for i=2:n,
        t = opt(i-1,1);
        if i-t > max_interval,
            temp = i - max_interval;
            for j=(i-max_interval+1):i,
                if money(j,1) > money(temp,1),
                    temp = j;
                end
            end
            opt(i,1) = temp;
            opt(i,2) = money(temp) - money(i);
        else
            if money(t,1) < money(i,1),
                opt(i,1) = i;
            else
                opt(i,1) = t;
                opt(i,2) = money(t,1) - money(i,1);
            end
        end
    end
    
    %maximum withdraw
    vec_withdraw = opt(:,2);
    max_withdraw = max(vec_withdraw);
end