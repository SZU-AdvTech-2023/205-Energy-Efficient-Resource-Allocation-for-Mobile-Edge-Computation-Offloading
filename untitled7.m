num_channels = 128;  % 子信道数量
num_users = 20;  % 用户数量
average_power_loss = 1e-3;  % 平均功率损耗

% 生成独立瑞利衰落信道的实部和虚部
real_parts = sqrt(average_power_loss/2) * randn(num_channels, num_users);
imaginary_parts = sqrt(average_power_loss/2) * randn(num_channels, num_users);

% 合并为独立瑞利衰落信道
rayleigh_channels = complex(real_parts, imaginary_parts);


% 显示第一个用户的前 5 个子信道的模
disp('第一个用户的前 5 个子信道的模：');
disp(abs(rayleigh_channels));
