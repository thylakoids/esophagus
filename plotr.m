%plot r
function yy=plotr(r,name,sss)
if nargin==2
    sss='o';
end
boxplot(r)
hold on 
[m,n]=size(r);
for i=1:m
    plot(1:n,r(i,:),sss)
end
set(gca,'XTickLabel',name)
end