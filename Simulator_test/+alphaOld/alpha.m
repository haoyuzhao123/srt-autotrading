function ret = alpha(day)
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

%-----fill in the implementation of the alpha here-----

data = stocksBasicData(9, : ,(day-5):(day-1));
temp = -sum(data,3,'omitnan') / 5;
temp = temp / sum(abs(temp));
temp = squeeze(temp);

for i=1:size(temp),
    if isnan(temp(i)),
        temp(i) = 0;
    end
end

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

