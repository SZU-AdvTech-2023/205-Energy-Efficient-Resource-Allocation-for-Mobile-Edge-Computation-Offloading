x = [8,16,32,64,128,256]; 

y = [1.826163525940376e-06,1.556639927512583e-06,3.548758277768614e-06,1.648765469238367e-06, 2.989573013768654e-06,4.548839490262064e-06];

% 绘制曲线图
plot(x, y); % 绘制 y 关于 x 的曲线

xlabel('Numbers of sun-channels'); % 添加 X 轴标签
ylabel('Total mobile energy consumption(J)'); % 添加 Y 轴标签


grid on;

%x = [4,8,12,16]; 

%y = [2.989573013768654e-06,7.417511361521627e-06,1.398517302787096e-05,4.385186731727625e-05];

% 绘制曲线图
%plot(x, y); % 绘制 y 关于 x 的曲线

%xlabel('Numbers of users'); % 添加 X 轴标签
%ylabel('Total mobile energy consumption(J)'); % 添加 Y 轴标签


%grid on;