%% 主成分分析程序
%% 功能：实现对贡献率，累计贡献率，主成分载荷因子的计算
%% 调通时间：2019.9.15
clc
clear
%% 数据加载
a=importdata('all_microtrip.mat');
[s,t]=size(a);
%% 数据标准化处理
b=zscore(a);%对数据进行标准化处理
%% 标准化后矩阵的协方差、特征值、特征向量
M=corrcoef(b);%协方差
[V,D]=eig(M);%求出协方差矩阵的特征向量、特征根
d=diag(D);%取出特征根矩阵列向量（提取出每一主成分的贡献率） 
%% 贡献率和累计贡献率
eig1=sort(d,'descend')%将贡献率按从大到小元素排列
v=fliplr(V);%依照D重新排列特征向量
%% 按照规则选取合适的主成分个数
S=0;
i=0;
while S/sum(eig1)<0.85
 i=i+1;
S=S+eig1(i);
end%求出累积贡献率大于85%的主成分
disp('贡献率')
W=100*eig1/sum(eig1)
disp('累计贡献率');
W1=cumsum(W)
disp('各个主成分的占比')
rate_eig1=100*eig1./sum(eig1)
%% 所选取的每一个主成分的载荷
disp('主成分的载荷')
for m=1:i
    zai_he(:,:,m)=sqrt(eig1(m,:)).*v(:,m);%计算每一个主成分的载荷
end
zai_he
for m=1:i
    for n=1:s
    score(n,m)=sum(zai_he(:,:,m).*b(n,:)');
    end
end
%% 绘图
figure(1)
pareto(W);%画出贡献率的直方图
title('贡献率的直方图');
figure(2)
plot(eig1,'ko');
hold on
plot(eig1,'b-');%碎石图
xlabel('主成分个数')
ylabel('主成分对应的贡献值')
figure(3)
pie3(rate_eig1,[1 1 1 1 1 1 1 1 1 1 ])%饼图



