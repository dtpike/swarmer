function [robots,targets] = CheckTargetRadius2(serviceRadius,time,robots,targets)
%CHECKTARGETRADIUS Checks and removes any targets with an agent within its 
%   minimum radius of service
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%global NUM_TARGETS_SERVICED


%for each target, check if a robot within minimum distance
for i = 1:size(targets, 1)
    if targets(i).serviced == 0
        for j=1:size(robots,1)
            %Check if robot is within service radius of target
            if (Distance(targets(i).position,robots(j).position) <= serviceRadius);
                %Service target
                targets(i).serviced = 1;
                targets(i).timeServiced = time;
                targets(i).serviceTime = targets(i).timeServiced - targets(i).timeCreated;
                %NUM_TARGETS_SERVICED = NUM_TARGETS_SERVICED + 1;
                
                %Remove from LOCAL_DEMAND of robot j
                robots(j) = robots(j).Service_Target(targets(i));
            end
        end%for
    end
end%for
end%function