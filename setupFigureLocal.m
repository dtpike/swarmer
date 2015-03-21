function handles = setupFigureLocal(handles,robot_positions)
% SETUPFIGURE - Sets up variables and parameters based on hard coded values
% and user selections from the GUI elements. Saves certain values to
% handles for use by other functions. 
% Saves parameters to a file for later recall as well.
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%==========================================================================
%CONSTANTS/PARAMETERS
%==========================================================================
global targets robots generated_targets targetsServiced numRobots obstacles VERSION areaSize


numRobots = handles.numRobots;
areaSize = handles.areaSize;
agentType = handles.agentType;
agentParameters = handles.agentParameters;          %0 - holonomic (euler 1st order)
                                                    %1 - nonholonomic (r-k 4th order) - not working
agentVelocity = handles.agentVelocity;              %str2double(get(handles.edit_AgentVelocity, 'String'));
serviceRadius = handles.serviceRadius;
lambda = handles.lambda;
generateTargets = handles.generateTargets;
lambdaRatio = handles.lambdaRatio;
recalculatePaths = handles.recalculatePaths;
disp(class(agentType));
detectableRegion = handles.detectableRegion;


%==========================================================================
%INIT Section
%==========================================================================


% initialize display
handles.d = InitDisplay(handles, handles.areaSize, 30, 7.5, 10, 1, 0);

robots = [];
%targets = [];
positions = [];
obstacles = [];
handles.pathMatrix = [];
handles.pathPoints = [];

% create robots with random positions and directions
for i = 1:handles.numRobots
    newRobot = TilingAgent();
    newRobot.serviceRadius = handles.serviceRadius;
    newRobot.agentVelocity = agentVelocity;
    newRobot.minTurningRadius = 0;
    newRobot.R_COMM = handles.R_COMM;
    newRobot.R_SENSE = handles.R_SENSE;
    newRobot.ROBOT_INDEX = i;
    newRobot.detectArea = detectableCircle(handles.R_SENSE);
    
    %Explore points
    newRobot.C_GLOBAL = handles.C_GLOBAL;
    newRobot.C_LOCAL = handles.C_GLOBAL;

    
    robots = [robots ; newRobot];
    
    %create robot in positions from initial configuration
    position = robot_positions(i,:);
    %make sure robot isn't inside an obstacle - NOT USING OBSTACLES
    while size(obstacles, 1) > 0 && sum(obstacles.inObstacle(position(1), position(2))) > 0
        position = rand(1, 2)*handles.areaSize - handles.areaSize/2;
    end
    robots(i).position = position;
        
    vel = rand(1, 2)*2 - 1;
    robots(i).velocity = vel / norm(vel);
    robots(i).velMag = agentVelocity;
    robots(i).detectArea = handles.detectableRegion;
    
    %save position          why??
    positions = [positions; robots(i).position];
end


%REMOVED FOR NOW
% save parameters and generated locations to file, so they can be recalled
%   using SetupFigureFromSave
%save('lastSetup.backup', '-mat', 'VERSION', 'numRobots', 'numTargets', 'numPOI', 'timeStep', 'endTime', 'agentType', 'agentParameters', 'agentVelocity', 'agentMinTurningRadius', 'serviceRadius', 'lambda', 'generateTargets', 'lambdaRatio', 'recalculatePaths', 'targs', 'positions', 'obstacles', 'detectableRegion');

targetsServiced = 0;

%reset stop status
handles.stop = 0;

% initial display of vehicles and targets
%handles.d.Display(robots, targets, 0, handles)