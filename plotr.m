%plot r
function yy=plotr(r,name)
boxplot(r)
hold on 
[m,n]=size(r);
for i=1:m
    scatter(1:n,r(i,:))
end
set(gca,'XTickLabel',name)
end