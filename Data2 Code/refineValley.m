function [BCGMinLocRefined,BCGMinRefined,BCGMinLocChanged,BCGMinChanged]=refineValley(BCG,BCGMaxLoc,BCGMax,BCGMinLoc,BCGMin,fs,minGap,maxPercent)

BCGMinLocRefined = BCGMinLoc;
BCGMinRefined = BCGMin;
BCGMinLocChanged = NaN(size(BCGMinLoc));
BCGMinChanged = NaN(size(BCGMin));
for ii = 1:length(BCGMaxLoc)
    if ~isnan(BCGMaxLoc(ii)) && ~isnan(BCGMinLoc(ii))
        tempStartIdx = round(BCGMinLoc(ii)*fs);
        tempEndIdx = min(tempStartIdx+80,round(BCGMaxLoc(ii)*fs-20));
        slopeList=NaN(1,tempEndIdx-tempStartIdx);
        for jj = 1:(tempEndIdx-tempStartIdx)
            BCGtemp = BCG(tempStartIdx:tempStartIdx+jj);
            avgHeight = sum(BCGtemp-BCGtemp(1))*2/(length(BCGtemp));
%             avgSlope = avgHeight*2/(len-1);
            slopeList(jj) = avgHeight;
        end
        loc = find(slopeList<=maxPercent/100*(BCGMax(ii)-BCGMin(ii)),1,'last');
%         fprintf(['ii=' num2str(ii) ''])
        if ~isempty(loc)
            if loc > minGap
                BCGMinLocRefined(ii) = BCGMinLocRefined(ii)+(round(loc/2)-1)/fs;
                BCGMinRefined(ii) = BCG(tempStartIdx+round(loc/2)-1);
                BCGMinLocChanged(ii) = BCGMinLocRefined(ii);
                BCGMinChanged(ii) = BCGMinRefined(ii);
            end
        end
    end
end
            
            
            
        
        

