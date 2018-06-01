function testRes( money,Begin,End, wd, str )
    global index;
    h = figure;
    plot(money./money(1),'-r','LineWidth',1);  %return ratio of the current policy
    hold on;
    plot(index((Begin-1):End)./index(Begin-1),'-b','LineWidth',0.5);     %HS500 index
    hold on;
    %plot the out performance of the current strategy
    plot(money'./money(1) - index((Begin-1):End)./index(Begin-1),'-g','LineWidth',1)
    %plot the withdraw
    hold on;
    plot(wd,'-m','LineWidth',1)
    xlabel('days');
    ylabel('return ratio');
    title('Return Ratio Comparison');
    legend('current policy','HS300 index','out performance','withdraw');
    savefig(h,str);
end

