%depend plotyyhat
function [fit,r,name]=myfitlm(x,y,fun,xs,ys)
if nargin<=2
    fun='linear'; 
elseif strcmp(fun,'interaction')
    fun='interactions';
end
fit=fitlm(x,y,fun);
name=['fitlm ' fun];
if nargin>=5
    r=plotyyhat(ys,fit.predict(xs),name);
end
end
