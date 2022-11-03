function [includedRange]=timeComplement(timeRange,excludedRange,minTimeDuration)
% Literally take the complement set of the excluded BP calibration segments
% from the overall analysis range

if isempty(excludedRange)
    includedRange=timeRange;
else
    includedRange=[];
    for ii=1:size(excludedRange,1)
        if ii==1
            if timeRange(1)==excludedRange(ii,1)
                continue
            elseif excludedRange(ii,1)-timeRange(1)<minTimeDuration
                continue
            elseif excludedRange(ii,1)-timeRange(1)>=minTimeDuration
                includedRange(1,1:2)=[timeRange(1),excludedRange(1,1)];
            end
        else
            if excludedRange(ii,1)-excludedRange(ii-1,2)<minTimeDuration
                continue
            else
                includedRange=[includedRange;[excludedRange(ii-1,2),excludedRange(ii,1)]];
            end
        end
    end
    if timeRange(2)-excludedRange(end,2)>=minTimeDuration
        includedRange=[includedRange;[excludedRange(end,2),timeRange(2)]];
    end
end
