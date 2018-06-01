%the global variables
global stocksBasicData;
global stocksMonthData;
global stocksWeekData;
global MAX_STOCKS;
global MAX_DAYS;
global MAX_FEATURES;

%the implementation of the alpha goes here.
%this is a interface for the alpha, you should only fill in the codes below
%and return a vector
%the other part will not do the sparce operation, so it is suggested to
%implement the sparcity of the alpha here.

%         %feature1, the open price of the day, use the first price data to
%         %denote it
%         
%         %feature2, the closing price of the day, use the last price data ot
%         %denote it
%         
%         %feature3, the mean of the price. It is calculated by the money
%         
%         %feature4, the maximum of the price of the day
%         
%         %feature5, the minimun of the price of the day
%         
%         %feature6, the volumn of the day
%         
%         %feature7, the money of the day
%         
%         %feature8, the variance of the day
%         
%         %feature9, the ratio
%         %end generating the features%

%-----fill in the implementation of the alpha here-----

%#alpha
data = stocksBasicData(9, : ,(day-5):(day-1));
temp = -sum(data,3,'omitnan') / 5;
temp = temp / sum(abs(temp));
temp = squeeze(temp);

data1 = stocksBasicData(1, : ,(day-1)); %open
data2 = stocksBasicData(2, : ,(day-1)); %close
data3 = stocksBasicData(4, : ,(day-1)); %high
data4 = stocksBasicData(5, : ,(day-1)); %low
temp = -((data2 - data4) - (data3 - data2)) ./ (data2 - data4 + 0.001);

temp = temp / sum(abs(temp),'omitnan');
temp = squeeze(temp);

temp(isnan(temp)) = 0;

temp = reshape(temp,MAX_STOCKS,1);
ret = temp;

%-----end of the code for implementation-----

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following part should always remain the same

%verify that the absolute value in the return sums to 1,
%otherwise, take the return to zero vector
temp = abs(ret);
if (sum(temp) == 1 || abs(sum(temp) - 1) < 0.00001),
    return;
else
    ret = zeros(MAX_STOCKS,1);
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end