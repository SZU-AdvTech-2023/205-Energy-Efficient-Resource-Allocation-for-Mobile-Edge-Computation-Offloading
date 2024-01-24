x = [10,15,20,25,30]; 
%y = [2.034626187406212e-05,2.830859711768372e-04,2.861814150051198e-04,2.862232073903207e-04,5.972331456719941e-04];
%y1 = [1.337610486499611e-05,1.712007422752263e-04,1.826706202920411e-04,1.827124126772420e-04,4.730818414864506e-04];

y = [2.781913906710867e-04,2.830686359336344e-04,5.971327552461990e-04,0.002907118721201,0.003477888082582];
y1 = [1.643311353362953e-04,1.751858895675856e-04,4.744894432444247e-04 0.002084700399827,0.004908042953380];

% 绘制曲线图
plot(x, y,'-r', 'LineWidth', 2); % 绘制 y 关于 x 的曲线
hold on;
plot(x, y1,'--b', 'LineWidth', 2);
xlabel('Cloud computation capacity(10e9cycles/slot)'); % 添加 X 轴标签
ylabel('Total mobile energy consumption(J)'); % 添加 Y 轴标签
title('Effect of the cloud computation capacity'); % 添加标题
legend('Optimal Resource-allocation', 'Sub-optimal Resource-allocation');
grid on;