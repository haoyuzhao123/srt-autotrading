%checked
MAX_STOCKS = 3500;
MAX_FEATURES = 10;

Week_days = 5;
Month_days = 22;
Year_days = 242;

load('./stocksBasicData.mat');
shape = size(stocksBasicData);
days = shape(3)

size(stocksBasicData)

%generate the week data
new_entries = days - Week_days + 1;
stocksWeekData = NaN * ones(MAX_FEATURES, MAX_STOCKS, new_entries);

new_stocksBasicData = ones(shape(1),shape(2),Week_days,new_entries);
size_mat = size(new_stocksBasicData);
size_mat
for i=1:Week_days,
    new_stocksBasicData(:,:,i,:) = stocksBasicData(:,:,i:(i+new_entries-1));
end;

%feature 1, high of the open
temp = new_stocksBasicData(1,:,:,:);
stocksWeekData(1,:,:) = max(temp,[],3,'omitnan');

%feature 2, low of the open
stocksWeekData(2,:,:) = min(temp,[],3,'omitnan');

%feature 3, high of the close
temp = new_stocksBasicData(2,:,:,:);
stocksWeekData(3,:,:) = max(temp,[],3,'omitnan');

%feature 4, low of the open
stocksWeekData(4,:,:) = min(temp,[],3,'omitnan');

%feature 5, mean of the mean
temp = new_stocksBasicData(3,:,:,:);
stocksWeekData(5,:,:) = sum(temp,3,'omitnan') / Week_days;

%feature 6, high of the ratio
temp = new_stocksBasicData(9,:,:,:);
stocksWeekData(6,:,:) = max(temp,[],3,'omitnan');

%feature 7, low of the ratio
stocksWeekData(7,:,:) = min(temp,[],3,'omitnan');

%feature 8, high of the high
temp = new_stocksBasicData(4,:,:,:);
stocksWeekData(8,:,:) = max(temp,[],3,'omitnan');

%feature 9, low of the low
temp = new_stocksBasicData(5,:,:,:);
stocksWeekData(9,:,:) = min(temp,[],3,'omitnan');

save stocksWeekData stocksWeekData

