function [robot1,robot2] = exchangeServicedTargets(robot1,robot2)

%Swaps local B sets and truncates
%Add sets from robot1.B and robot2.B
%Assumes all targets in robot1.B and robot2.B are serviced

COLLECTIVE_B = [robot1.B; robot2.B];
%remove repeats
%Collect UIDs
if ~isempty(COLLECTIVE_B)
    
    %NOTE: find another way to do this locally!!!!
    global targets
    
    ALL_UIDS = zeros(1,size(COLLECTIVE_B,1));
    for i=1:size(COLLECTIVE_B,1)
        ALL_UIDS(i) = COLLECTIVE_B(i).UID;
    end

    %Remove repeated entries
    UNIQUE_UIDS = unique(ALL_UIDS);

    for i=1:size(UNIQUE_UIDS,2)
        UNIQUE_DEMANDS(i,1) = targets(UNIQUE_UIDS(i));
    end
    
    robot1.B = UNIQUE_DEMANDS;
    robot2.B = UNIQUE_DEMANDS;
end

end