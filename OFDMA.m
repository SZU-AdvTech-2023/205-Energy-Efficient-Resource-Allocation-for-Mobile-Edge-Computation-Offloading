B = 1e6;
N = 1e-9;
T = 0.2;
rows = 20;  %user
b = 128;     %channel

[rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,K1,N1,N2,S,P,aset]=init128a20(B,N,T);


%algorithm4
for i = 1:rows
    P(i,aset(i,2)) = 1;
    N2(N2 == aset(i,2)) = [];
    N1 = [N1,aset(i,2)];
end


%phase2
sumh = 0;
H = zeros(rows, 1);
for i = 1:rows
    for j = 1:rows
        for n = 1:b
            if ismember(n, N2)
                sumh = sumh + hArray(i,n)*hArray(i,n)/T;
            end
        end
    end
    H(i) = sqrt(sumh/length(N2));
    sumh = 0;
end
%进行theorem1
[A,V] = OFDMAComputePriority(rArray,cArray,pArray,fArray,H,aArray,vArray,mArray,B,N,rows,b);
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
suml = 0;
sumh = 0;
[suml,n,l] = sumT(rArray,cArray,pArray,fArray,H,aArray,vArray,mArray,yl,B,N,rows,b);
[sumh,n,l] = sumT(rArray,cArray,pArray,fArray,H,aArray,vArray,mArray,yh,B,N,rows,b);
while sumh ~= length(N2) & suml ~= length(N2)
    ym = (yl + yh)/2;
    summ = 0;
    suml = 0;
    sumh = 0;
    [summ,nstar,L] = sumT(rArray,cArray,pArray,fArray,H,aArray,vArray,mArray,ym,B,N,rows,b);
    if(abs(summ-length(N2)) < 1e-9)
        ystar = ym;
        break;  
    elseif(summ < length(N2))
        yh = ym;
    elseif(summ > length(N2))
        yl = ym;
    end
    [suml,n,l] = sumT(rArray,cArray,pArray,fArray,H,aArray,vArray,mArray,yl,B,N,rows,b);
    [sumh,n,l] = sumT(rArray,cArray,pArray,fArray,H,aArray,vArray,mArray,yh,B,N,rows,b);
    %disp(summ);
end
nstar = floor(nstar);


%phase3
K2 = [];
for i = 1:rows
    if nstar(i) > 0
        K2 = [K2, i];
    end
end

while length(K2) >0
    p = K2(1);
    K2(1) = [];
    max = 0;
    for i=1:length(N2)
        if(max > aArray(p,N2(i)))
            max = max;
        else
            max = aArray(p,N2(i));
            now = i;
        end
    end
    P(p,now) = 1;
    N2(N2 == now) = [];
    N1 = [N1,now];
end
%step2
while length(N2) > 0
    now = N2(1);
    max = 0;
    for i=1:rows
        if(max > aArray(i,now))
            max = max;
        else
            max = aArray(i,now);
            now1 = i;
        end
    end
    N2(1) = [];
    P(now1,now) = 1;
end

bset = zeros(rows, 1);
%phase4
for i = 1:rows
    yl = 0;%phase的未知参数，进行一维搜索
    yh = 10;
    suml = 0;
    sumh = 0;
    suml = sumD(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,yl,T,B,N,P,i,rows,b);
    sumh = sumD(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,yh,T,B,N,P,i,rows,b);
    while sumh ~= L(i) & suml ~= L(i)
        ym = (yl + yh)/2;
        summ = 0;
        suml = 0;
        sumh = 0;
        summ = sumD(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,ym,T,B,N,P,i,rows,b);
        if(abs(summ-L(i)) < 1e-6)
            ystar = ym;
            best(i) = ystar;
            break;  
        elseif(summ < L(i))
            yl = ym;
        elseif(summ > L(i))
            yh = ym;
        end
        suml = sumD(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,yl,T,B,N,P,i,rows,b);
        sumh = sumD(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,yh,T,B,N,P,i,rows,b);
        %disp(summ);
    end
end

final = zeros(rows,b);
for i = 1:rows
    for j = 1:b
        if(P(i,j) == 1)
            M = B*T*log2(best(i)*B*hArray(i,j)*hArray(i,j)/N/log(2));
            if(M > 0)
                final(i,j) = M;
            else
                final(i,j) = 0;
            end
        end
    end
end

%disp(final);
other2 = 0;
other1 = 0;
%计算总消耗
for i = 1:rows
    other2 = other2 + (rArray(i)-L(i))*cArray(i)*pArray(i);
    for j = 1:b
        if P(i,j) > 0
        other1 = other1 + P(i,j)*T*N*(power(2,final(i,j)/P(i,j)/B) - 1)/hArray(i,j)/hArray(i,j);
        end
    end
end
totalenergysum = other1 + other2;
disp(totalenergysum);

x = [4,8,12,16]; 
y = [2.989573013768654e-06,7.417511361521627e-06,1.398517302787096e-05,4.385186731727625e-05];

% 绘制曲线图
plot(x, y); % 绘制 y 关于 x 的曲线

xlabel('Numbers of users'); % 添加 X 轴标签
ylabel('Total mobile energy consumption(J)'); % 添加 Y 轴标签


grid on;



                                                                                                                            



function [sum]=sumD(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,y,T,B,N,P,i,rows,b)
    sum = 0;
    for j = 1:b
        if(P(i,j)~=0)
            sum = sum + B*T*log2(y*B*hArray(i,j)*hArray(i,j)/N/log(2));
        end
    end

end






function [sum,n,L]=sumT(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,y,B,N,rows,b)
    
    sum = 0;
    n = zeros(rows, 1);
    L = zeros(rows, 1);
    for i = 1:rows
        if(vArray(i) <= 1 & mArray(i) == 0)
            sum = sum + 0;
            n(i) = 0;
            L(i) = 0;
        elseif(vArray(i) > 1 | mArray(i) > 0)
            if(aArray(i) < y)
                sum = sum + log(2)*mArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                n(i) = log(2)*mArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                L(i) = mArray(i);
            elseif(aArray(i)==y)
                sum = sum + log(2)*((rArray(i)-mArray(i))/2 + mArray(i))/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                n(i) = log(2)*((rArray(i)-mArray(i))/2 + mArray(i))/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                L(i) = (rArray(i)-mArray(i))/2 + mArray(i);
            else
                sum = sum + log(2)*rArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                n(i) = log(2)*rArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                L(i) = rArray(i);
            end
        end
    end
    
end