function [rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray]=initforfinite10(B,N,T)
    % 定义行数和列数
    rows = 10;

    % 生成全零的一维数组
    rArray = zeros(rows, 1);
    cArray = zeros(rows, 1);
    pArray = zeros(rows, 1);
    fArray = zeros(rows, 1);
    hArray = zeros(rows, 1);
    aArray = zeros(rows, 1);
    vArray = zeros(rows, 1);
    mArray = zeros(rows, 1);

    
    rArray=[3.948544e+06,1.409024e+06,2.826240e+06,2.924544e+06,2.473984e+06,1.712128e+06,8.519680e+05,3.997696e+06,1.900544e+06,2.793472e+06]';
    cArray=[1.314000e+03,1.406000e+03,5.590000e+02,9.320000e+02,1.023000e+03,6.840000e+02,9.350000e+02,8.430000e+02,1.485000e+03,9.560000e+02]';
    pArray=[4.970000e-14,1.166000e-12,1.491000e-15,1.753000e-17,1.406000e-17,7.310000e-17,2.120000e-20,5.170000e-15,1.457000e-16,7.200000e-22]';
    fArray=[9.000000e+08,7.000000e+08,5.000000e+08,1.000000e+08,6.000000e+08,6.000000e+08,6.000000e+08,1.000000e+09,9.000000e+08,4.000000e+08]';
    hArray=[1.030000e+02,8.900000e+01,1.880000e+02,9.000000e+01,2.300000e+01,8.500000e+01,1.200000e+02,8.400000e+01,4.300000e+01,6.200000e+01]';
    
    
    
    
    
    
    %计算v
    for i = 1:rows
       vArray(i) = B*cArray(i)*pArray(i)*hArray(i)*hArray(i)/N/log(2);
    end

    %计算优先级
    for i = 1:rows
        if(vArray(i) < 1) 
            aArray(i) = 0.0;
        else 
            aArray(i) = N*(vArray(i)*log(vArray(i))-vArray(i)+1)/hArray(i)/hArray(i);
        end
    end
  
    for i = 1:rows                                                  
        mArray(i) = rArray(i)- T*fArray(i) / cArray(i);
        if(mArray(i) < 0)
            mArray(i) = 0;
        end 
    end
    format long;
    %disp(mArray);
   
end