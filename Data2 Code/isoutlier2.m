function [out]=isoutlier2(x)

MAD=-1/(sqrt(2)*erfcinv(3/2))*median(abs(x-median(x)));
out=find(x-median(x)>10*MAD | x-median(x)<-10*MAD);