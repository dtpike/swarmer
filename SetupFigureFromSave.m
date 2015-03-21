function handles = SetupFigureFromSave(handles, agentClass)
% SETUPFIGUREFROMSAVE - Sets up variables and parameters based on previous value from
% a save mat file. Saves certain values to handles for use by other functions.
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

global targets robots targetsServiced numRobots

%check file exists
if exist('lastSetup.backup', 'file') ~= 2
    msgbox('lastSetup.backup file does not exist - exiting...', 'ERROR');
    throw(MException('Alan:SetupFigureFromSave', 'Error loading previous setup file'));
end
%retrieve data from file
load('lastSetup.backup', '-mat');
%check file version
if ~strcmp(VERSION, '1.3')
    uiwait(msgbox('Position file from previous version of simulator. Cannot load'));
    return;
end

%==========================================================================
%CONSTANTS/PARAMETERS
%==========================================================================
handles.numRobots = numRobots;   %number of robots
handles.numTargets = numTargets; %number of initial real targets (targets will always be first in list)
handles.numPOI = numPOI;         %number of points of interest (includes targets)
handles.timeStep = timeStep;     %time step for each iteration
handles.endTime = endTime;       %time to end simulation
areaSize = 1000;            %side length of square area

% get agent class to be used
% stored in file as agentType
% switch to user provided one if it exists
if nargin == 2
    agentType = agentClass;
end

handles.agentParameters = agentParameters;   %0 - holonomic (euler 1st order)
                            %1 - nonholonomic (r-k 4th order) - not working
%from saved file we get the following as well
%agentVelocity
%agentMinTurningRadius

handles.serviceRadius = serviceRadius;   % radius of service for target points
handles.lambda = lambda;                 % rate of poisson process for target generation
handles.generateTargets = generateTargets;
handles.lambdaRatio = lambdaRatio;
handles.recalculatePaths = recalculatePaths;

handles.detectableRegion = detectableRegion;

%==========================================================================
%INIT Section
%==========================================================================

% initialize display
handles.d = InitDisplay(handles, areaSize, 30, 7.5, 10, get(handles.check_Tour, 'Value'), get(handles.check_Voronoi, 'Value'));

robots = [];
targets = [];

% create robots with random positions and directions
for i = 1:handles.numRobots
    newRobot = agentType();
    newRobot.agentVelocity = agentVelocity;
    newRobot.minTurningRadius = agentMinTurningRadius;
    robots = [robots ; newRobot];
    robots(i).position = positions(1,:);
    vel = rand(1, 2)*2 - 1;
    robots(i).velocity = vel / norm(vel);
    robots(i).velMag = rand()*20;
    robots(i).detectArea = handles.detectableRegion;
    positions(1,:) = [];
end

% create POI
for i = 1:handles.numPOI
    targets = [targets ; TargetPoint(0, handles.serviceRadius, 0)];
    targets(i).position = positions(1,:);
    positions(1,:) = [];
end
% set some to be targets
% targs contains the indexes of the POI that should be targets
for i=1:length(targs)
    targets(targs(i)).targetPOI = 1;
end

targetsServiced = 0;

%reset stop status
handles.stop = 0;

% initial display of vehicles and targets
handles.d.Display(robots, targets, 0, handles)