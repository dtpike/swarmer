function simulateLocalAgents(handles, INITIAL_VEHICLE_POSITIONS, targets)

%-------------------------------------------------------------------------%
%FUNCTION       simulateLocalAgents
%INPUTS         handles- environment handles for problem instance
%               INITIAL_VEHICLE_POSITIONS
%               targets
%-------------------------------------------------------------------------%                  


global robots targets num_generated_targets robot_positions targetsServiced

num_generated_targets = handles.NUM_INITIAL_TARGETS;

END_CONDITION = 0;

%Create exploration points, must have R.SENSE and areaSize already set
%Only takes in rectangular environments
handles = createExplorePoints(handles);

%setup figure, robots, targets
handles = setupFigureLocal(handles,robot_positions);

for i=1:size(robots,1)
    robots(i).C_LOCAL = Rathinam1(robots(i),robots(i).C_LOCAL);
    robots(i).Cnext = robots(i).C_LOCAL(1).index;
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

    %Collaboration Module
    i = 1;
    while i<=size(robots,1)
        j = i + 1;
        while j<=size(robots,1)
            if Distance(robots(i).position,robots(j).position) <= handles.R_COMM && ~isempty(robots(i).C_LOCAL) && ~isempty(robots(j).C_LOCAL)...
                && (robots(i).LCI ~= robots(j).ROBOT_INDEX) && (robots(j).LCI ~=robots(i).ROBOT_INDEX)
                [robots(i),robots(j)] = Collaborate2(robots(i),robots(j));
            end
            j = j + 1;
        end%while
        i = i + 1;
    end%while
    
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
    
    %Display new positions
    if handles.showDisplay == 1
        handles.d.Display(robots, targets, t, handles);
    end

    %Target generation and end condition
    %check to see if there are still targets left to generate
    if num_generated_targets < handles.NUM_TARGETS
        %fprintf('%d targets left to generate\n',size(generated_targets,1));
        
        %Targets left to generate, check poisson random number
        f = poissrnd(handles.lambda*handles.timeStep,1,1);%number of targets to generate (usually 0 or 1)
        if f<=(handles.NUM_TARGETS-num_generated_targets)
            for i=1:f
                %set num_generated_targets + 1
                targets(num_generated_targets + 1).created = 1;
                targets(num_generated_targets + 1).timeCreated = t;
                num_generated_targets = num_generated_targets + 1;
            end
        else%poisson process wants to create more targets than the total number, generate what's left
            for i=1:(handles.NUM_TARGETS - num_generated_targets)
                targets(num_generated_targets + i).created = 1;
                targets(num_generated_targets + i).timeCreated = t;
            end
            num_generated_targets = handles.NUM_TARGETS;
        end
    end   
    if t == handles.endTime
        END_CONDITION = 1;
    end   

    %increment timer
    t = t + handles.timeStep;

end%simulation

%fprintf('End condition met!\n');

end%function