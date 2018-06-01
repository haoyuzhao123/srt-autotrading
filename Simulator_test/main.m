%checked, can be reduced

%the main function for the whole project
%this function do not need to always keep the same
%it is free to modify and change

clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following part should always remain the same

%load the data matrix
temp1 = load('stocksBasicData.mat');
temp2 = load('stocksMonthData.mat');
temp3 = load('stocksWeekData.mat');
temp4 = load('index.mat');

%import the packages
import alphaOld.*
import alphaPkg.*

%set the global variable
global stocksBasicData;
global stocksMonthData;
global stocksWeekData;
global index;

global MAX_STOCKS;
global MAX_DAYS;
global MAX_FEATURES;

global nan_index;

stocksBasicData = temp1.stocksBasicData; 

stocksMonthData = temp2.stocksMonthData;
stocksWeekData = temp3.stocksWeekData;
index = temp4.index;
MAX_STOCKS = 3500;
MAX_DAYS = 1600;
MAX_FEATURES = 10;

nan_index = squeeze(isnan(stocksBasicData(1,:,:)));
size(nan_index)

%process the stocksBasicDataMatrix
temp = size(nan_index);
temp_len = temp(2);
for i = 2:temp_len,
    nan_index_temp = nan_index(:,i);
    prev_price = stocksBasicData(1,:,i-1);
    cur_price = stocksBasicData(1,:,i);
    cur_price(nan_index_temp) = prev_price(nan_index_temp);
    stocksBasicData(1,:,i) = cur_price;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------the alphas that needs to be test----------
alpha_vec = {
      @alphaPkg.alpha_2,
      @alphaPkg.alpha_3,
      @alphaPkg.alpha_6,
      @alphaPkg.alpha_08,
      %@alphaPkg.alpha_12,
      %@alphaPkg.alpha_13,
      @alphaPkg.alpha_14,
      %@alphaPkg.alpha_16,
      @alphaPkg.alpha_33,
      %@alphaPkg.alpha_41,
      %@alphaPkg.alpha_42,
      %@alphaPkg.alpha_53,
      %@alphaPkg.alpha_54,
      %@alphaPkg.alpha_101
      %@alphaPkg.alpha_5,
      %@alphaPkg.alpha_8,
      %@alphaPkg.alpha_08,
      %@alphaPkg.alpha_8_sig,
      @alphaPkg.alpha_11,
      @alphaPkg.alpha_15,
      @alphaPkg.alpha_22
    };

name_vec = {
      'alpha_2';
      'alpha_3';
      'alpha_6';
      'alpha_08';
      %'alpha_12';
      %'alpha_13';
      'alpha_14';
      %'alpha_16';
      'alpha_33';
      %'alpha_41';
      %'alpha_42';
      %'alpha_53';
      %'alpha_54';
      %'alpha_101';
      %'alpha_5';
      %'alpha_8_2';
      %'alpha_08_2';
      %'alpha_8_sig_2';
      'alpha_11';
      'alpha_15';
      'alpha_22';
   };

begin_day = [290;790;1010;1170];
end_day = [790;1010;1170;1290];
%------------the end of the alphas vec--------------
[n,m] = size(alpha_vec);
for i=1:n,
for j = (i+1):n,
for t = 2:4,
    %should decide the starting day and the finishing day
    %the initial money should also be decided.
    % test interval 1£¬ normal
%     begin_day = 290;
%     end_day = 790;
    %test interval 2, bull
%     begin_day = 790;
%     end_day = 1010;
    %test interval 3, bear
%     begin_day = 1010;
%     end_day = 1170;
    %test interval 4, normal
%     begin_day = 1170;
%     end_day = 1290;
    
    
    initial_money = 6000000;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %---the following part of the codes should not be changed----
    %---the codes to combine the alpha signals---
    alpha_func1 = alpha_vec{i};
    alpha_func2 = alpha_vec{j};
    alpha_func = @(d)(sign(alpha_func1(d)) .* sign(alpha_func2(d)) .* sqrt(abs(alpha_func1(d))) .* sqrt(abs(alpha_func2(d))));
    %---end of combination---
    status_cum = simulator(begin_day(t),end_day(t),initial_money, alpha_func);

    money_total = status_cum(MAX_STOCKS+2,:);
    ret_ratio = money_total ./ money_total(1);
    ret_ratio = reshape(ret_ratio,[],1);
    [max_withdraw, vec_withdraw] = withdraw(ret_ratio,50);
    testRes(money_total, begin_day(t), end_day(t), vec_withdraw, ['pic_' , name_vec{i}, '_', name_vec{j}, 'time_', num2str(t), '_geometric_mean_with_sign.fig']);
    %---you can add other operations for testing below----

    %-----------------------------------------------------
end
end
end
