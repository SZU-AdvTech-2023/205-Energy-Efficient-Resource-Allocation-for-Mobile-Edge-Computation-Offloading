B = 1e7;
N = 1e-9;
T = 10;
F = 6e9;
rows = 30;


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
sumf = 0;
rrArray =  zeros(rows, 1);
if(totalL < F)
    disp("最优解");
else
    [sortedArr, indices] = sort(aArray, 'descend');
    rrArray = mArray;
    for i = 1:rows
        sumf  = sumf + cArray(indices(i))*mArray(indices(i));
    end
    for i = 1:rows
        sumf  = sumf + cArray(indices(i))*(rArray(indices(i))-mArray(indices(i))); 
        rrArray(indices(i)) = rArray(indices(i));
        if(sumf > F)
            p = (F - sumf)/cArray(indices(i));
            rrArray(indices(i)) = abs(p);
            ystar = aArray(indices(i));
            break;
        end
    end

end
totalenergysum = totalsum(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,ystar,B,N,rows);
disp(rrArray);
disp("totalenergysum");
disp(totalenergysum);






function [totalenergysum] = totalsum(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,y,B,N,rows)
    
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

