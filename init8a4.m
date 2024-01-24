function [rArray,cArray,pArray,fArray,hArray,aArray,vArray,mArray,K1,N1,N2,S,P,aset] = init8a4(B,N,T)
    % 定义行数和列数
    rows = 4;  %user
    b = 8;     %channel


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
    hArray = [0.0180,0.0278,0.0223,0.0349,0.0323,0.0141,0.0341,0.0026,
            0.0173,0.0236,0.0287,0.0114,0.0311,0.0131,0.0298,0.0216,
            0.0395,0.0341,0.0548,0.0321,0.0452,0.0750,0.0625,0.0135,
            0.0192,0.0419,0.0385,0.0350,0.0141,0.0456,0.0092,0.0162];
    
    for i = 1:4                                                   
        mArray(i) = rArray(i)- T*fArray(i) / cArray(i);
        if(mArray(i) < 0)
            mArray(i) = 0;
        end 
    end
    for i = 1:4
        for j = 1:8
            vArray(i,j) = B*cArray(i)*pArray(i)*hArray(i,j)*hArray(i,j)/N/log(2);
        end
    end
    for i = 1:4
        for j = 1:8
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
    for i = 1:4
        [sortedArr, indices] = sort(aArray(i,:),'descend');
        now(i) = indices(1);
        now1(i) = aArray(i,indices(1));
    end
    [sortedArr, ind] = sort(now1,'descend');
    for i = 1:4
        aset(i,1) = ind(i);
        aset(i,2) = now(ind(i));
    end
    


    %disp(mArray);
end