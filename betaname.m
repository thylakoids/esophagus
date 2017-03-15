function result=betaname(n)
result_number=[];
lin=1:n;
int=[];
for i=1:(n-1)
    for j=(i+1):n
        int=[int,10*i+j];
    end
end
qua=[];
for i=1:n
    qua=[qua, 10*i+i];
end
result_number=[lin,int,qua];
result_=[];
for i=1:size(result_number,2)
    result_=[result_ {['\beta_{' num2str(result_number(i)) '}']}];
end
result=result_;