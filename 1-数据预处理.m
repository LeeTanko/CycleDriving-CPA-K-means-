clc
clear
%% 导入文件1的数据
a=importdata('附件1.xlsx');
[m,n]=size(a.data);



 %% 删除加减速度异常值，问题1-2
 err_acc=[];
 [m,n]=size(a.data);
 k=1;
 for i=1:m-1
     acc(i,1)=(a.data(i+1,1)- a.data(i,1))/3.6;
     if acc(i,1)>3.97||acc(i,1)<-8
         err_acc(k,1)=i+1;
         k=k+1;
     end
 end
 
 nn=length(err_acc);
 for i=1:nn
     for t=err_acc(i):err_acc(i+1)
         if a.data(t+1,1)==0
             err_acc(i,2)=t;
             break
         end
     end
     if i==nn
         for t=err_acc(i):m
             if a.data(t+1,1)==0
                 err_acc(i,2)=t;
                 break
             end
         end
     end
     if err_acc(i,2)==0
         err_acc(i,2)=err_acc(i+1)-1;
     end
 end
 
 i=nn;
 while i>=1
     cy=err_acc(i,2)-err_acc(i,1);
     for j = 1:cy
         a.data(err_acc(i,1),:)=[];
%          num_date1(err_acc(i,1),:)=[];
     end
     i=i-1;
 end
 
 
%  for i=1:nn
%      if i==nn
%          a.data(err_acc(i,1):err_acc(i,2),:)=[];
%          num_date1(err_acc(i,1):err_acc(i,2),:)=[];
%      else
%          a.data(err_acc(i,1):err_acc(i,2),:)=[];
%          num_date1(err_acc(i,1):err_acc(i,2),:)=[];
%      end
%  end  
 

%% 问题1-1
new_time=[];
[m,n]=size(a.data);
num_date1=datevec(a.textdata(2:m+1));%将日期转换成数值日期(向量：年 月 日 时 分 秒)
for i=2:m
new_time(i-1,:)=num_date1(i,:)-num_date1(i-1,:);
end
sum_time=sum(new_time,2);
j=1;
for i=1:m-1
 if (sum_time(i)~=1)&&(sum_time(i)~=-58)&&(sum_time(i)~=-117)&&(sum_time(i)~=-140)
     un_cons(j)=i;
     j=j+1;
 else
     un_cons(j)=0;
     j=j+1;
 end
end
index=[];%第二列为B点正常否，第二列为A点正常否，第四列为A-hat，第五列为B-below
index=(find(un_cons~=0)+1)';%找出时间不连续的索引
[p,q]=size(index);


%% 对不连续的片段进行删除
%先向下进行查找
[m,n]=size(a.data);
r=1;
t=0;

for s=1:p
    index(s,2)=1;
    ss = index(s,1);
    if a.data(ss,1)~=0
        if s == p
            ending=m;
        else
            ending = index(s+1,1);
        end
        for t=index(s,1):ending-1
             if a.data(t+1,1)==0
                 index(s,5)=t;
                 break
              end
        end
    else
         index(s,2)=0;
    end
    if index(s,5)==0 && index(s,2)==1
        %index(s,5)=index(s+1);
        if s == p
            index(s,5)=m;
        else
            index(s,5)=index(s+1,1);
        end
    end
end

%% 向上进行查找
s = p;
while s
    index(s,3)=1;%代表A点是否为异常，1为异常，0为正常
    if a.data(index(s)-1,1)==0
        index(s,3)=0;
    else
        if s==1
            ct=1;
        else
            ct=index(s-1);
        end
        r=index(s)-1;
        while r > ct
            if a.data(r,1)==0
                index(s,4)=r;
                break
            end
            r=r-1;
        end
    end
    if index(s,4)==0 && index(s,3)==1
        if s==1
            index(s,4)=1;
        else    
            index(s,4)=index(s-1);
        end
    end
    s=s-1;
end
 
%% 删除异常断点，车速，日期连续
[p,q]=size(index);
i=p;
cc=0;
while i>=1
      if (index(i,2)==1)&&(index(i,3)==1)
        if i>1
            if index(i,4)<=index(i-1,5)
                cc = index(i,5)-index(i,1);
                for j = 1:cc
                    a.data(index(i,1)+1,:)=[];
                    num_date1(index(i,1)+1,:)=[];
                end
            else
                cc = index(i,5)-index(i,4)+1;
                for j = 1:cc
                    a.data(index(i,4),:)=[];
                    num_date1(index(i,4),:)=[];
                end
             end
        else
            cc = index(i,5)-index(i,4)+1;
            for j = 1:cc
                a.data(index(i,4),:)=[];
                num_date1(index(i,4),:)=[];
            end
        end
     elseif (index(i,2)==0)&&(index(i,3)==1)
        cc = index(i,1)-index(i,4)+1;
        for j = 1:cc
            a.data(index(i,4),:)=[];
            num_date1(index(i,4),:)=[];
        end
        
     elseif (index(i,2)==1)&&(index(i,3)==0)
        cc = index(i,5)-index(i,1)+1;
        for j = 1:cc
            a.data(index(i,1),:)=[];
            num_date1(index(i,1),:)=[];
        end
     end
     i=i-1;
end


%  for i=1:p
%      if (index(i,2)==1)&&(index(i,3)==1)
%         a.data(index(i,4):index(i,5),:)=[];
%         num_date1(index(i,4):index(i,5),:)=[];
%      elseif (index(i,2)==0)&&(index(i,3)==1)
%         a.data(index(i,4):index(i,1),:)=[];
%         num_date1(index(i,4):index(i,1),:)=[];
%      elseif (index(i,2)==1)&&(index(i,3)==0)
%         a.data(index(i,1):index(i,5),:)=[];
%         num_date1(index(i,1):index(i,5),:)=[];
%      end
%  end

 %% 堵车情况处理
 [m,n]=size(a.data);
 j = 1;
 record=[];
 counter=0;
 for i=1:m
     if a.data(i,1)<2.78
         counter=counter+1;
     elseif counter >0
         record(j,1)=i-counter;
         record(j,2)=counter;
         counter=0;
         j=j+1;
     end 
 end 
 
 [p,q]=size(record);
% data1= a.data;
 for i=1:m
     a.data(i,14)=i;
 end
 value=0;
 prepare=0;
 g=0;
 for i = 1:p
     if record(i,2)> 180
         value=record(i,2);
         prepare=value-180;
         for k=1:m
             if (a.data(k,14)>=record(i,1))&&(a.data(k,14)<=(record(i,1)+value))
                 a.data(k,1)=0;
             end
         end
     end
 end
 i=p;
 while i>=1
     if record(i,2)> 180
         loc=record(i,1);
         value=record(i,2);
         prepare=value-180;
         for kk=1:prepare
            a.data(loc+90,:)=[];
         end
     end
     i = i-1;
 end

 
 %% 检验发动机熄火(经检验，没有发动机熄火的特殊状况存在）
 
 [m,n]=size(a.data);
 record_eng=[];
 j=1;
 for i = 1:m
     if a.data(i,7)==0
         record_eng(j,1)=i;
         j=j+1;
     end
 end
 
 %% 检验速度过大，超过交通规则(经检验，无超速行驶状况）
 [m,n]=size(a.data);
 record_overspeed=[];
 j=1;
 for i = 1:m
     if a.data(i,1)>=120
         record_overspeed(j,1)=i;
         j=j+1;
     end
 end
 
 
 %% 短行程的划分
 [row,roll]=size(a.data);
 j = 1;
 record_1=[]; %记录处理后的怠速分布
 counter=0;
 state_acc_index=[];
 state_acc=[];
 for i=1:row
     if a.data(i,1)==0
         counter=counter+1;
         if i ==row
             record_1(j,1)=i-counter+1;
             record_1(j,2)=counter;
         end
     elseif counter >0 
         record_1(j,1)=i-counter;
         record_1(j,2)=counter;
         counter=0;
         j=j+1;
     end 
 end  

 record_2=[];%设定短行程分段点，标记出怠速阶段的中间点
 [m,n]=size(record_1);
 for i = 1:m-1
     p=record_1(i,1);
     q=record_1(i,2);
     record_2(i,1)=i;
     record_2(i,2)=p;
 end
 
 %将record_2的第三列设置为运动片段的结束点
 for i = 1:m-1
     if i == m
        record_2(i,3)=record_1(i,1);
     else
        record_2(i,3) = record_1(i+1,1);
     end 
 end
 
 %增加一列数据，为加速度值
 for i = 1:row-1
    a.data(i,14)=(a.data(i+1,1)-a.data(i,1))/3.6;
 end
 
 %计算各类指标
 [m,n]=size(record_2);
 for i = 1:m
     num_s = record_2(i,2);
     num_e = record_2(i,3);
     ta = 0; %加速度时间
     td = 0; %减速度时间
     ti = 0; %怠速时间
     tc= 0; %匀速时间
     t = num_e - num_s;  %运行时间
     sv=0; %所有数据点的速度和
     sum_aa=0;%所有加速点的加速度之和
     sum_ad=0;%所有减速点的减速度之和
     
     vp1=0;%车速小于等于10km/h的时间点数
     vp2=0;%下同
     vp3=0;
     vp4=0;
     vp5=0;
     vp6=0;
     vp7=0;
     vp8=0;
     vp9=0;%车速大于80km/h的时间点数
     
     ap1=0; %加速度>=3.5的时间数据点
     ap2=0;%加速度>=3.0的时间数据点
     ap3=0;%加速度>=2.5的时间数据点
     ap4=0;%加速度>=2.0的时间数据点
     ap5=0;%加速度>=1.5的时间数据点
     ap6=0;%加速度>=1.0的时间数据点
     ap7=0;%加速度>=0.5的时间数据点
     ap8=0;%加速度>=0的时间数据点
     ap9=0;%加速度>=-1的时间数据点
     ap10=0;%加速度>=-2的时间数据点
     ap11=0;%加速度>=-3的时间数据点
     ap12=0;%加速度>=-4的时间数据点
     ap13=0;%加速度>=-5的时间数据点
     ap14=0;%加速度>=-6的时间数据点
     ap15=0;%加速度>=-7的时间数据点
     ap16=0;%加速度<-7的时间数据点
     
     
     for j = 0:t-1
         if a.data(num_s+j,14)>0 %加速不小于0.1
             ta=ta+1;
             sum_aa=sum_aa+a.data(num_s+j,14);
         elseif a.data(num_s+j,14)<0 %加速不小于0.1
             td=td+1;
             sum_ad=sum_ad+a.data(num_s+j,14);
         elseif a.data(num_s+j,14)==0 && a.data(num_s+j,1)==0 %加速不小于0.1
             ti=ti+1;
         end
         
         sv=sv+a.data(num_s+j,1);
         
         if a.data(num_s+j,1) <= 10
             vp1=vp1+1;
         elseif a.data(num_s+j,1) <= 20
             vp2=vp2+1;
         elseif a.data(num_s+j,1) <= 30
             vp3=vp3+1;
         elseif a.data(num_s+j,1) <= 40
             vp4=vp4+1;
         elseif a.data(num_s+j,1) <= 50
             vp5=vp5+1;
         elseif a.data(num_s+j,1) <= 60
             vp6=vp6+1;
         elseif a.data(num_s+j,1) <= 70
             vp7=vp7+1;
         elseif a.data(num_s+j,1) <= 80
             vp8=vp8+1;
         else
             vp9=vp9+1;
         end   
         
         if a.data(num_s+j,14)>=3.5
             ap1 = ap1 +1;
         elseif a.data(num_s+j,14)>=3.0
             ap2 = ap2 +1;
         elseif  a.data(num_s+j,14)>=2.5
             ap3 = ap3 +1;
         elseif a.data(num_s+j,14)>=2.0
             ap4 = ap4 +1;
         elseif a.data(num_s+j,14)>=1.5
             ap5 = ap5 +1;
         elseif a.data(num_s+j,14)>=1.0
             ap6 = ap6 +1;
         elseif a.data(num_s+j,14)>=0.5
             ap7 = ap7 +1;
         elseif a.data(num_s+j,14)>=0
             ap8 = ap8 +1;
         elseif a.data(num_s+j,14)>=-1
             ap9 = ap9 +1;
         elseif a.data(num_s+j,14)>=-2
             ap10 = ap10 +1;
         elseif a.data(num_s+j,14)>=-3
             ap11= ap11 +1;
         elseif a.data(num_s+j,14)>=-4
             ap12 = ap12 +1;
         elseif a.data(num_s+j,14)>=-5
             ap13 = ap13 +1;
         elseif a.data(num_s+j,14)>=-6
             ap14 = ap14 +1;
         elseif a.data(num_s+j,14)>=-7
             ap15 = ap15 +1;
         else
             ap16 = ap16 +1;
         end
             
         
     end
     
     tc = t-ta-td-ti;%巡航时间
     vmax=max(a.data(num_s:num_e,1)); %求最大速度
     vsd=std(a.data(num_s:num_e,1));%计算速度的标准差
     amax=max(a.data(num_s:num_e,14));%最大加速度
     amin=min(a.data(num_s:num_e,14));%最小减速度
     aa=sum_aa/ta;%加速段平均加速度
     ad=sum_ad/td;%减速段平均减速度
     
     fake=a.data(num_s:num_e,14);
     state_acc_index=find(fake>0);
     
     state_acc=a.data(num_s+state_acc_index-1,14);

     asd=std(state_acc);%计算加速度的标准差
     
     record_2(i,4)=t;
     record_2(i,5)=ta;%加速度时间
     record_2(i,6)=td;
     record_2(i,7)=ti;
     record_2(i,8)=tc; %巡航时间
     record_2(i,9)=sv;
     record_2(i,10)=vmax;
     record_2(i,11)=sv/t; %平均速度
     record_2(i,12)=sv/(t-ti); %除去怠速时间的平均速度 
     record_2(i,13)=vsd;%速度标准差
     record_2(i,14)=aa;%平均加速度
     record_2(i,15)=ad;%平均减速度
     record_2(i,16)=asd;%加速度标准差
     record_2(i,17)=vp1/t;
     record_2(i,18)=vp2/t;
     record_2(i,19)=vp3/t;
     record_2(i,20)=vp4/t;
     record_2(i,21)=vp5/t;
     record_2(i,22)=vp6/t;
     record_2(i,23)=vp7/t;
     record_2(i,24)=vp8/t;
     record_2(i,25)=vp9/t;
     record_2(i,26)=ap1/t;
     record_2(i,27)=ap2/t;
     record_2(i,28)=ap3/t;
     record_2(i,29)=ap4/t;
     record_2(i,30)=ap5/t;
     record_2(i,31)=ap6/t;
     record_2(i,32)=ap7/t;
     record_2(i,33)=ap8/t;
     record_2(i,34)=ap9/t;
     record_2(i,35)=ap10/t;
     record_2(i,36)=ap11/t;
     record_2(i,37)=ap12/t;
     record_2(i,38)=ap13/t;
     record_2(i,39)=ap14/t;
     record_2(i,40)=ap15/t;
     record_2(i,41)=ap16/t;
         
 end 
 
record_3=[];
[m,n]=size(record_2);

for i=1:m
    record_3(i,1)=record_2(i,12);
    record_3(i,2)=record_2(i,11);
    record_3(i,3)=record_2(i,14);
    record_3(i,4)=record_2(i,15);
    record_3(i,5)=record_2(i,7)/record_2(i,4);
    record_3(i,6)=record_2(i,8)/record_2(i,4);
    record_3(i,7)=record_2(i,5)/record_2(i,4);
    record_3(i,8)=record_2(i,6)/record_2(i,4);
    record_3(i,9)=record_2(i,13);
    record_3(i,10)=record_2(i,16);
end

     
 %画图举例
 x = (1:800);
 y = a.data(1:800,1);
 plot(x,y);
 xlabel('时间 （s）');
 ylabel('速度 （km/h）');
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 