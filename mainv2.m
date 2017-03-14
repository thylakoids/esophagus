%%%%%%%%%%%%%%%%%%%%%%%
%????????????ACS????????
%1. contour plot ?????????????drug?contour plot?????????indicate optimal solution???????????????????????????
%2. beta coefficient ????????????
%%%%%%%%%%%%%%%%%%%%%%%
%font size:
%1  :6 8
%2  :8 10
%%%%%%%%%%%%%%%% part1 generate model %%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all
%%choose model
model=@quadraticModel;
%%load full data and normnalization
dataNumber=2;
flag_normal=1;
normalRange=[-1 1];
rawdata=xlsread('1and2.xlsx',dataNumber);
colums=size(rawdata,2);
drugNumber=colums-1;
fmaxbeta=1+colums-1+nchoosek(colums-1,2)+colums-1;
% beta0=zeros(fmaxbeta,1);
input_=rawdata(:,1:colums-1);
if flag_normal
    [input_normal,setting]=mapminmax(input_',normalRange(1),normalRange(2));
    input_normal=input_normal';
else
    input_normal=input_;
end
target_=rawdata(:,colums);

fit1=fitlm(input_normal,target_,'quadratic');
beta1=fit1.Coefficients.Estimate;
prediction=fit1.predict(input_normal);
experiment=target_;
pre=mse(prediction-experiment)
A=polyfit(experiment,prediction,1);
R=corrcoef(experiment,prediction);
z=polyval(A,experiment);
R=R(1,2)
%%%%%%%%%%%draw%%%%%%%%%%%%%
figure(1)
scatter(experiment,prediction,1000,'black.')
title('Linear regression model','fontsize',18)
ylabel('Predicted value','fontsize',18)
xlabel('Experimental result','fontsize',18)
hold on
x=min(experiment):0.01:max(experiment);
y=x;%y=x
plot(x,y,'g',experiment,z,'r')%线性拟合曲线
h1=legend('data point','y=x','fitted curve','location','NW');
R=roundn(R,-2);
set(h1,'box','off')
set(gca,'box','off')
text([(0.05*(max(experiment)-min(experiment))+min(experiment)); (0.1*(max(experiment)-min(experiment))+min(experiment))],[(0.9*(max(prediction)-min(prediction))+min(prediction)); (0.9*(max(prediction)-min(prediction))+min(prediction)) ],{'R=';R})
%%%%%%%%%%%%%%%%%% min %%%%%%%%%%%%%%%%%%%%%
% Find the global optimal
AA=eye(drugNumber);
AA=[AA;-AA];
minx=min(input_normal);
maxx=max(input_normal);
bb1=maxx';
bb2=minx';
BB=[bb1;-bb2];
y=100;
for i=1:10
x0=rand(1,drugNumber);
[x,fval]=fmincon(@(t) fit1.predict(t),x0,AA,BB);
if fval<y
    X=x;
    y=fval;
end
end
optimal_x=X;
optimal_y=y;
%%%%%%%%%%%%%%%%%%%%%contour%%%%%%%%%%%%%
figure(2)
set(gcf,'Position',[1 1 1000 1000])
count=1;
for d1=1:drugNumber-1
    for d2=(d1+1):drugNumber
n=10;
x1=linspace(minx(d1),maxx(d1),n);
x2=linspace(minx(d2),maxx(d2),n);
[xx,yy]=meshgrid(x1,x2);
i=1;
zz=zeros(n);
while i<=n*n
    tmp1=xx(i);
    tmp2=yy(i);
    X=zeros(1,drugNumber);
    drug1=min(input_normal);
    drug2=min(input_normal);
    drug1(d1)=tmp1;
    drug2(d2)=tmp2;
    zz(i)=fit1.predict(drug1+drug2);
    i=i+1;
end
switch drugNumber
    case 7
        drug={'5FU','Vb','Ci','Pa','Dt','Nd','Mi'};
    case 4
        drug={'5FU','Vb','Ci','Nd'};
    otherwise
        drug=input('Type the drug name:   (eg:  {''a'',''b''})');
end
%%%%%%%%%%% x,y ticklabel%%%%%%%%%%
tem_normal=[minx ;(minx+maxx)/2; maxx]';
if flag_normal
    tem=mapminmax.reverse(tem_normal,setting);
else
    tem=tem_normal;
end
tem_s={};
for i=1:drugNumber
    for j=1:3
        tem_s{i,j}=num2str( tem(i,j));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%predict%%%%%%%%%%%%%%%%%
subplot(drugNumber-1,drugNumber-1,d1*drugNumber-drugNumber+d2-d1)
count=count+1;
% original_xx=mapminmax(xx,setting.xmin(d1),setting.xmax(d1));
% original_yy=(mapminmax(yy',setting.xmin(d2),setting.xmax(d2)));
% original_yy=original_yy';
surf(xx,yy,zz)
label=xlabel(drug(d1),'rotation',0);
label=ylabel(drug(d2),'rotation',0);
set(gca,'xtick',tem_normal(d1,:),'xticklabel',tem_s(d1,:),'xlim',[min(tem_normal(d1,:)),max(tem_normal(d1,:))]);
set(gca,'ytick',tem_normal(d2,:),'yticklabel',tem_s(d2,:),'ylim',[min(tem_normal(d2,:)),max(tem_normal(d2,:))]);
set(gca,'fontsize',8)
label=zlabel('ACS');
%label.Position=label.Position+[-0.1 0.1 0];
colormap(jet(100))
% caxis
% caxis([100,275])
% view(90,90)
%%%%%%%%%%%%%%%%%optimal%%%%%%%%%%%%%%%%%%%%%
hold on 
drug1=min(input_normal);
drug2=min(input_normal);
drug1(d1)=optimal_x(d1);
drug2(d2)=optimal_x(d2);
H=scatter3(optimal_x(d1),optimal_x(d2),fit1.predict(drug1+drug2),'oy','filled');
H.MarkerFaceColor='flat';
H.MarkerEdgeColor='k';
    end
end
%print('-dtiff','-r600',['contour_' num2str(dataNumber) '.tif'])
figure(3)
set(gcf,'Position',[1 1 1000 1000])
H=bar(beta1(2:end),'g');
set(gca,'fontsize',10);
set(gca,'xtick',1:(fmaxbeta-1),'xticklabel',betaname(drugNumber));
%print('-dtiff','-r600',['beta_' num2str(dataNumber) '.tif'])
if flag_normal
    (mapminmax.reverse(optimal_x',setting))'
else
    optimal_x
end