function ret = alpha_13(day)
%ALPHA Summary of this function goes here
%   Detailed explanation goes here
%this alpha need to make sure that the sum of the absolute
%values of the return should add to 1

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

%Edit by Haoyu Zhao
%alpha13

%the code block to load the basic data
data1 = stocksBasicData(2, : ,(day-6:day-1)); %close
data2 = stocksBasicData(6, : ,(day-6:day-1)); %volumn
data1 = squeeze(data1);
data2 = squeeze(data2);

temp = -1 * alphaPkg.Rank(alphaPkg.Correlation(alphaPkg.Rank(data1), alphaPkg.Rank(data2), 5));
sum(abs(temp))

%--------not recommanded to modify the codes below----
%normalize the alpha by L1 norm
temp = temp / sum(abs(temp),'omitnan');
temp = squeeze(temp);

%eliminate NaN
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