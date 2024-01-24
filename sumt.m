%计算T
function [sum,lArray]=sumt(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,sum,y,B,N,T)
    rows = 30;
    lArray = zeros(rows, 1);
    tag = zeros(rows, 1);
    sumn = 0;
    summ = 0;
    suma = 0;
    for i = 1:30
        if(vArray(i) <= 1 & mArray(i) == 0)
            sum = sum + 0;
            lArray(i) = 0;
        elseif(vArray(i) > 1 | mArray(i) > 0)
            if(aArray(i) < y)
                sum = sum + log(2)*mArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
            elseif(abs(aArray(i)-y) < 1e-9)
                % sum = sum + log(2)*mArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                summ = summ + log(2)*rArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                sum = sum + log(2)*((rArray(i)-mArray(i))/2 + mArray(i))/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                tag(i) = 1;
                lArray(i) = mArray(i);
            else
                sum = sum + log(2)*rArray(i)/B/(1+lambertw((y*hArray(i)*hArray(i)-N)/N/exp(1)));
                lArray(i) = rArray(i);
            end
        end
    end
    
end
