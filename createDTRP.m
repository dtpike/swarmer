function instance = createDTRP(handles)

robot_positions = [];
%generated_targets = [];

%serviceRadius = handles.serviceRadius;
areaSize = handles.areaSize;

for i = 1:handles.numRobots
    newPosition = rand(1,2)*areaSize - areaSize/2;
    robot_positions = [robot_positions; newPosition];
    
end

% %Create all targets
% for i = 1:handles.NUM_TARGETS
%     generated_targets = [generated_targets; TargetPoint(0, serviceRadius,1)];
%     generated_targets(i).position = rand(1,2)*areaSize - areaSize/2;
%     generated_targets(i).UID = i;
% end

% %Set created = 1 for intial targets
% for i=1:handles.NUM_INITIAL_TARGETS
%     generated_targets(i).created = 1;
% end

instance.ROBOT_POSITIONS = robot_positions;
%ProblemInstance.ALL_TARGETS = generated_targets;

end

