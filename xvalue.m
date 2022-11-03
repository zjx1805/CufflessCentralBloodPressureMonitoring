function xvalue(source,event,x,y,z,v)
xx=source.Value;

figure(2)
% [x,y,z] = meshgrid(-2:.2:2,-2:.25:2,-2:.16:2);
% v = x.*exp(-x.^2-y.^2-z.^2);
% xslice = [-1.2,.8,2]; 
% yslice = 2; 
% zslice = [-2,0];
% % slice(x,y,z,v,xslice,yslice,zslice)
subplot(4,5,[1,2,3,6,7,8,11,12,13])
slice(x,y,z,v,xx,[],[])
colormap jet
colorbar
xlim([0,1])

subplot(4,5,[4,5,9,10])
contour(x(:,:,1),y(:,:,1),std(v,0,3),[0:0.02:1],'ShowText','on')

subplot(4,5,[14,15,19,20])
contour(x(:,:,1),y(:,:,1),mean(v,3),[0:0.1:1.1],'ShowText','on')

end