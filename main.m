B = 1e7;
N = 1e-9;
T = 0.25;
rows = 30;
lArray = zeros(rows, 1);
Q = zeros(rows, 1);



[rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray] = init30(B,N,T);



%step1 
yl = 0;
max = 0;
p = 0;
for i=1:rows
    if(max > aArray(i))
        max = max;

    else
        max = aArray(i);
        p = i;
    end
end
yh = max;
sumtl = 0;
sumth = 0;
sumtm = 0;
ystar = 0;

[sumtl,Q] = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumtl,yl,B,N,T);
[sumth,Q] = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumth,yh,B,N,T);

n = rArray(p)/B*log(B*cArray(p)*pArray(p)*hArray(p)*hArray(p)/N/log(2))/log(2);
disp(n);
m = 0;
for i=1:rows
    a=10;
    for i = 1:rows
        if(aArray(i) > 0)
            if(aArray(i) < a)
                a = aArray(i);
            end
        end
    end
    if(aArray(i) > 0)
        m = m + log(2)*rArray(i)/B/(1+lambertw((a*hArray(i)*hArray(i)-N)/N/exp(1)));
    else
        m = m + log(2)*mArray(i)/B/(1+lambertw((a*hArray(i)*hArray(i)-N)/N/exp(1)));
    end
end
disp(m);


while abs((sumth-T)) > 1e-9 & abs((sumtl-T)) > 1e-9
    ym = (yl + yh)/2;
    sumtm = 0;
    sumtl = 0;
    sumth = 0;
    [sumtm,Q] = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumtm,ym,B,N,T);
    if(abs((sumtm-T)) < 1e-9)
        ystar = ym;
        break;  
    elseif(sumtm < T)
        yh = ym;
    elseif(sumtm > T)
        yl = ym;
    end
    [sumtl,Q] = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumtl,yl,B,N,T);
    [sumth,Q] = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumth,yh,B,N,T);
    %disp(sumtm);
end



totalenergysum = totalsum(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,ystar,B,N);

disp("totalenergysum");
disp(totalenergysum);

x = [0.2,0.21,0.22,0.23,0.24,0.25]; 
y = [8.897777667116962e-05,3.327483682897017e-05,1.404350542031688e-05,7.328746528376e-6,3.187280617119750e-06,1.671158074544050e-06]; % 示例函数，可以替换为自己的函数

% 绘制曲线图
plot(x, y); % 绘制 y 关于 x 的曲线
xlabel('Time slot duration(s)'); % 添加 X 轴标签
ylabel('Total mobile energy consumption(J)'); % 添加 Y 轴标签
title('Effect of slot duration'); % 添加标题
grid on; % 显示网格






function [totalenergysum] = totalsum(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,y,B,N)
    rows = 30;
    lArray = zeros(rows, 1);
    tArray = zeros(rows, 1);
    totalsum = 0;

    for i = 1:rows
        if(vArray(i) <= 1 & mArray(i) == 0)
            lArray(i) = 0;
            tArray(i) = 0;
        elseif(vArray(i) > 1 | mArray(i) > 0)
            if(aArray(i) < y)
                tArray(i) = log(2)*mArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                lArray(i) = mArray(i);
            elseif(aArray(i) == y)
                tArray(i) = log(2)*(rArray(i)/2-mArray(i)/2)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                lArray(i) = rArray(i)/2-mArray(i)/2;
            else
                tArray(i) = log(2)*rArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                lArray(i) = rArray(i);
            end
        end
    end

    for i = 1:rows
        if(tArray(i) == 0)
            totalsum = totalsum + (rArray(i)-lArray(i))*cArray(i)*pArray(i);
        else
            totalsum = totalsum + (rArray(i)-lArray(i))*cArray(i)*pArray(i) + tArray(i)/hArray(i)/hArray(i)*N*(power(2,lArray(i)/tArray(i)/B)-1);
        end
    end
    totalenergysum = totalsum;
    %disp(vArray);
    %disp(mArray);
    %disp(tArray);
end

















