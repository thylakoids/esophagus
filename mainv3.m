%%%% compare different model
%fitlm
%alasso
%depend: alasso,myfitlm
%
clear
clc
close all
warning off
dataNumber=1;   %choose dataset:generation1 or generation2
rawdata=xlsread('1and2.xlsx',dataNumber);
x=rawdata(:,1:(end-1));
y=rawdata(:,end);
%%%%% define the loop parameter
totalsubf=5; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxi=50;
r=zeros(maxi,totalsubf);
for i=1:maxi
%%%%%%rand set
testpos=randperm(size(y,1),10);
trainpos=setdiff(1:size(y,1),testpos);
train.x=x(trainpos,:);train.y=y(trainpos,:);
test.x=x(testpos,:);test.y=y(testpos,:);
%%%%%
%define some figure parameter
figure('name',num2str(i),'Visible','on')
set(gcf,'Position',[[34.6000000000000,101,1163.20000000000,676]])%%%positon
subf=1;
name={};
%%%%%%alasso linear
subplot(1,totalsubf,subf);subf=subf+1;
[a,beta,r(i,subf-1),name{subf-1}]=alasso(train.x,train.y,'linear',test.x,test.y);
%%%%%%alasso interaction
subplot(1,totalsubf,subf);subf=subf+1;
[a,beta,r(i,subf-1),name{subf-1}]=alasso(train.x,train.y,'interaction',test.x,test.y);
%%%%%% fitlm interaction
subplot(1,totalsubf,subf);subf=subf+1;
[fit,r(i,subf-1),name{subf-1}]=myfitlm(train.x,train.y,'interaction',test.x,test.y);
%%%%%% fitlm linear
subplot(1,totalsubf,subf);subf=subf+1;
[fit,r(i,subf-1),name{subf-1}]=myfitlm(train.x,train.y,'linear',test.x,test.y);
% %%%%% gaussian process
% subplot(1,totalsubf,subf);subf=subf+1;
% [r(i,subf-1),name{subf-1}]=gaussianp(train.x,train.y,'linear',test.x,test.y);
%%%%% nnet
subplot(1,totalsubf,subf);subf=subf+1;
[net,r(i,subf-1),name{subf-1}]=mynnet(train.x,train.y,'linear',test.x,test.y,2);
fprintf('[*]Process: %1.1f\n',i/maxi)
end
figure('name','R')
plotr(r,name)
