function SENSED_TARGETS = senseTargets(position,R_SENSE,current_targets)%#codegen

coder.varsize('SENSED_TARGETS',[10000 1],[1 0]);
SENSED_TARGETS = [];

for i=1:size(current_targets,1);%iterate through targets
    %Check if target position is within R_SENSE
    if (Distance(current_targets(i).position,position) <= R_SENSE && current_targets(i).serviced == 0 && current_targets(i).created == 1);
        SENSED_TARGETS = [SENSED_TARGETS; current_targets(i)];
    end %if
end %for

end%function