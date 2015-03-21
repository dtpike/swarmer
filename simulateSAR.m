function t = simulateSAR(handles)

%-------------------------------------------------------------------------%
%FUNCTION:       simulateLocalAgents
%INPUTS  :       handles- environment handles for problem instance
%               
%To be called from evaluateSAR with globals 'robots', 'targets',
%'robot_positions'
%-------------------------------------------------------------------------%                  


global robots targets robot_positions END_CONDITION

END_CONDITION = 0;

%Create exploration points, must have R.SENSE and areaSize already set
%Only takes in rectangular environments
handles = createExplorePoints(handles);

%setup figure, robots, targets
handles = setupFigureLocalSAR(handles,robot_positions);

for i=1:size(robots,1)
    robots(i).C_LOCAL = Rathinam1(robots(i),robots(i).C_LOCAL);
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

t = 0;

while ~END_CONDITION

    %Collaboration Module
    i = 1;
    while i<=size(robots,1)
        j = i + 1;
        while j<=size(robots,1)
            if Distance(robots(i).position,robots(j).position) <= handles.R_COMM && ~isempty(robots(i).C_LOCAL) && ~isempty(robots(j).C_LOCAL)...
                && (robots(i).LCI ~= robots(j).ROBOT_INDEX) && (robots(j).LCI ~=robots(i).ROBOT_INDEX)
                [robots(i),robots(j)] = Collaborate2vSAR(robots(i),robots(j));
            end
            j = j + 1;
        end%while
        i = i + 1;
    end%while
    
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
    
    %Display new positions
    if handles.showDisplay == 1
        handles.d.Display(robots, targets, t, handles);
    end
    
    t = t + handles.timeStep;

end%simulation

end%function