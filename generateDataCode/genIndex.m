load('dateList.mat');
load('days2num.mat')

m = size(dateList,1);

strdate = num2str(dateList);

days = zeros(1,0);

for i=1:m,
    if days2num.isKey(strdate(i,:)),
        days = [days i];
    end
end

size(days)

load('KdataByStock_1min_HS300.mat');
%money = HS300{7,1};
%volume = HS300{6,1};
price = KdataByStock_1min_HS300{2,1};
%money = money(days,:);
%volume = volume(days,:);
%money_day = sum(money, 2, 'omitnan');
%volume_day = sum(volume, 2, 'omitnan');
index = price(days,1);

%index = money_day ./ volume_day;

save index index