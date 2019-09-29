clc
clear

b=importdata('../combine/all_microtripv1.mat');
c=importdata('../combine/all_datav1.mat');
% x2=zscore(a);
% y2=pdist(x2,'euclidean');
% z2=linkage(y2,'centroid');
% c2=cophenet(z2,y2);
% t=cluster(z2,3);
% h=dendrogram(z2);

%% 根据主成分分析结果，去除掉减速时间比与怠速时间比
a=b;
a(:,10)=[];
a(:,8)=[];

X=a;
%用kmeans算法确定最佳聚类数目
numc=15;
silh_m=zeros(1,numc);
for i=1:numc
    kidx=kmeans(X,i);
    silh=silhouette(X,kidx);%计算轮廓值
    silh_m(i)=mean(silh);
end
figure
plot(1:numc,silh_m,'o-')
xlabel('类别数');
ylabel('平均轮廓值');
title('不同类别对应的平均轮廓值');

%绘制2至5类时的平均值分布图
figure
for i=2:5
    kidx=kmeans(X,i);
    subplot(2,2,i-1);
    [~,h]=silhouette(X,kidx);%画出轮廓值
    title([num2str(i),'类时的轮廓值']);
    snapnow
    xlabel('轮廓值');
    ylabel('类别数');
end


%kmeans聚类过程，并将结果显示
[idx,ctr,sumD,D]=kmeans(X,2);
figure
F1=plot(find(idx==1),a(idx==1),'r--*',...
    find(idx==2),a(idx==2),'b:o');
set(gca,'linewidth',2);
set(F1,'linewidth',2,'MarkerSize',8);
xlabel('编号');
ylabel('得分');
title('聚类结果');
%层次聚类的聚类过程
Y=pdist(X);%计算样本点间的欧式距离
Z=linkage(Y,'average');
cn=size(X);
clabel=1:cn;
clabel=clabel';

% %kmeans聚类过程，并将结果显示
% [idx,ctr]=kmeans(X,4);
% figure
% F1=plot(find(idx==1),a(idx==1),'r--*',...
%     find(idx==2),a(idx==2),'b:o',...
%     find(idx==3),a(idx==3),'k:o',...
%     find(idx==4),a(idx==4),'g:d');
% set(gca,'linewidth',2);
% set(F1,'linewidth',2,'MarkerSize',8);
% xlabel('编号');
% ylabel('得分');
% title('聚类结果');
% %层次聚类的聚类过程
% Y=pdist(X);%计算样本点间的欧式距离
% Z=linkage(Y,'average');
% cn=size(X);
% clabel=1:cn;
% clabel=clabel';


figure
F2=dendrogram(Z);
title('层次聚类法聚类结果');
set(F2,'linewidth',2);
ylabel('标准距离');


%% 进行聚类后的时间比分析
[m,n]=size(idx);
cls_1=0; %分类一数目
cls_2=0; %分类二数目

% cls_3=0; %分类三数目

for i = 1:m
    if idx(i,1)==1
        cls_1=cls_1+1;
%     elseif idx(i,1)==3
%         cls_3=cls_3+1;
    else
        cls_2=cls_2+1;
    end
end

%进行各行驶状态的时间统计
sum_ti1=0;
sum_ta1=0;
sum_td1=0;
sum_tc1=0;
sum_ti2=0;
sum_ta2=0;
sum_td2=0;
sum_tc2=0;


% sum_ti3=0;
% sum_ta3=0;
% sum_td3=0;
% sum_tc3=0;

sum_t1=0;
sum_t2=0;

% sum_t3=0;

[row,roll]=size(b);
for i = 1:row
    cls=idx(i,1);
    if cls==1
        sum_ti1 = sum_ti1 + c(i,7);
        sum_ta1 = sum_ta1 + c(i,5);
        sum_td1 = sum_td1 + c(i,6);
        sum_tc1 = sum_tc1 + c(i,8);
        sum_t1 = sum_t1 + c(i,4);
        
        
%     elseif cls==3
%         sum_ti3 = sum_ti3 + c(i,7);
%         sum_ta3 = sum_ta3 + c(i,5);
%         sum_td3 = sum_td3 + c(i,6);
%         sum_tc3 = sum_tc3 + c(i,8);
%         sum_t3 = sum_t3 + c(i,4);   
        
        
    else
        sum_ti2 = sum_ti2 + c(i,7);
        sum_ta2 = sum_ta2 + c(i,5);
        sum_td2 = sum_td2 + c(i,6);
        sum_tc2 = sum_tc2 + c(i,8);
        sum_t2 = sum_t2 + c(i,4);
    end
end

% 计算出各行驶状态的时间比例
pi1 = sum_ti1/sum_t1;
pa1 = sum_ta1/sum_t1;
pd1 = sum_td1/sum_t1;
pc1 = sum_tc1/sum_t1;
pi2 = sum_ti2/sum_t2;
pa2 = sum_ta2/sum_t2;
pd2 = sum_td2/sum_t2;
pc2 = sum_tc2/sum_t2;


% pi3 = sum_ti3/sum_t3;
% pa3 = sum_ta3/sum_t3;
% pd3 = sum_td3/sum_t3;
% pc3 = sum_tc3/sum_t3;


%作图分析
%x=['怠速',' 加速',' 减速',' 巡航'];
% y1=[pi1 pi2];
% y2=[pa1 pa2];
% y3=[pd2 pd2];
% y4=[pc2 pc2];
y1=[pi1 pa1 pd1 pc1];
y2=[pi2 pa2 pd2 pc2];

% y3=[pi3 pa3 pd3 pc3];

y_all=[y1;y2]';


bar(y_all);
set(gca,'xticklabel',{'怠速',' 加速',' 减速',' 巡航'});
title('行驶状态时间描述')
xlabel('状态')
ylabel('时间比例')


legend('类别1','类别2')    
    
%% 求聚类距离最小的片段各15个

% 查找极值
[row,roll]=size(b);
n=20;
value1=D(1:row,1);
value2=D(1:row,2);
value1_1=sort(value1,'ascend');
value2_1=sort(value2,'ascend');
value1_2=value1_1(1:n);
value2_2=value2_1(1:n);
% 
% value3=D(1:row,3);
% value3_1=sort(value3,'ascend');
% value3_2=value3_1(1:n);

%找出该运动学片段的索引值
for i=1:n
    index_1(i)=find(value1==value1_2(i));
    index_2(i)=find(value2==value2_2(i));
%     
%     index_3(i)=find(value3==value3_2(i));
end

%选出片段，可以在1200秒以上
%策略为选出一个二类片段则加入一个一类片段
tt=0;
n=20;

loca=[];%用loca数组记录，一维数组记录片段索引
rate=cls_1/cls_2;%类别一与类别二的数量之比
c_1=1;%已经记入工况图的类别一的数量
c_2=1;

id_2=index_2(1);
tt2=c(id_2,4);
loca(1,1)=id_2;

id_1=index_1(1); 
tt1=c(id_1,4);
loca(2,1)=id_1;
j=3;
tt=tt1+tt2;

while tt<=1200 
    tt1=0;
    tt2=0;
    
%     if c_1== n||c_2==n
%         break
%     end
    
    if c_1/c_2>=rate
        c_2=c_2+1;
        id_2=index_2(c_2);
        tt2=c(id_2,4);
        loca(j,1)=id_2;
    else
        c_1=c_1+1;
        id_1=index_1(c_1); 
        tt1=c(id_1,4);
        loca(j,1)=id_1;
    end
    j=j+1;   
    
%     if mod(i,2)==0
%         j=j+1;
%         id_1=index_1(i); 
%         tt1=c(id_1,4);
%         loca(j,1)=id_1;
%     end
% %     j=j+1;
% %     id_1=index_1(i); 
% %     tt1=c(id_1,4);
% %     loca(j,1)=id_1;
%     j=j+1;
%     id_2=index_2(i);
%     tt2=c(id_2,4);
%     loca(j,1)=id_2;
    tt=tt+tt1+tt2;
end

[m,n]=size(loca);
loca_1=[];
for i=1:m
    id = loca(i,1);
    loca_1(i,:)=[loca(i,1),c(id,2:16)];
end

%根据平均速度（不含怠速时间）进行片段的排列
loca_1=sortrows(loca_1,12);




    
    

    


    
    




