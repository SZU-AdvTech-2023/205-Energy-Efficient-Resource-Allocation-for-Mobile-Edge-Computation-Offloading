% 假设你有一个数组
arr = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];

% 使用 sort 函数对数组进行排序，并返回排序后的数组和对应的索引
%[sortedArr, indices] = sort(arr, 'descend');
[sortedArr, indices] = sort(arr);

% 输出结果
disp('原始数组:');
disp(arr);

disp('排序后的数组:');
disp(sortedArr);

disp('对应的索引:');
disp(indices);