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

%% �������ɷַ��������ȥ��������ʱ����뵡��ʱ���
a=b;
a(:,10)=[];
a(:,8)=[];

X=a;
%��kmeans�㷨ȷ����Ѿ�����Ŀ
numc=15;
silh_m=zeros(1,numc);
for i=1:numc
    kidx=kmeans(X,i);
    silh=silhouette(X,kidx);%��������ֵ
    silh_m(i)=mean(silh);
end
figure
plot(1:numc,silh_m,'o-')
xlabel('�����');
ylabel('ƽ������ֵ');
title('��ͬ����Ӧ��ƽ������ֵ');

%����2��5��ʱ��ƽ��ֵ�ֲ�ͼ
figure
for i=2:5
    kidx=kmeans(X,i);
    subplot(2,2,i-1);
    [~,h]=silhouette(X,kidx);%��������ֵ
    title([num2str(i),'��ʱ������ֵ']);
    snapnow
    xlabel('����ֵ');
    ylabel('�����');
end


%kmeans������̣����������ʾ
[idx,ctr,sumD,D]=kmeans(X,2);
figure
F1=plot(find(idx==1),a(idx==1),'r--*',...
    find(idx==2),a(idx==2),'b:o');
set(gca,'linewidth',2);
set(F1,'linewidth',2,'MarkerSize',8);
xlabel('���');
ylabel('�÷�');
title('������');
%��ξ���ľ������
Y=pdist(X);%������������ŷʽ����
Z=linkage(Y,'average');
cn=size(X);
clabel=1:cn;
clabel=clabel';

% %kmeans������̣����������ʾ
% [idx,ctr]=kmeans(X,4);
% figure
% F1=plot(find(idx==1),a(idx==1),'r--*',...
%     find(idx==2),a(idx==2),'b:o',...
%     find(idx==3),a(idx==3),'k:o',...
%     find(idx==4),a(idx==4),'g:d');
% set(gca,'linewidth',2);
% set(F1,'linewidth',2,'MarkerSize',8);
% xlabel('���');
% ylabel('�÷�');
% title('������');
% %��ξ���ľ������
% Y=pdist(X);%������������ŷʽ����
% Z=linkage(Y,'average');
% cn=size(X);
% clabel=1:cn;
% clabel=clabel';


figure
F2=dendrogram(Z);
title('��ξ��෨������');
set(F2,'linewidth',2);
ylabel('��׼����');


%% ���о�����ʱ��ȷ���
[m,n]=size(idx);
cls_1=0; %����һ��Ŀ
cls_2=0; %�������Ŀ

% cls_3=0; %��������Ŀ

for i = 1:m
    if idx(i,1)==1
        cls_1=cls_1+1;
%     elseif idx(i,1)==3
%         cls_3=cls_3+1;
    else
        cls_2=cls_2+1;
    end
end

%���и���ʻ״̬��ʱ��ͳ��
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

% ���������ʻ״̬��ʱ�����
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


%��ͼ����
%x=['����',' ����',' ����',' Ѳ��'];
% y1=[pi1 pi2];
% y2=[pa1 pa2];
% y3=[pd2 pd2];
% y4=[pc2 pc2];
y1=[pi1 pa1 pd1 pc1];
y2=[pi2 pa2 pd2 pc2];

% y3=[pi3 pa3 pd3 pc3];

y_all=[y1;y2]';


bar(y_all);
set(gca,'xticklabel',{'����',' ����',' ����',' Ѳ��'});
title('��ʻ״̬ʱ������')
xlabel('״̬')
ylabel('ʱ�����')


legend('���1','���2')    
    
%% ����������С��Ƭ�θ�15��

% ���Ҽ�ֵ
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

%�ҳ����˶�ѧƬ�ε�����ֵ
for i=1:n
    index_1(i)=find(value1==value1_2(i));
    index_2(i)=find(value2==value2_2(i));
%     
%     index_3(i)=find(value3==value3_2(i));
end

%ѡ��Ƭ�Σ�������1200������
%����Ϊѡ��һ������Ƭ�������һ��һ��Ƭ��
tt=0;
n=20;

loca=[];%��loca�����¼��һά�����¼Ƭ������
rate=cls_1/cls_2;%���һ������������֮��
c_1=1;%�Ѿ����빤��ͼ�����һ������
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

%����ƽ���ٶȣ���������ʱ�䣩����Ƭ�ε�����
loca_1=sortrows(loca_1,12);




    
    

    


    
    




