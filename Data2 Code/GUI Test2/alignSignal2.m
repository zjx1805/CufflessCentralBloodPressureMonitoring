function [sig1LocAfter,sig2LocAfter,sig1ValAfter,sig2ValAfter]=alignSignal2(sig1Loc,sig2Loc,sig1Val,sig2Val,rangeLimit,isBothBP,eventTag,mPlots,feature1Name,feature2Name)

%%% sig1 is the reference signal (i.e., the function tries to pair each
%%% feature in sig1 to one of the candidate features. NaN is used if no
%%% appropriate candidate feature is found in sig2) except in the case that
%%% both signals are BP (i.e., trying to pair BP Max to BP Min) where a BP
%%% Max candidate has to be paired to a BP Min candidate. Otherwise, both
%%% of them will be dropped. In the end, all features will have the same
%%% length as BPMax and BPMin. However, there is no NaN in BPMax/BPMin and
%%% there can be NaNs in the remaining features (due to failure of pairing)

entryCode = getappdata(mPlots.Analysis.(eventTag).Parent,'entryCode');
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;
if getappdata(mPlots.Analysis.(eventTag).Parent,'initialRun') == 1 || (contains(feature2Name,'BCG') == 1 && entryCode <= 2)
    beatsBefore = 0; beatsBetween = Inf; beatsAfter = 0;
else
    beatsBefore = find(sig1Loc>currentWindowStartIdxAbs,1)-1; if isempty(beatsBefore); beatsBefore = 0; end
    beatsBetween = length(find(sig1Loc>currentWindowStartIdxAbs & sig1Loc<currentWindowEndIdxAbs));
    beatsAfter = length(sig1Loc)-beatsBefore-beatsBetween;
    beatsBeforeOld = beatsBefore; beatsBetweenOld = beatsBetween; beatsAfterOld = beatsAfter;
    if (beatsBeforeOld >= 1 && isnan(sig1Loc(beatsBeforeOld))) || isnan(sig1Loc(min(beatsBeforeOld+beatsBetweenOld+1,length(sig1Loc))))
        BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
        beatsBefore = find(BPMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsBetween = length(find(BPMinLoc>currentWindowStartIdxAbs & BPMinLoc<currentWindowEndIdxAbs));
        beatsAfter = length(BPMinLoc)-beatsBefore-beatsBetween;
    end
end
% fprintf(['Length of sig2=' num2str(sig2Loc) ',beatsBefore=' num2str(beatsBefore) ', beatsBetween=' num2str(beatsBetween) ', beatsAfter=' num2str(beatsAfter) '\n'])
% fprintf('111\n')
% [beatsBefore,beatsBetween,beatsAfter]
sig1ValOld = getappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'Old']);
sig1LocOld = getappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'LocOld']);
sig2ValOld = getappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'Old']);
sig2LocOld = getappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'LocOld']);


if isBothBP
    sig1LocAfter=NaN(size(sig1Loc));
    sig2LocAfter=NaN(size(sig1Loc));
    sig1ValAfter=NaN(size(sig1Loc));
    sig2ValAfter=NaN(size(sig1Loc));
else
    sig1LocAfter = sig1Loc;
    sig1ValAfter = sig1Val;
    sig2LocAfter = NaN(size(sig1Loc));
    sig2ValAfter = NaN(size(sig1Loc));
end
counter=0;
newstart = 1;
BPNaNLoc = [];


if size(rangeLimit,1)>1
    isRangeLimitMatrix = 1;
else
    isRangeLimitMatrix = 0;
end
for ii = 1:length(sig1Loc)
    if ii >= beatsBefore+1 && ii <= beatsBefore+beatsBetween
        if isRangeLimitMatrix
            currentLimit = rangeLimit(ii,:);
        else
            currentLimit = rangeLimit(1,:);
        end
        if ~isnan(sig1Loc(ii))
            if ~any(isnan(currentLimit)) % special case for BCG where rangeLimit is defined by BPMaxLoc/BPMinLoc/ECGMaxLoc, which may contain NaNs
                locs = find(sig2Loc(newstart:end)>sig1Loc(ii)+currentLimit(1) & sig2Loc(newstart:end)<sig1Loc(ii)+currentLimit(2));
                %             fprintf(['sig1Loc @ ' num2str((sig1Loc(ii)-1)/1000) ' sec, limit = ' num2str(currentLimit) ', ' num2str(length(locs)) ' candidates found\n'])
                if ~isempty(locs)
                    %                 fprintf(['ii=' num2str(ii) ', sig1Loc=' num2str((sig1Loc(ii)-1)/1000) ' sec, locs is non empty\n'])
                    minLoc = find(abs(sig2Loc(newstart-1+locs)-sig1Loc(ii)) == min(abs(sig2Loc(newstart-1+locs)-sig1Loc(ii))),1);
                    
                    if isBothBP
                        counter = counter + 1;
                        sig1LocAfter(counter,1) = sig1Loc(ii);
                        sig2LocAfter(counter,1) = sig2Loc(newstart-1+locs(minLoc));
                        sig1ValAfter(counter,1) = sig1Val(ii);
                        sig2ValAfter(counter,1) = sig2Val(newstart-1+locs(minLoc));
                        
                    else
                        %                     locs(minLoc)
                        %                     [sig2Loc(locs(minLoc))',sig1Loc(ii)]
                        sig2LocAfter(ii) = sig2Loc(newstart-1+locs(minLoc));
                        sig2ValAfter(ii) = sig2Val(newstart-1+locs(minLoc));
                    end
                    % When one candidate feature in sig2 is paired to one in
                    % sig1, then the next pairing process should look for
                    % candidates in the remaining candidate features instead of
                    % the whole candidate features to save computation time
                    newstart = newstart-1+locs(minLoc);
                else
                    if isBothBP
                        BPNaNLoc = [BPNaNLoc,counter+1];
                        continue
                    else
                        sig2LocAfter(ii) = NaN;
                        sig2ValAfter(ii) = NaN;
                    end
                end
                
            else
                sig2LocAfter(ii) = NaN;
                sig2ValAfter(ii) = NaN;
            end
            
        else
            if isBothBP
                % Do nothing
            else
                sig2LocAfter(ii) = NaN;
                sig2ValAfter(ii) = NaN;
            end
        end
    elseif ii < beatsBefore+1
%         [length(sig2Loc),length(sig2LocOld),beatsBefore,beatsBetween,beatsAfter,ii]
        if isBothBP
            sig1LocAfter(ii) = sig1LocOld(ii);
            sig1ValAfter(ii) = sig1ValOld(ii);
            sig2LocAfter(ii) = sig2LocOld(ii);
            sig2ValAfter(ii) = sig2ValOld(ii);
            counter = counter+1;
        else
            sig2LocAfter(ii) = sig2LocOld(ii);
            sig2ValAfter(ii) = sig2ValOld(ii);
        end
    elseif ii > beatsBefore+beatsBetween
%         [length(sig2Loc),beatsBefore,beatsBetween,beatsAfter,ii]
        if isBothBP
            sig1LocAfter = [sig1LocAfter(1:ii-1,1);sig1LocOld(end-(beatsAfter-1):end)];
            sig1ValAfter = [sig1ValAfter(1:ii-1,1);sig1ValOld(end-(beatsAfter-1):end)];
            sig2LocAfter = [sig2LocAfter(1:ii-1,1);sig2LocOld(end-(beatsAfter-1):end)];
            sig2ValAfter = [sig2ValAfter(1:ii-1,1);sig2ValOld(end-(beatsAfter-1):end)];
        else
            if length(sig2Loc) > beatsAfter-1
                sig2LocAfter = [sig2LocAfter(1:ii-1,1);sig2LocOld(end-(beatsAfter-1):end)];
                sig2ValAfter = [sig2ValAfter(1:ii-1,1);sig2ValOld(end-(beatsAfter-1):end)];
            else
                sig2LocAfter = [sig2LocAfter(1:ii-1,1);sig2LocOld(end-(beatsAfter-1):end)];
                sig2ValAfter = [sig2ValAfter(1:ii-1,1);sig2ValOld(end-(beatsAfter-1):end)];
            end
        end
        break
        
    end
end
if isBothBP
    if getappdata(mPlots.Analysis.(eventTag).Parent,'initialRun') == 1
        sig1LocAfter = sig1LocAfter(1:counter,1);
        sig2LocAfter = sig2LocAfter(1:counter,1);
        sig1ValAfter = sig1ValAfter(1:counter,1);
        sig2ValAfter = sig2ValAfter(1:counter,1);
    else
        BPNaNNum = length(BPNaNLoc);
        sig1LocAfter(beatsBefore+beatsBetween-(BPNaNNum-1):beatsBefore+beatsBetween) = [];
        sig2LocAfter(beatsBefore+beatsBetween-(BPNaNNum-1):beatsBefore+beatsBetween) = [];
        sig1ValAfter(beatsBefore+beatsBetween-(BPNaNNum-1):beatsBefore+beatsBetween) = [];
        sig2ValAfter(beatsBefore+beatsBetween-(BPNaNNum-1):beatsBefore+beatsBetween) = [];
    end
end
