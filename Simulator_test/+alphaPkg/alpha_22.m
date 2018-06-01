function ret = alpha_22(day)
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

%Edit by Yi Dai
%alpha3 

% (-1 * (delta(correlation(high, volume, 5), 5) * rank(stddev(close, 20)))) 
%the code block to load the basic data

high = stocksBasicData(4, : ,(day-6:day-1)); 
volume = stocksBasicData(6, : ,(day-6:day-1)); 
close = stocksBasicData(2, : ,(day-21:day-1));
high_5 = stocksBasicData(4, : ,(day-11:day-6)); 
volume_5 = stocksBasicData(6, : ,(day-11:day-6));

high_5 = squeeze(high_5);
volume_5 = squeeze(volume_5);
high = squeeze(high);
volume = squeeze(volume);
close = squeeze(close);

temp1 = alphaPkg.Correlation(high, volume, 5);
temp2 = alphaPkg.Correlation(high_5, volume_5, 5);
temp3 = temp1 - temp2;
temp4 = alphaPkg.Rank(alphaPkg.stddev(close, 20));
temp = -1 * temp3 .* temp4;

%--------not recommanded to modify the codes below----
%normalize the alpha by L1 norm
temp(isnan(temp)) = 0;
temp = temp - mean(temp);
temp = temp / sum(abs(temp),'omitnan');
temp = squeeze(temp);



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