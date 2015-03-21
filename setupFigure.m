function handles = SetupFigure(handles)
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

%handles.numRobots = get(handles.slider_vehicles,'Value'); %number of robots
numRobots = handles.numRobots;
%numTargets = get(handles.slider_targets,'Value'); %number of initial real targets (targets will always be first in list)
%handles.numTargets = numTargets;
%numPOI = get(handles.slider_POI,'Value');         %number of points of interest (includes targets)
%handles.numPOI = numPOI;
%timeStep = str2double(get(handles.text_timeStep,'String')); %time step for each iteration
%handles.timeStep = timeStep;
%endTime = 500;      %time to end simulation
%handles.endTime = endTime;
%handles.areaSize = 1000;            %side length of square area
areaSize = handles.areaSize;

% get agent class to be used
%choice = get(handles.listbox_policies,'Value');
%stringData = get(handles.listbox_policies,'String');
%if length(choice) > 1 
%    if handles.multipleRun == 0
%        uiwait(msgbox(['You have selected multiple policies, you must have a single policy to setup figure. ', 'If you want to run multiple polices, click that button instead'], 'Invalid choice'));
%        return;
%    else
%        agentType = eval([stringData{choice(1)}, 'Agent']);
%    end
%else
%    agentType = eval([stringData{choice}, 'Agent']);
%end

agentType = handles.agentType;

agentParameters = handles.agentParameters;        %0 - holonomic (euler 1st order)
                            %1 - nonholonomic (r-k 4th order) - not working
agentVelocity = handles.agentVelocity;%str2double(get(handles.edit_AgentVelocity, 'String'));
%agentMinTurningRadius = str2double(get(handles.edit_MinTurningRadius, 'String'));

%handles.serviceRadius = 5;         % radius of service for target points
serviceRadius = handles.serviceRadius;
%handles.lambda = str2double(get(handles.edit_lambda, 'String'));  %rate of poisson process for target generation
lambda = handles.lambda;
%handles.generateTargets = get(handles.check_targetGeneration, 'Value');
generateTargets = handles.generateTargets;
%handles.lambdaRatio = str2double(get(handles.edit_lambdaRatio, 'String'));
lambdaRatio = handles.lambdaRatio;
%handles.recalculatePaths = get(handles.check_recalculatePaths, 'Value');
recalculatePaths = handles.recalculatePaths;
disp(class(agentType));
detectableRegion = handles.detectableRegion;

assert(handles.lambdaRatio <= 1 && handles.lambdaRatio >= 0);
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

%Will not be using obstacles, REMOVE
% create an obstacle only if some modified agent policy is selected
%if choice > 6
%    obstacles = readObstacles();
    %obstacles = readObstacles('testObstacles.obstacle');
%end

%handles.numTargets = handles.numPOI;

%TODO: Why are agents always starting in a line?!?!?!?!?!?!
%Import problem instance
[robot_positions, targets] = createProblemInstance(handles.numRobots,handles.numTargets,handles.serviceRadius,handles.areaSize);

% create robots with random positions and directions
for i = 1:handles.numRobots
    newRobot = SmartBaselineAgent();
    newRobot.agentVelocity = agentVelocity;
    newRobot.minTurningRadius = 0;
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

% create targets
%for i = 1:handles.numTargets
%    targets = [targets ; TargetPoint(0, handles.serviceRadius, 1)];
%    targets(i).position = rand(1, 2)*handles.areaSize - handles.areaSize/2;
%    %make sure POI isn't inside an obstacle
%    while size(obstacles, 1) > 0 && sum(obstacles.inObstacle(targets(i).position(1), targets(i).position(2))) > 0
%        targets(i).position = rand(1, 2)*handles.areaSize - handles.areaSize/2;
%    end
%    
%    %save position
%    positions = [positions; targets(i).position];
%end


%REMOVED FOR NOW
% save parameters and generated locations to file, so they can be recalled
%   using SetupFigureFromSave
%save('lastSetup.backup', '-mat', 'VERSION', 'numRobots', 'numTargets', 'numPOI', 'timeStep', 'endTime', 'agentType', 'agentParameters', 'agentVelocity', 'agentMinTurningRadius', 'serviceRadius', 'lambda', 'generateTargets', 'lambdaRatio', 'recalculatePaths', 'targs', 'positions', 'obstacles', 'detectableRegion');

targetsServiced = 0;

%reset stop status
handles.stop = 0;

% initial display of vehicles and targets
%handles.d.Display(robots, targets, 0, handles)