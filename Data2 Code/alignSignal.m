function [mask1,mask2,map]=alignSignal(sig1,sig2,durLimit,direction)

mask1=zeros(size(sig1));
mask2=zeros(size(sig2));
map=-ones(size(sig1));

%% below is for test20170710
% loc=1;
% if strcmp(direction,'left')==1
%     for ii = 1:length(sig1)
%         if ii == 1
%             LocsBefore = find(sig2<sig1(ii),2,'last');
%         else
%             if isnan(sig1(ii-1))
%                 LocsBefore = find(sig2<sig1(ii),2,'last');
%             else
%                 LocsBefore = find(sig2<sig1(ii) & sig2>sig1(ii-1),2,'last');
%             end
%         end
%         if isempty(LocsBefore)
%             mask1(ii)=1;
%             loc = loc+1;
%             %         fprintf('yyy\n')
%         else
%             if sig1(ii)-sig2(LocsBefore(1))>=durLimit(1) || sig1(ii)-sig2(LocsBefore(1))<=durLimit(2)
%                 if length(LocsBefore)==1 || sig1(ii)-sig2(LocsBefore(2))>=durLimit(1) || sig1(ii)-sig2(LocsBefore(2))<=durLimit(2)
%                     mask1(ii)=1;
%                     loc = loc+1;
%                 else
%                     mask2(LocsBefore(2))=1;
%                     map(ii)=loc;
%                     loc = loc+1;
%                 end
%                 %             fprintf([num2str(sig1(ii)-sig2(LocBefore)) '+xxx\n'])
%             else
%                 mask2(LocsBefore(1))=1;
%                 map(ii)=loc;
%                 loc = loc+1;
%             end
%             
%         end
%         
%     end
% elseif strcmp(direction,'right')==1
%     for ii = 1:length(sig1)
%         if ii == length(sig1)
%             LocsAfter = find(sig2>sig1(end),2,'first');
%         else
%             if isnan(sig1(ii+1))
%                 LocsAfter = find(sig2>sig1(ii),2,'first');
%             else
%                 LocsAfter = find(sig2>sig1(ii) & sig2<sig1(ii+1),2,'first');
%             end
%         end
%         if isempty(LocsAfter)
%             mask1(ii)=1;
%             loc = loc+1;
% %             fprintf(['sig No.' num2str(ii) ': sig1 peak dropped because there is no more sig2. loc=' num2str(loc-1) '\n'])
%         else
%             if sig2(LocsAfter(1))-sig1(ii)>=durLimit(2) || sig2(LocsAfter(1))-sig1(ii)<=durLimit(1)
%                 if length(LocsAfter)==1 || sig2(LocsAfter(2))-sig1(ii)>=durLimit(2) || sig2(LocsAfter(2))-sig1(ii)<=durLimit(1)
%                     mask1(ii)=1;
%                     loc = loc+1;
% %                     fprintf(['sig No.' num2str(ii) ': sig1 peak dropped because first two peaks of sig2 after it is out of bound. loc=' num2str(loc-1) '\n'])
%                 else
%                     mask2(LocsAfter(2))=1;
%                     map(ii)=loc;
%                     loc = loc+1;
% %                     fprintf(['sig No.' num2str(ii) ': sig2 peak at ' num2str(sig2(LocsAfter(2))) '(2) is selected. loc=' num2str(loc-1) '\n'])
%                 end
%                 %             fprintf([num2str(sig1(ii)-sig2(LocBefore)) '+xxx\n'])
%             else
%                 mask2(LocsAfter(1))=1;
%                 map(ii)=loc;
%                 loc = loc+1;
% %                 fprintf(['sig No.' num2str(ii) ': sig2 peak at ' num2str(sig2(LocsAfter(1))) '(1) is selected. loc=' num2str(loc-1) '\n'])
%             end
%         end
%         
%     end
% end

%% below is for test20170818
if size(durLimit,1)>1
    isdurLimitMatrix = 1;
else
    isdurLimitMatrix = 0;
end
for ii = 1:length(sig1)
    if isdurLimitMatrix
        currentLimit = durLimit(ii,:);
    else
        currentLimit = durLimit(1,:);
    end
    if any(isnan(currentLimit))
        mask1(ii)=1;
        continue
    else
        locs = find(sig2>sig1(ii)+currentLimit(1) & sig2<sig1(ii)+currentLimit(2),2);
    end
    if isempty(locs)
        mask1(ii)=1;
        continue
    elseif length(locs)==1
        loc = locs;
    else
        if abs(sig1(ii)-sig2(locs(1))) >= abs(sig1(ii)-sig2(locs(2)))
            loc = locs(2);
        else
            loc = locs(1);
        end
        
    end
    if mask2(loc) == 1
        mask1(ii)=1;
        continue
    else
        mask2(loc)=1;
        map(ii)=ii;
    end
%     fprintf(['mask2 length=' num2str(sum(double(mask2~=0))) ', map length=' num2str(sum(double(map~=-1))) '\n'])
end
map(map==-1)=[];