%% DEPRECIATED - AS OF START OF GUI - GO BACK TO MASTER GIT SNAPSHOT BEFORE
%GUI FOR WORKING VERSION

%%
%Testing MVA Algorithm from Rathinam paper
%Constructs a tour for each vehicle using the algorithm, and the robot and
%target positions given in their paper.
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

clear; clc; close all;
addpath('graph');
%% ========================================================================
%CONSTANTS/PARAMETERS
%==========================================================================
global targets robots targetsServiced

numRobots = 5;      %number of robots
numTargets = 1;     %number of initial real targets (targets will always be first in list)
numPOI = 25;        %number of points of interest (includes targets)
timeStep = 0.1;     %time step for each iteration
endTime = 500;      %time to end simulation
areaSize = 1000;    %side length of square area

%agentType = BasicAgent;    %agent class to be used
%agentType = CircleAgent;
%agentType = NearestTargetAgent;
%agentType = NearestUniqueTargetAgent;
agentType = BaselineAgent;

agentParameters = 0;        %0 - holonomic (euler 1st order)
                            %1 - nonholonomic (r-k 4th order) - not working

serviceRadius = 20;         % radius of service for target points
lambda = 0.0;               % rate of poisson process for target generation

display = 1;        % display robots in figure or not

saveData = 0;       % set true to save data to outputFile as csv
outputFile = 'output.csv';

makeMovie = 0;      %set to record frames - must make movie manually at end
                    %cannot record more than ~1500 frames though

%% ========================================================================
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
    targets = [targets ; TargetPoint(0, serviceRadius, 1)];
    targets(i).position = rand(1, 2)*areaSize - areaSize/2;
end
for i = 1:numPOI-numTargets
    targets = [targets ; TargetPoint(0, serviceRadius, 0)];
    targets(i+numTargets).position = rand(1, 2)*areaSize - areaSize/2;
end

targetsServiced = 0;

% initial display of vehicles and targets
if display
    d.Display(robots, targets, 0)
end

%% construct minimum spanning trees
%construct complete graph with edges determined by euclidean distance
%-1 for edges between robots
[adj position] = CompleteGraph(robots, targets);

%calculate minimum spanning tree of the graph
span = minimum_spanning_tree(adj);
%then adjacency matrix representing tree with Euclidean distances
adj2=adj;
adj2(span==0) = 0; 

%remove zero cost edges (actually -1) to get a tree for each vehicle
adj2(adj==-1) = 0;

%display minimum spanning tree and robots and targets
gplot(adj2,position); 
d.DisplayNoDelete(robots, targets, 0);
%axis([0 90 0 65]); 
drawnow;

%% split into clusters for each robot
trees = SplitTree(adj2, size(robots, 1));

%% construct tour
adj3 = zeros(size(adj2, 1));

for i=1:size(robots,1);
    %tour = ConstructTour(trees(i,:));
    tour = ConstructOptimumTour(trees(i,:), adj);

    for j=1:length(tour)-1
        adj3(tour(j), tour(j+1)) = 1;
    end
    adj3(tour(j+1), tour(1)) = 1;
end

gplot(adj3,position); 
d.DisplayNoDelete(robots, targets, 0);
%axis([0 90 0 65]); 
drawnow;
%% STOP HERE
return;
frame=0;

%% ========================================================================
%TIME STEPS
%==========================================================================

for t = 0:timeStep:endTime
    frame=frame+1;
    
    % update velocity
    for i = 1:numRobots
        robots(i) = robots(i).Update_Velocity(); %#ok<SAGROW>
    end
    
    % move robots
    for i = 1:numRobots
        if agentParameters == 0
            %euler 1st order
            robots(i).position = robots(i).position + robots(i).velocity * timeStep * robots(i).velMag; %#ok<SAGROW>
            
        elseif agentParameters == 1
            %runge-kutta 4th order - not working
            yOut = rk4V2(y, x, derFunc, h);
            %{
            prevError = 0;
            pos = [x y rotation];   %position of robot
            dR = [0;0;0];           %derivative for robot - needs to be for each robot
            rParam = [50; 44; 0];   %parameters of robot - [speed, x2, start angle?];
            e = zeros(2,1);
            inputSignal = zeros(1,2);
            i = 1;
            
            %now iterate
            %calculate error off circle and derivative of error (store to e) (PD controller)
            u = (0.6*error)+(0.75*dervError);
            %limit u to max of 100
            
            inputSignal(i) = u;
            prevError = error;
            u=10;
            
            %Translate the value u into the PWM for the left wheel
            %transform u to radians
            turnRate = 180/u;
            decimalRadians = pi/turnRate;
            rParam(2) = u;
            inputSignal(i) = u;
            
            % Integrate pursuer
            dR = DerivRobot(heading, u);
            pos = rk4(pos, dR, 3, time, timeStep, @DerivRobot, u);
            
            % Plot robot
            
            % Increment time
            time = time + h;
            i = i + 1;
            %}
        end
    end
    
    % possibly add new targets - not in baseline
    %if 1 %t < 500 %1 %size(targets,1)<223
    %    targets = [targets ; NewTarget(lambda * timeStep, t, serviceRadius, areaSize)];
    
    % check if an agent close enough to a target and remove
    targets = CheckTargetRadius(targets, t);
    
    %end condition for simulation
    if sum([targets([targets.targetPOI]==1).serviced]) == numTargets %targetsServiced == size(targets, 1)
        break
    end
    
    % save positions to file
    if saveData
        saveMatrix = [saveMatrix ; Save(robots, targets)];
    end
    
    % display new position
    if display
        d.Display(robots, targets, t);
    end
    
	% save frames for movie
    if makeMovie
        mov(1, frame) = getframe(gcf);
    end 
end

%% ========================================================================
%CLEAN UP
%==========================================================================
disp(' ');

% display instructions about making avi file
if makeMovie
	disp('Need to run this by hand:');
	disp('movie2avi(mov, ''filename.avi''');
end

% get areas of Voronoi regions
tess_area = CalcAreaVoronoi(robots, areaSize);
disp(['Areas of Voronoi partitions ', num2str(tess_area', '% 10.0f')]);
disp(['Max: ', num2str(max(tess_area), '% 10.0f'), ' Min: ', num2str(min(tess_area), '% 10.0f')]);
disp(['Std ', num2str(std(tess_area), '% 10.0f')]);

%output csv file if set
if saveData
    topRow = zeros(1, (numRobots*4 + size(targets,1)*2));
    topRow(1) = numRobots;
    topRow(2) = size(targets,1);
    saveMatrix = [topRow ; saveMatrix];
    dlmwrite(outputFile, saveMatrix)
end

% display average service time
serviceTimes = ([targets(([targets.serviced]==1 .* [targets.targetPOI]==1) == 1).serviceTime]);
totalTime = sum(serviceTimes);
numServiced = size(serviceTimes,2);

if numServiced ~= size(targets, 1)
    disp([num2str(size(targets, 1) - numServiced), ' targets were not serviced.']);
end
disp(['Average service time for ',num2str(numServiced),' target(s) was ', num2str(totalTime/numServiced)]);