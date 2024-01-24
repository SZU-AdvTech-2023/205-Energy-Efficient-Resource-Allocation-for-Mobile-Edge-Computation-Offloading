B = 1e7;
N = 1e-9;
T = 10;
F = 6e9;
rows = 30;
lArray = zeros(rows, 1);

[rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray] = initforfinite30(B,N,T);

%step1
yl = 0;
max = 0;
for i=1:rows
    if(max > aArray(i))
        max = max;
    else
        max = aArray(i);
    end
end
yh = max;
sumtl = 0;
sumth = 0;
sumtm = 0;
ystar = 0;
sumtl = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumtl,yl,B,N,rows);
sumth = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumth,yh,B,N,rows);
while abs((sumth-T)) > 1e-9 & abs((sumtl-T)) > 1e-9
    ym = (yl + yh) / 2;
    sumtm = 0;
    sumtl = 0; 
    sumth = 0;
    sumtm = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumtm,ym,B,N,rows);
    if(abs((sumtm-T)) < 1e-9)
        ystar = ym;
        break;  
    elseif(sumtm < T)
        yh = ym;
    elseif(sumtm > T)
        yl = ym;
    end
    sumtl = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumtl,yl,B,N,rows);
    sumth = sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sumth,yh,B,N,rows);
end
totalL = ComputeF(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,ystar,0,F,rows);


%step2
ul = 0;
max = 0;
for i=1:rows
    n = pArray(i)-N*log(2)/B/cArray(i)/hArray(i)/hArray(i);
    disp(n);
    if(max > n)
        max = max;
    else
        max = n;
    end
end
uh = max;
if(totalL < F)
    disp("最优解");
else
    [alArray,vlArray] = ComputePriority(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,B,N,ul,rows);
    [ahArray,vhArray] = ComputePriority(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,B,N,uh,rows);
    sumFl = ComputeF(rArray,cArray,pArray,fArray,hArray,alArray,vlArray,mArray,ul,0,F,rows);
    sumFh = ComputeF(rArray,cArray,pArray,fArray,hArray,ahArray,vhArray,mArray,uh,0,F,rows);
%step3
    while sumFl ~= F & sumFh ~= F
        um = (ul + uh) / 2;
        sumFm = 0;
        sumFl = 0;
        sumFh = 0;
        ustar = 0;
        [amArray,vmArray] = ComputePriority(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,B,N,um,rows);
        [sumFm,lArray] = ComputeF(rArray,cArray,pArray,fArray,hArray,amArray,vmArray,mArray,um,1,F,rows);
        if(sumFm == F)
            ustar = um;
            break;  
        elseif(sumFm < F)
            uh = um;
        elseif(sumFm > F)
            ul = um;
        end

        [alArray,vlArray] = ComputePriority(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,B,N,ul,rows);
        [ahArray,vhArray] = ComputePriority(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,B,N,uh,rows);
        [sumFl,lArray] = ComputeF(rArray,cArray,pArray,fArray,hArray,alArray,vlArray,mArray,ul,0,F,rows);
        [sumFh,lArray] = ComputeF(rArray,cArray,pArray,fArray,hArray,ahArray,vhArray,mArray,uh,0,F,rows);
        %disp(sumFm);
        %disp(um);
    end
    totalenergysum = totalsum(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,ustar,B,N,lArray,rows);

disp("totalenergysum");
disp(totalenergysum);

end
%disp(ustar);

x = [3,4,5,6,7,8]; 
y = [0.003477919016118,0.001167973160217,0.001167972597905,5.972333934532441e-04,5.972332695626192e-04,5.972331456719941e-04];
y1 = [0.002500017495820,9.535807387957452e-04,9.535807387957452e-04,4.730818414864506e-04,4.730818414864506e-04,1.875926580184900e-04];



% 绘制曲线图
plot(x, y,'-r', 'LineWidth', 2); % 绘制 y 关于 x 的曲线
hold on;
plot(x, y1,'--b', 'LineWidth', 2);
xlabel('Cloud computation capacity(10e9cycles/slot)'); % 添加 X 轴标签
ylabel('Total mobile energy consumption(J)'); % 添加 Y 轴标签
title('Effect of the cloud computation capacity'); % 添加标题
legend('Optimal Resource-allocation', 'Sub-optimal Resource-allocation');
grid on;




function [totalenergysum] = totalsum(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,y,B,N,lArray,rows)
    tArray = zeros(rows, 1);
    totalsum = 0;

    for i = 1:rows
        if(vArray(i) <= 1 & mArray(i) == 0)
            %lArray(i) = 0;
            tArray(i) = 0;
        elseif(vArray(i) > 1 | mArray(i) > 0)
            if(aArray(i) < y)
                tArray(i) = log(2)*mArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                %lArray(i) = mArray(i);
            elseif(aArray(i) == y)
                tArray(i) = log(2)*(rArray(i)/2-mArray(i)/2)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                %lArray(i) = rArray(i)/2-mArray(i)/2;
            else
                tArray(i) = log(2)*rArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                %lArray(i) = rArray(i);
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










%计算l的和
function [sum] = SumL(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,y,rows)
    sum = 0;
    for i=1:rows
        if(vArray(i) <= 1 & mArray(i) == 0)
            sum = sum + 0;
        elseif(vArray(i) > 1 | mArray(i) > 0)
            if(aArray(i) < y)
                sum = sum + mArray(i);
            elseif(aArray(i) == y)
                sum = sum + ((rArray(i)-mArray(i))/2+mArray(i));
            else
                sum = sum + rArray(i);
            end
        end
    end
end



%计算T，算法一所需要的
function [sum]=sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sum,y,B,N,rows)
    for i = 1:rows
        if(vArray(i) <= 1 & mArray(i) == 0)
            sum = sum + 0;
        elseif(vArray(i) > 1 | mArray(i) > 0)
            if(aArray(i) < y)
                sum = sum + log(2)*mArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
            elseif(abs(aArray(i)-y) < 1e-9)
                sum = sum + log(2)*((rArray(i)-mArray(i))/2+mArray(i))/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
            else
                sum = sum + log(2)*rArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
            end
        end
    end
end