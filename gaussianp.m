function [r,name]=gaussianp(x,y,fun,xs,ys)
if nargin<=2
    fun='linear'; 
end
x=x2fx(x,fun);
x=x(:,2:end);
if nargin>=5
    xs=x2fx(xs,fun);
    xs=xs(:,2:end);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meanfunc=@meanConst; hyp.mean=[1];
covfunc=@covSEiso ;ell = 1/4; sf = 1; hyp.cov = log([ell; sf]);
covfunc=@covSEard ;ell = rand(size(x,2),1); sf = 1; hyp.cov = log([ell; sf]);
likfunc = @likGauss; sn = 0.1; hyp.lik = log(sn);
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);
[mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y,xs);

%%%%%
name=['gaussianp ' fun];
if nargin>=5
    xs=x2fx(xs,fun);
    xs=xs(:,2:end);
    r=plotyyhat(ys,mu,name);
end
end