clc
clear

%% 合并三个数据文件的运动学片段

a=importdata('1-recordv1.mat');
b=importdata('2-recordv1.mat');
c=importdata('3-recordv1.mat');

d=[a;b;c];

e=importdata('1-allrecordv1.mat');
f=importdata('2-allrecordv1.mat');
g=importdata('3-allrecordv1.mat');

h=[e;f;g];
