%checked,   open and close
MAX_STOCKS = 3500;
MAX_DAYS = 1600;
MAX_FEATURES = 10;

stocksBasicData = NaN * ones(MAX_FEATURES, MAX_STOCKS, MAX_DAYS);

stocks2num = containers.Map();
days2num = containers.Map();

days_dir = dir('../stocks/');

total_days = 0;
total_stocks = 0;

for i = 1:MAX_DAYS,
    disp(i)
    total_dirs = length(days_dir);
    day = days_dir(total_dirs-MAX_DAYS + i).name;
    % day
    if days2num.isKey(day) == 0,
        total_days = total_days + 1;
        days2num(day) = total_days;
    end
    certain_day = days2num(day);
    stocks_dir = dir(['../stocks/', day, '/']);
    for j = 3:length(stocks_dir),
        stock_id = stocks_dir(j).name(12:17);
        if stocks2num.isKey(stock_id) == 0,
            total_stocks = total_stocks + 1;
            stocks2num(stock_id) = total_stocks;
        end
        certain_stock = stocks2num(stock_id);
        stock_filename = ['../stocks/', day, '/', stocks_dir(j).name];
        stock_data = load(stock_filename);
        ticksData = stock_data.ticksData;
        %begin generating the features%
        
        %feature1, the open price of the day, use the first price data to
        %denote it
        stocksBasicData(1, certain_stock, certain_day) = ticksData{1,1}(1);
        
        %feature2, the closing price of the day, use the last price data ot
        %denote it
        stocksBasicData(2, certain_stock, certain_day) = ticksData{1,1}(end);
        
        %feature3, the mean of the price. It is calculated by the money
        %divided by the volumn
        money = sum(ticksData{1,3});
        volumn = sum(ticksData{1,4});
        stocksBasicData(3, certain_stock, certain_day) = money / volumn;
        
        %feature4, the maximum of the price of the day
        stocksBasicData(4, certain_stock, certain_day) = max(ticksData{1,1});
        
        %feature5, the minimun of the price of the day
        stocksBasicData(5, certain_stock, certain_day) = min(ticksData{1,1});
        
        %feature6, the volumn of the day
        stocksBasicData(6, certain_stock, certain_day) = volumn;
        
        %feature7, the money of the day
        stocksBasicData(7, certain_stock, certain_day) = money;
        
        %feature8, the variance of the day
        mean = money / volumn;
        vec_m = ticksData{1,3};
        vec_v = ticksData{1,4};

        variance = sum(vec_v .* ((vec_m ./ vec_v - mean) .^ 2), 'omitnan') / volumn;
        stocksBasicData(8, certain_stock, certain_day) = variance;
        
        %feature9, the ratio
        i = certain_day - 1;
        close = stocksBasicData(2, certain_stock, certain_day);
        while(i > 0),
            temp = stocksBasicData(2, certain_stock, i);
            if (isnan(temp) ~= 1),
                stocksBasicData(9, certain_stock, certain_day) = (close - temp) / temp;
                break;
            end
            i = i-1;
        end
        %end generating the features%
    end
end

save stocksBasicData stocksBasicData
save days2num days2num
save stocks2num stocks2num