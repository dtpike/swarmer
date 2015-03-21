function simulateDTRP(handles)

%-------------------------------------------------------------------------%
%FUNCTION       simulateLocalAgents
%INPUTS         handles- environment handles for problem instance
%               INITIAL_VEHICLE_POSITIONS
%               targets
%-------------------------------------------------------------------------%                  


global robots targets current_targets num_generated_targets robot_positions targetsServiced

num_generated_targets = handles.NUM_INITIAL_TARGETS;

targetsServiced = 0;

%Create exploration points, must have R.SENSE and areaSize already set
%Only takes in rectangular environments
handles = createExplorePoints(handles);

%setup figure, robots, targets
handles = setupFigureLocal(handles,robot_positions);

for i=1:size(robots,1)
    robots(i).C_LOCAL = Rathinam1(robots(i).position,robots(i).C_LOCAL);
end

%-----------------------Enter simulation loop-----------------------------%
%Loop simulates executes modules for each vehilce in a decentralized
%manner. Each vehicle contains:
%   Sensing Module
%   Collaboration Module
%   Tour Calculation Module
%   Update Velocity Module
%   Motor Control Module (moving vehicles through each timestep)
%   Check Position Module
%-------------------------------------------------------------------------%

for t=0:handles.timeStep:handles.endTime
    
    %TODO: optimize 'Collaboration' if possible
    %---------------------------------------------------------------------%
    %-------------Collaboration-------------------------------------------%
    %---------------------------------------------------------------------%
    
    %---------------------------------------------------------------------%
    
%     i = 1;
%     while i<=size(robots,1)
%         j = i + 1;
%         while j<=size(robots,1)
%             if Distance(robots(i).position,robots(j).position) <= handles.R_COMM &&...
%                     ~isempty(robots(i).C_LOCAL) &&...
%                     ~isempty(robots(j).C_LOCAL) &&...
%                     (robots(i).LCI ~= robots(j).ROBOT_INDEX) &&... 
%                     (robots(j).LCI ~=robots(i).ROBOT_INDEX)
%                 
%                 [robots(i),robots(j)] = Collaborate2(robots(i),robots(j));
%             end
%             j = j + 1;
%         end%while
%         i = i + 1;
%     end%while
    %---------------------------------------------------------------------%
    %---------------------------------------------------------------------%
    %put positions of robots into array
    robot_positions = zeros(size(robots,1),2);
    for i=1:size(robots,1)
        robot_positions(i,:) = robots(i).position;
    end
    %robot_positions = robots(:,:).position;
    neighbours = checkNeighbours(robot_positions,handles.R_COMM);
        
    for i=1:size(neighbours,1)
        if ~isempty(robots(neighbours(i,1)).C_LOCAL) &&...
                ~isempty(robots(neighbours(i,2)).C_LOCAL) &&...
                robots(neighbours(i,1)).LCI ~= robots(neighbours(i,2)).ROBOT_INDEX &&...
                robots(neighbours(i,2)).LCI ~= robots(neighbours(i,1)).ROBOT_INDEX
            
            [robots(neighbours(i,1)),robots(neighbours(i,2))] =... 
                Collaborate2(robots(neighbours(i,1)),robots(neighbours(i,2)),handles.policy);
        end
    end%for
    %---------------------------------------------------------------------%
    
    %---------------------------------------------------------------------%
    %-------------Robot-Steps---------------------------------------------%
    %---------------------------------------------------------------------%
    
    %Tour Calculation
    for i=1:size(robots,1)
        robots(i) = robots(i).Tour_Calculation();
    end
    
    %Update Velocity
    for i=1:size(robots,1)
        robots(i) = robots(i).Update_Velocity();
    end
    
    %Motor Control Module
    for i=1:size(robots,1)
        robots(i).position = robots(i).position + robots(i).velocity * handles.timeStep * robots(i).velMag;
    end
    
    %Check Position Module
    for i=1:size(robots,1)
        robots(i) = robots(i).hasArrived(t);
    end
    
    %---------------------------------------------------------------------%
    %-------------End-Robot-Steps-----------------------------------------%
    %---------------------------------------------------------------------%
    
    %Display new positions
    if handles.showDisplay == 1
        handles.d.Display(robots, targets, t, handles);
    end
    
    %Target generation
    f = poissrnd(handles.lambda*handles.timeStep,1,1);%number of targets to generate (usually 0 or 1)

    for i=1:f
        %create new target
        new_target = NewPoint(0,rand(1,2)*handles.areaSize - handles.areaSize/2,...
            handles.serviceRadius,num_generated_targets + 1,t);
        current_targets = [current_targets; new_target];
        targets = [targets; new_target];

        %Increase generated targets count
        num_generated_targets = num_generated_targets + 1;
    end

end%simulation

end%function