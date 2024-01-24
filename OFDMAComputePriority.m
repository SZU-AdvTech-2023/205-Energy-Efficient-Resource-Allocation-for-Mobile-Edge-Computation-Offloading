function [aArray,vArray] = OFDMAComputePriority(rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,B,N,rows,b)
    for i=1:rows
        vArray(i) = B*cArray(i)*pArray(i)*hArray(i)*hArray(i)/N/log(2);
    end

    for i=1:rows
        if(vArray(i) < 1)
            aArray(i) = 0;
        else
            aArray(i) = N*(vArray(i)*log(vArray(i))-vArray(i)+1)/hArray(i)/hArray(i);
        end
    end
    %disp(vArray);

end