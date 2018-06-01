%checked

function  status_cum = simulator(Begin, End, initial_money, alpha_func)
%The main function of the simulator
%Require the alphas and the simulator codes
global MAX_STOCKS;
global MAX_DAYS;
global MAX_FEATURES;
global index;

%set the money and the stocks
%the first 3000 rows are the volumn of each stock
%the 3001th rows is the current money
status = zeros(MAX_STOCKS+1, 1);
status(MAX_STOCKS+1,1) = initial_money;
status_cum = zeros(MAX_STOCKS+1, 0);
status_cum = [status_cum status];

%record the volumn of index
status_index = zeros(1,1);

%load the global variables
global stocksBasicData;
global stocksMonthData;
global stocksWeekData;

global nan_index;

for i=Begin:End,
    disp(i)
    disp(status(MAX_STOCKS+1,1))
    instruction = strategy(status, i, alpha_func);
    
    %assume that we can always complete the trading with the open price
    prices = stocksBasicData(1,:,i);
    prices = reshape(prices, MAX_STOCKS, 1);
    
    for j=1:MAX_STOCKS,
        if isnan(prices(j,1)),
            instruction(j,1) = 0;
        end
    end
    
    temp = nan_index(:,i);
    instruction(temp) = 0;
    
    if sum(prices .* instruction, 'omitnan') > status(MAX_STOCKS+1),
        instruction = zeros(size(instruction));
        disp('zero-instruction')
    end
    
    %gain and loss of each day
    money = sum(prices .* instruction, 'omitnan');
    status_delta = zeros(MAX_STOCKS+1, 1);
    status_delta(1:MAX_STOCKS, 1) = instruction;
    status_delta(MAX_STOCKS+1,1) = -money;
    status = status + status_delta;
    temp = status(1:MAX_STOCKS,1);
    non_zero = non_zero_stock(temp);
    strmsg = sprintf('number of non-zero stock is: %d', non_zero);
    disp(strmsg)
    %disp(non_zero)
    status_cum = [status_cum status];
end

money = status_cum(MAX_STOCKS+1,:);

temp = status_cum;
prices = stocksBasicData(1,:,(Begin-1):End);
prices = reshape(prices, MAX_STOCKS, (End - Begin + 2));
%size(prices)
%size(temp)
coeff = 1;
stocks_value = sum(prices .* temp(1:MAX_STOCKS,:), 1, 'omitnan');
money_total = coeff * stocks_value + temp(MAX_STOCKS+1,:);
status_cum = [status_cum; money_total];

min(money)
end