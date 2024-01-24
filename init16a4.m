function [rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,K1,N1,N2,S,P,aset] = init16a4(B,N,T)
    % 定义行数和列数
    rows = 4;
    b = 16;


    % 生成全零的一维数组
    rArray = zeros(rows, 1);
    cArray = zeros(rows, 1);
    pArray = zeros(rows, 1);
    fArray = zeros(rows, 1);
    hArray = zeros(rows, b);
    aArray = zeros(rows, b);
    vArray = zeros(rows, b);
    mArray = zeros(rows, 1);


    rArray = [819200,2662400,1564672,1359872]';
    cArray = [569,742,1097,982]';
    pArray = [0.0497e-12,0.1166e-11,0.1491e-14,0.1753e-16]';
    fArray = [0.2000,0.8000,1.000,0.4000]';
    fArray = fArray*1e9;

    % 合并为独立瑞利衰落信道
    hArray = [0.022445054698356   0.009991191653190   0.032623856083126   0.021471326665307 0.030431697804687   0.011467068177863   0.015524444395603   0.023244306445689   0.040533730681053   0.009313569696671   0.056567616621159   0.026839743271111    0.025865485690701   0.030428613397444   0.049556176089730   0.032444091995940
   0.049449821076077   0.045851646763162   0.028856475227923   0.011536084562246    0.024672472860663   0.054002103175205   0.005715019518960   0.020046812220746   0.036220767876294   0.023061734412746   0.045402034855407   0.040564198189816    0.001332969166821   0.039965913793648   0.013522193279741   0.053608948594687
   0.009428588572814   0.027218747689559   0.034383354360712   0.011691667792388    0.011799039348226   0.020207067265975   0.012628914644885   0.010555466272290   0.045003050395913   0.004947546906604   0.022758908736100   0.011463204261762    0.017459173009728   0.031352704317129   0.015385426164869   0.022842282790397
   0.023624851453087   0.018601328122079   0.025417476357453   0.049059474228265    0.038919966825191   0.073598378077343   0.037591350792348   0.021871319736909   0.024777875660051   0.028289418305684   0.032844505267258   0.026641602976961    0.041303870241926   0.033285751046839   0.046745213032072   0.018808874719360];
    
    for i = 1:rows                                                  
        mArray(i) = rArray(i)- T*fArray(i) / cArray(i);
        if(mArray(i) < 0)
            mArray(i) = 0;
        end 
    end
    for i = 1:rows
        for j = 1:b
            vArray(i,j) = B*cArray(i)*pArray(i)*hArray(i,j)*hArray(i,j)/N/log(2);
        end
    end
    for i = 1:rows
        for j = 1:b
            if(vArray(i,j) < 1)
                aArray(i,j) = 0;
            else
                aArray(i,j) = N*(vArray(i,j)*log(vArray(i,j))-vArray(i,j)+1)/hArray(i,j)/hArray(i,j);
            end
        end
    end
    K1 = [1,2,3,4]';
    N1 = [];
    N2=[];
    for i = 1:b
        N2 = [N2,i];
    end
    S = zeros(rows, b);%待定
    P = zeros(rows, b);
    aset = zeros(rows, 2);
    now = zeros(rows, 1);
    now1 = zeros(rows, 1);
    for i = 1:rows
        [sortedArr, indices] = sort(aArray(i,:),'descend');
        now(i) = indices(1);
        now1(i) = aArray(i,indices(1));
    end
    [sortedArr, ind] = sort(now1,'descend');
    for i = 1:rows
        aset(i,1) = ind(i);
        aset(i,2) = now(ind(i));
    end
    


    %disp(mArray);
end