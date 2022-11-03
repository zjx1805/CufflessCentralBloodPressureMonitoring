function [mask1,mask2,map]=alignSignal(sig1,sig2,durLimit)

mask1=zeros(size(sig1));
mask2=zeros(size(sig2));
map=-ones(size(sig1));


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