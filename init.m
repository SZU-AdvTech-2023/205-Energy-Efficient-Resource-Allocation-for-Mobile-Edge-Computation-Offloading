%初始化
function [rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray]=init(B,N,T)
    % 定义行数和列数
    rows = 30;                                                                                                                                     

    % 生成全零的一维数组
    rArray = zeros(rows, 1);
    cArray = zeros(rows, 1);
    pArray = zeros(rows, 1);
    fArray = zeros(rows, 1);
    hArray = zeros(rows, 1);
    aArray = zeros(rows, 1);
    vArray = zeros(rows, 1);
    mArray = zeros(rows, 1);
    % 输入数据R
    minValue1 = 100;
    maxValue1 = 500;
    for i = 1:30
        % 生成一个在[minValue, maxValue]范围内的随机整数
        rArray(i) = randi([minValue1, maxValue1])*1024*8 ;
    end
    % kth设备上计算1bit所需的cpu周期
    minValue2 = 500;
    maxValue2 = 1500;
    for i = 1:30
        % 生成一个在[minValue, maxValue]范围内的随机整数
        cArray(i) = randi([minValue2, maxValue2]) ;
    end  
    % 一个cpu cycle所消耗的能量
    pArray = [0.0497e-12,0.1166e-11,0.1491e-14,0.1753e-16,0.1406e-16,0.0731e-15,0.0212e-18,0.0517e-13,0.1457e-15,0.0072e-19,0.1168e-14,0.1673e-18,0.1896e-11,0.1009e-17,0.0728e-14,0.1687e-19,0.1782e-14,0.0063e-19,0.0341e-17,0.1125e-12,0.0182e-17,0.1043e-19,0.0155e-15,0.0277e-19,0.0614e-16,0.1253e-16,0.0325e-17,0.0289e-11,0.0283e-17,0.0957e-19]';
    % kth设备的cpu能力
    myArray = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
    for i = 1:30
        % 生成一个随机索引 
        randomIndex = randi(length(myArray));
        % 从数组中获取随机选择的元素
        fArray(i) = myArray(randomIndex )*1e9;
    end

    % 参数设置
    num_channels = 200; % 信道数量
    average_power_loss = 1e-3; % 平均功率损耗设为10的负3次方
    num_users = 30; % 用户数量

    % 模拟信道瑞利衰落
    channel_gains = sqrt(average_power_loss) * (randn(num_users, num_channels) + 1i * randn(num_users, num_channels));

    % 用户选择信道
    selected_channels = randi([1, num_channels], 1, num_users);
    hArray = selected_channels';

    %计算v
    for i = 1:30
            vArray(i) = B*cArray(i)*pArray(i)*hArray(i)*hArray(i)/N/log(2);
    end

    %计算优先级
    for i = 1:30
        if(vArray(i) < 1) 
            aArray(i) = 0.0;
        else 
            aArray(i) = N*(vArray(i)*log(vArray(i))-vArray(i)+1)/hArray(i)/hArray(i);
        end
    end

    for i = 1:30
        mArray(i) = rArray(i)-T*fArray(i)/cArray(i);
        if(mArray(i) < 0)
            mArray(i) = 0;
        end
    end
    format long;
    %disp(mArray);
    fileID = fopen('data.txt', 'w');

    % 将数据写入文件
    fprintf(fileID, 'rArray=');
    fprintf(fileID, '%e,', rArray);
    fprintf(fileID, '\ncArray=');
    fprintf(fileID, '%e,', cArray);
    fprintf(fileID, '\npArray=');
    fprintf(fileID, '%e,', pArray);
    fprintf(fileID, '\nfArray=');
    fprintf(fileID, '%e,', fArray);
    fprintf(fileID, '\nhArray=');
    fprintf(fileID, '%e,', hArray);

    fclose(fileID);
end



