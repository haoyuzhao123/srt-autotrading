%checked
%This file is the code to combine the alphas
%This file is originally left blank
%Some of the rules:
%The input of the strategy is the status, the day(tomorrow);
%The output is the strategy, that is buy or sell how much of each
%stock(measured in volumn)

function instruction = strategy(status, day, alpha_func)
    %the global variables
    global stocksBasicData;
    global stocksMonthData;
    global stocksWeekData;
    global MAX_STOCKS;
    global MAX_DAYS;
    global MAX_FEATURES;
    
    global nan_index;
    %initialize the instruction to (0,0,0...)
    instruction = zeros(MAX_STOCKS,1);
    
    %fill in the codes below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %some constants
    %the constants are related to the constraints
    upper_per_stock = 0.1;
    upper_exc_rate = 1.0;
    fee = 0.0005;
    %weight is the relationship between the fee and the alpha
    weight = 100;
    
    %the basic parameters
    prices = stocksBasicData(1,:,day);
    prices = reshape(prices, MAX_STOCKS, 1);
    
    %--------------------------------
    %need to decide which alpha to use
    alpha_vec = weight * alpha_func(day);
    %--------------------------------
    
    alpha_vec(isnan(alpha_vec)) = 0;
    cur_status = status(1:MAX_STOCKS,1);
    cur_money = status(MAX_STOCKS+1,1);
    total_money_each_stock = stocksBasicData(7,:,1000:1500);
    today_nan_index = nan_index(:,day);
    %parameters in this question
    MAX_BS_STOCKS = 300;

    %choose the stocks
    %choose the stocks with the largest volatility
    total_money_stock = sum(total_money_each_stock,3,'omitnan');
    [temp idx] = sort(total_money_stock);
    index_vec = idx(end-MAX_BS_STOCKS+1:end);
    
    %choose the alpha for the particular stocks
    alpha_vec = alpha_vec(index_vec);
    alpha_vec = alpha_vec / sum(abs(alpha_vec));
    
    %the domain of the B/S stocks
    cur_status_res = cur_status(index_vec);
    prices_res = prices(index_vec);
    nan_price_stock_idx = today_nan_index(index_vec);
    prices_res(isnan(prices_res)) = 0;

    %the objective function
    %the objective function is the inner product of the alpha and the
    %insturction, plus the fee
    f = -alpha_vec;
    f(nan_price_stock_idx) = 0;
    f = [f;-f];
    temp = ones(MAX_BS_STOCKS,1);
    temp = temp .* prices_res;
    temp = temp * fee;
    temp = [temp;temp];
    f = f + temp;
    
    %maximum weight of money per stock
    %limit the maximum value in each stock compared with the total value
    total_value = sum(prices .* cur_status,'omitnan') + cur_money;
    
    price_matrix = diag(prices_res);
    price_matrix(isnan(price_matrix)) = 0;
    upper_weight_matrix = eye(MAX_BS_STOCKS) - upper_per_stock * ones(MAX_BS_STOCKS,MAX_BS_STOCKS);

    total_weight_matrix = upper_weight_matrix * price_matrix;
    
    left_total_weight = total_weight_matrix;
    right_total_weight = -total_weight_matrix * cur_status_res;
    
    %limit the maximum exchange rate each day
    max_exc_res = upper_exc_rate * total_value;
    left_exc_res = [prices_res; prices_res];
    
    %cannot let current status less than 0
    left_cur_status_restrict = -eye(MAX_BS_STOCKS);
    right_cur_status_restrict = cur_status_res;
    
    %money restriction
    %cannot appear negative money
    left_money_restrict = prices_res';
    epsilon = 0.0001;
    right_money_restrict = min(0.95 * cur_money,cur_money-100) ;
    
    %lower bound for the positive and negative part
    lb = zeros(2 * MAX_BS_STOCKS,1);
    
    %the total parameters for the linear programming
    A = [left_total_weight;left_cur_status_restrict;left_money_restrict];
    b = [right_total_weight;right_cur_status_restrict;right_money_restrict];
    
    %use the inequalities with eps instead of the equality constraints
    Aeq = diag(nan_price_stock_idx);
    Aeq = Aeq + zeros(size(Aeq));
    beq = epsilon * ones(MAX_BS_STOCKS,1);
    
    A = [A;Aeq;-Aeq];
    b = [b;beq;beq];
    b = [b;max_exc_res];
    A = [A -A];
    A = [A;left_exc_res'];

    %solve the linear programming
    %sol is the solution we get
    %fval is value
    %exitflag,output are the state of the lp
    [sol,fval,exitflag,output] = linprog(f,A,b,[],[],lb);
    
    %just consider the case when the problem can be solved
    if exitflag ~= 1,
        x = zeros(MAX_BS_STOCKS,1);
    else,
        x = sol(1:MAX_BS_STOCKS) - sol(MAX_BS_STOCKS+1:2*MAX_BS_STOCKS);
        x(nan_price_stock_idx) = 0;
    end
    
    instruction(index_vec) = x;
    %check that the instruction is feasible
    temp = status(1:MAX_STOCKS,1) + instruction;
    temp = squeeze(temp);
    for i=1:MAX_STOCKS,
        if temp(i) < eps,
            instruction(i,1) = -status(i);
        end
    end
    instruction(today_nan_index) = 0;  

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end