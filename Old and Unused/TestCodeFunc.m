%DEPRECIATED - MOST LIKELY DOES NOT WORK
%FOR (POSSIBLY) WORKING VERSION, GO BACK TO GIT MASTER SNAPSHOT BEFORE GUI
%WAS CREATED
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

function TestCodeFunc(numRuns)
tot = 0;
for run=1:numRuns
    disp(run);
    %==========================================================================
    %CONSTANTS/PARAMETERS
    %==========================================================================
    global numTargets targets

    numRobots = 20;      %number of robots
    numTargets = 0;     %number of initial targets
    timeStep = 0.1;     %time step for each iteration
    endTime = 50;       %time to end simulation
    areaSize = 1000;    %side length of square area

    %agentType = BasicAgent;    %agent class to be used
    %agentType = CircleAgent;
    agentType = NearestTargetAgent;

    serviceRadius = 20;       % radius of service for target points
    lambda = 1;               % rate of poisson process for target generation

    display = 0;        % display robots in figure or not

    saveData = 0;       % set true to save data to outputFile as csv
    outputFile = 'output.csv';

    %==========================================================================
    %INIT Section
    %==========================================================================

    % initialize display
    if display
        d = InitDisplay(areaSize);
    end

    robots = [];
    targets = [];
    saveMatrix = [];

    % create robots with random positions and directions
    for i = 1:numRobots
        robots = [robots ; agentType()];
        robots(i).position = rand(1, 2)*areaSize - areaSize/2;
        vel = rand(1, 2)*2 - 1;
        robots(i).velocity = vel / norm(vel);
        robots(i).velMag = rand()*20;
    end

    % create targets
    for i = 1:numTargets
        targets = [targets ; TargetPoint(0, serviceRadius)];
        targets(i).position = rand(1, 2)*areaSize - areaSize/2;
    end

    % initial display of vehicles and targets
    if display
        d.Display(robots, targets, 0)
    end


    %==========================================================================
    %TIME STEPS
    %==========================================================================

    for t = 0:timeStep:endTime
        % move robots
        for i = 1:numRobots
            robots(i).position = robots(i).position + robots(i).velocity * timeStep * robots(i).velMag;
        end

        % check if an agent close enough to a target and remove
        targets = CheckTargetRadius(robots, targets, t);

        % possibly add new targets
        if t < 10
            targets = [targets ; NewTarget(lambda * timeStep, t, serviceRadius, areaSize)];
        end

        % save positions to file
        if saveData
            saveMatrix = [saveMatrix ; Save(robots, targets)];
        end

        % display new position
        if display
            d.Display(robots, targets, t);
        end

        % update velocity for next step
        for i = 1:numRobots
            robots(i) = robots(i).Update_Velocity();
        end
    end


    %==========================================================================
    %CLEAN UP
    %==========================================================================
    disp(' ');

    %output csv file if set
    if saveData
        topRow = zeros(1, (numRobots*4 + size(targets,1)*2));
        topRow(1) = numRobots;
        topRow(2) = size(targets,1);
        saveMatrix = [topRow ; saveMatrix];
        dlmwrite(outputFile, saveMatrix)
    end

    % display average service time
    totalTime = 0;
    numServiced = 0;
    for i=1:size(targets,1)
        if targets(i).serviced == 1
            totalTime = totalTime + targets(i).serviceTime;
            numServiced = numServiced + 1;
        end
    end
    if numServiced ~= size(targets, 1)
        disp([num2str(size(targets, 1) - numServiced), ' targets were not serviced.']);
    end
    disp(['Average service time for ',num2str(numServiced),' target(s) was ', num2str(totalTime/numServiced)]);

    tot = tot + totalTime/numServiced;
end
clc;
disp(tot/numRuns);
msgbox('Batch run is done!', 'Done!');

