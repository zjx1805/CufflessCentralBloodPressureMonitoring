clear all;close all;clc
% used for testing of some functionalities

figure(1)
subplot(2,2,1)
tx = text(NaN(4,1),NaN(4,1),'','fontsize',9)
newPos = {[0.5,0.5],[0.7,0.7],[NaN,NaN],[0.1,0.1]};
subplot(2,2,1)
[tx.Position] = newPos{:};
newstring = {'a','b','','c'};
[tx.String] = newstring{:};
% tx(1,1).Position = [1,1];
% tx(2,1).Position = [0.5,0.5];
% tx(1).String = 'a';
% tx(2).String = 'b';

subplot(2,2,2)
plot(0:0.01:1,0:0.01:1,'b')
tx2 = text([0.5;0.7],[0.5;0.7],{'aa','bb'})


% delete(tx)
% tx = text([0.5;0.7],[0.5;0.7],{'cc','dd'})
% plot([1,2],[1,2],'bo')
% tx2 = text([1,2],[1,2],{'a','b'},'fontsize',9)