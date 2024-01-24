 function [sum,lArray] = ComputeF(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,y,p,F,rows)
    
    lArray = zeros(rows, 1);
    tag = zeros(rows, 1);
    sum = 0;
    summ = 0;
    sumn = 0;
    suma = 0;
    for i = 1:rows
        if(vArray(i) <= 1 & mArray(i) == 0)
            sum = sum + 0;
            lArray(i) = 0;
        elseif(vArray(i) > 1 | mArray(i) > 0)
            if(aArray(i) < y)
                sum = sum + cArray(i)*mArray(i);
                lArray(i) = mArray(i);
            elseif(abs(aArray(i)-y) < 1e-9)
                %sum = sum + cArray(i)*((rArray(i)-mArray(i))/2+mArray(i));
                %sum = sum + cArray(i)*randi([mArray(i), rArray(i)]);
                summ = summ + cArray(i)*rArray(i);
                sumn = sumn + cArray(i)*mArray(i);
                suma = suma + cArray(i)*((rArray(i)-mArray(i))/2+mArray(i));
                tag(i) = 1;
                lArray(i) = mArray(i);
            else
                sum = sum + cArray(i)*rArray(i);
                lArray(i) = rArray(i);
            end
        end
    end
    m = F - sum;
    %disp(m);
    if(m<summ & m>sumn)
       sum = F;
    else
        sum = sum + sumn;
    end
    m = m - sumn;
    [sortedArr, indices] = sort(cArray*pArray');
    for i = 1:rows
        if(tag(indices(i)) == 1)
            if(cArray(indices(i))*(rArray(indices(i))-cArray(indices(i))*mArray(indices(i))) < m)
                lArray(indices(i)) = rArray(indices(i));
                m = m - cArray(indices(i))*(rArray(indices(i))-mArray(indices(i)));
            else
                lArray(indices(i)) = mArray(indices(i)) + m/fArray(indices(i));
        end
    end
end