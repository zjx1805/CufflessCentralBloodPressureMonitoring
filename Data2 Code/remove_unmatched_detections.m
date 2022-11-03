% function takes the feet detections of 2 signals (one earlier than the
% other), the maximum expected ptt for those signals and sampling frequency
% fs. It matches the detections based on the max ptt and returns the
% matched detections.


function[earlier_feet_idx, later_feet_idx] = remove_unmatched_detections(earlier_feet_idx, later_feet_idx, max_ptt, fs)
earlier_feet_idx1 = earlier_feet_idx; later_feet_idx1 = later_feet_idx;
earlier_feet_idx = earlier_feet_idx1; later_feet_idx = later_feet_idx1;
% max_ptt = 0.4;
for k = length(earlier_feet_idx):-1:1
    duration_earlier_to_later = abs(later_feet_idx - earlier_feet_idx(k));
    if (min(duration_earlier_to_later) > max_ptt*fs)
        earlier_feet_idx(k) = [];
    end
end
for k = length(later_feet_idx):-1:1
    duration_earlier_to_later = abs(later_feet_idx(k) - earlier_feet_idx);
    if (min(duration_earlier_to_later) > max_ptt*fs)
        later_feet_idx(k) = [];
    end
end
if length(later_feet_idx) ~= length(earlier_feet_idx)
    later_feet_idx(later_feet_idx < min(earlier_feet_idx)) = [];
    earlier_feet_idx(earlier_feet_idx > max(later_feet_idx)) = [];
    for k = length(earlier_feet_idx):-1:1
        duration_earlier_to_later = (later_feet_idx(later_feet_idx > earlier_feet_idx(k)) - earlier_feet_idx(k));
        if (min(duration_earlier_to_later) < 0.05*fs) || (min(duration_earlier_to_later) > max_ptt*fs)
            earlier_feet_idx(k) = [];
        end
    end
    for k = length(later_feet_idx):-1:1
        duration_earlier_to_later = (later_feet_idx(k) - earlier_feet_idx(earlier_feet_idx < later_feet_idx(k)));
        if (min(duration_earlier_to_later) < 0.05*fs) || (min(duration_earlier_to_later) > max_ptt*fs)
            later_feet_idx(k) = [];
        end
    end
    later_feet_idx(later_feet_idx < min(earlier_feet_idx)) = [];
    earlier_feet_idx(earlier_feet_idx > max(later_feet_idx)) = [];
end
if length(later_feet_idx) ~= length(earlier_feet_idx)
    for k = length(earlier_feet_idx):-1:1
        duration_earlier_to_later = abs(later_feet_idx - earlier_feet_idx(k));
        if (min(duration_earlier_to_later) > max_ptt*fs)
            earlier_feet_idx(k) = [];
        elseif length(duration_earlier_to_later(duration_earlier_to_later <= max_ptt*fs)) > 1
            later_feet_idx(duration_earlier_to_later <= max_ptt*fs) = [];
            earlier_feet_idx(k) = [];
        end
    end
    for k = length(later_feet_idx):-1:1
        duration_earlier_to_later = abs(later_feet_idx(k) - earlier_feet_idx);
        if (min(duration_earlier_to_later) > max_ptt*fs)
            later_feet_idx(k) = [];
        elseif length(duration_earlier_to_later(duration_earlier_to_later <= max_ptt*fs)) > 1
            earlier_feet_idx(duration_earlier_to_later <= max_ptt*fs) = [];
            later_feet_idx(k) = [];
        end
    end
end
if length(later_feet_idx) ~= length(earlier_feet_idx)
    keyboard;
end