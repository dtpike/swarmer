function TARGETS = addTarget(TARGETS,NEW_TARGETS,ROBOT_INDEX)
%INPUT- n*1 array of targets
%       n*1 array of targets to add
% Ensures estimated service time is set to minimum found for target UID

if isempty(TARGETS)
    %add NEW_TARGET to TARGETS and return
    TARGETS = NEW_TARGETS;
else
    %Run through all NEW_TARGETS instances
    for j=1:size(NEW_TARGETS,1)
        NEW_TARGET = NEW_TARGETS(j);
        %check if target is new
        NEW = 1;
        NEW_UID = NEW_TARGET.UID;
        for i=1:size(TARGETS,1)
            if NEW_UID == TARGETS(i).UID
                %Old target, break loop and return old target set
                MIN_EST = min(TARGETS(i).EXPECTED_SERVICE_TIME,NEW_TARGET.EXPECTED_SERVICE_TIME);
                NEW_TARGET.EXPECTED_SERVICE_TIME = MIN_EST;
                TARGETS(i) = NEW_TARGET;
                NEW = 0;
                break;
            end
        end
        %if for loop runs through all targets and doesn't enter 'if', NEW = 1
        if NEW == 1
            %add NEW_TARGET to TARGETS
            TARGETS = [TARGETS; NEW_TARGET];
            %fprintf('Target %d added to local demand %d\n',NEW_TARGET.UID,ROBOT_INDEX);
        end
    end
end
end%function