%% ���ɷַ�������
%% ���ܣ�ʵ�ֶԹ����ʣ��ۼƹ����ʣ����ɷ��غ����ӵļ���
%% ��ͨʱ�䣺2019.9.15
clc
clear
%% ���ݼ���
a=importdata('all_microtrip.mat');
[s,t]=size(a);
%% ���ݱ�׼������
b=zscore(a);%�����ݽ��б�׼������
%% ��׼��������Э�������ֵ����������
M=corrcoef(b);%Э����
[V,D]=eig(M);%���Э������������������������
d=diag(D);%ȡ����������������������ȡ��ÿһ���ɷֵĹ����ʣ� 
%% �����ʺ��ۼƹ�����
eig1=sort(d,'descend')%�������ʰ��Ӵ�СԪ������
v=fliplr(V);%����D����������������
%% ���չ���ѡȡ���ʵ����ɷָ���
S=0;
i=0;
while S/sum(eig1)<0.85
 i=i+1;
S=S+eig1(i);
end%����ۻ������ʴ���85%�����ɷ�
disp('������')
W=100*eig1/sum(eig1)
disp('�ۼƹ�����');
W1=cumsum(W)
disp('�������ɷֵ�ռ��')
rate_eig1=100*eig1./sum(eig1)
%% ��ѡȡ��ÿһ�����ɷֵ��غ�
disp('���ɷֵ��غ�')
for m=1:i
    zai_he(:,:,m)=sqrt(eig1(m,:)).*v(:,m);%����ÿһ�����ɷֵ��غ�
end
zai_he
for m=1:i
    for n=1:s
    score(n,m)=sum(zai_he(:,:,m).*b(n,:)');
    end
end
%% ��ͼ
figure(1)
pareto(W);%���������ʵ�ֱ��ͼ
title('�����ʵ�ֱ��ͼ');
figure(2)
plot(eig1,'ko');
hold on
plot(eig1,'b-');%��ʯͼ
xlabel('���ɷָ���')
ylabel('���ɷֶ�Ӧ�Ĺ���ֵ')
figure(3)
pie3(rate_eig1,[1 1 1 1 1 1 1 1 1 1 ])%��ͼ



