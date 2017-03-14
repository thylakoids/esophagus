function yy=plotyyhat(y,y_hat,name)
if nargin<=2
    name='';
end
plot(y,y_hat,'.k','MarkerSize',10)
hold on
A=polyfit(y,y_hat,1);
R=corrcoef(y,y_hat);
z=polyval(A,y);
yy=R(1,2);
tmp=min(y):0.1:max(y);
p2=plot(tmp,tmp,'g',y,z,'r','LineWidth',1.5);%线性拟合曲线
set(gca,'Fontsize',10,'FontName','Arial')
box off
text(0.1,0.9,['R=' num2str(yy)],'units','normalized');
title(name);
%gtext([name ' R=' num2str(yy)]);