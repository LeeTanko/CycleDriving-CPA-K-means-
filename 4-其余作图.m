clc
clear

%% 开始构造工况曲线

a=importdata('1-a.mat'); %前述的a.data
b=importdata('2-a.mat');
c=importdata('3-a.mat');
d=importdata('all_datav1.mat');

loca_1=importdata('1.mat');

%% 构建工况图
%创建一个数组来按顺序存储速度
speed=[];
[m,n]=size(loca_1);
j=1;
for i=1:m
    if loca_1(i,1)<=1330
        id=loca_1(i,1);
        start=loca_1(i,2);
        step=loca_1(i,4);
        speed(j:j+step)=a.data(start:start+step,1);
        j=j+step;
    elseif loca_1(i,1)<=2668
        id=loca_1(i,1);
        start=loca_1(i,2);
        step=loca_1(i,4);
        speed(j:j+step)=b.data(start:start+step,1);
        j=j+step;
    else
        id=loca_1(i,1);
        start=loca_1(i,2);
        step=loca_1(i,4);
        speed(j:j+step)=c.data(start:start+step,1);
        j=j+step;
    end
end

[m,n]=size(speed);
 x = (1:n);
 y = speed(1,:);
 plot(x,y);
 xlabel('时间 （s）');
 ylabel('速度 （km/h）');
 
 
 %% 构建加速度-时间图
 
acc=[];
[m,n]=size(loca_1);
j=1;
for i=1:m
    if loca_1(i,1)<=1330
        start=loca_1(i,2);
        step=loca_1(i,4)-1;
        acc(j:j+step)=a.data(start:start+step,14);
        j=j+step;
    elseif loca_1(i,1)<=2668
        start=loca_1(i,2);
        step=loca_1(i,4)-1;
        acc(j:j+step)=b.data(start:start+step,14);
        j=j+step;
    else
        start=loca_1(i,2);
        step=loca_1(i,4)-1;
        acc(j:j+step)=c.data(start:start+step,14);
        j=j+step;
    end
end

[m,n]=size(acc);
 x = (1:n);
 y = acc(1,:);
 plot(x,y);
 xlabel('时间');
 ylabel('加速度');
 
 %% 误差分析
 %创建数据数组，存储实验数据和工况各特征的均值
 alldata_ave=mean(d);
 result_ave=mean(loca_1);
 data_cmp=[];
 
 data_cmp(1,1)=alldata_ave(1,12);
 data_cmp(1,2)=alldata_ave(1,11);
 data_cmp(1,3)=alldata_ave(1,14);
 data_cmp(1,4)=alldata_ave(1,15);
 data_cmp(1,5)=alldata_ave(1,7)/alldata_ave(1,4);
 data_cmp(1,6)=alldata_ave(1,8)/alldata_ave(1,4);
 data_cmp(1,7)=alldata_ave(1,5)/alldata_ave(1,4);
 data_cmp(1,8)=alldata_ave(1,13);
 
 data_cmp(2,1)=result_ave(1,12);
 data_cmp(2,2)=result_ave(1,11);
 data_cmp(2,3)=result_ave(1,14);
 data_cmp(2,4)=result_ave(1,15);
 data_cmp(2,5)=result_ave(1,7)/result_ave(1,4);
 data_cmp(2,6)=result_ave(1,8)/result_ave(1,4);
 data_cmp(2,7)=result_ave(1,5)/result_ave(1,4);
 data_cmp(2,8)=result_ave(1,13);
 
 n=8;
 for i =1:8
     data_cmp(3,i)=(data_cmp(2,i)-data_cmp(1,i))/data_cmp(1,i);
 end
 
%  x=data_cmp(1,:);
%  y=data_cmp(2,:);
%  z=data_cmp(3,:);
%  [X,Y]=meshgrid(x,y);
%  Z=griddata(data_cmp(1,:),data_cmp(2,:),data_cmp(3,:),X,Y,'v4');
%  surf(X,Y,Z);
%  
 
 
 
 
