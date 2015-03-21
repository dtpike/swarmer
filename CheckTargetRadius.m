function targets = CheckTargetRadius(targets, time)
%CHECKTARGETRADIUS Checks and removes any targets with an agent within its 
%   minimum radius of service
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%for each target, check if a robot within minimum distance
for i = 1:size(targets, 1)
    if targets(i).serviced == 0
        targets(i) = targets(i).CheckRadius(time);
    end
end