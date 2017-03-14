%%%%% [a0,beta]=alasso(x,y)
% depend: plotyyhat
function [a0,beta,r,name]=alasso(x,y,fun,xs,ys)
if nargin<=2
    fun='linear'; 
end
x=x2fx(x,fun);
x=x(:,2:end);
%%%%%Ridge Regression to create the adaptive weights vector
options.alpha=0.0;
% options.lambda_min=0;
% options.nlambda=100;
CVerr=cvglmnet(x,y,'gaussian',options,'nfolds',size(y,1));
beta_min=CVerr.glmnet_fit.beta(:,find(CVerr.lambda==CVerr.lambda_min));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%adaptive lasso
options.alpha=1.0;
% options.lambda_min=0;
% options.nlambda=100;
options.penalty_factor=1./abs(beta_min);
CVerr1=cvglmnet(x,y,'gaussian',options,'nfolds',size(y,1));
beta=CVerr1.glmnet_fit.beta(:,find(CVerr1.lambda==CVerr1.lambda_min));
a0=CVerr1.glmnet_fit.a0(find(CVerr1.lambda==CVerr1.lambda_min)); 
name=['alasso ' fun];
if nargin>=5
    xs=x2fx(xs,fun);
    xs=xs(:,2:end);
    r=plotyyhat(ys,a0+xs*beta,name);
end
end