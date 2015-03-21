%% DEPRECIATED DOES NOT WORK AS OF GUI BRANCH - GO BACK TO GIT MASTER FOR
%WORKING VERSION

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

numRobots = 3;      %number of robots
numTargets = 0;     %number of initial real targets (targets will always be first in list)
numPOI = 20;        %number of points of interest (includes targets)
timeStep = 0.1;     %time step for each iteration
endTime = 500;     %time to end simulation
areaSize = 1000;    %side length of square area

%agentType = BasicAgent;    %agent class to be used
%agentType = CircleAgent;
%agentType = NearestTargetAgent;
%agentType = NearestUniqueTargetAgent;
agentType = BaselineAgent;

serviceRadius = 20;

%% ========================================================================
%INIT Section
%==========================================================================

% initialize display
d = InitDisplay(areaSize, 3, 0.75, 1);

robots = [];
targets = [];

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
end
for i = 1:numPOI-numTargets
    targets = [targets ; TargetPoint(0, serviceRadius, 0)];
end

robots(1).position = [15 23];
robots(2).position = [44 15];
robots(3).position = [55 33];
targets(1).position = [10 37];
targets(2).position = [18 38];
targets(3).position = [10 31];
targets(4).position = [17 32];
targets(5).position = [24 29];
targets(6).position = [9 15];
targets(7).position = [18 16];
targets(8).position = [22 19];
targets(9).position = [39 23];
targets(10).position = [49 20];
targets(11).position = [39 11];
targets(12).position = [48 9];
targets(13).position = [58 46];
targets(14).position = [50 43];
targets(15).position = [58 38];
targets(16).position = [47 33];
targets(17).position = [67 35];
targets(18).position = [65 30];
targets(19).position = [59 25];
targets(20).position = [69 24];
for i=1:3
    %robots(i).position = (robots(i).position - 30)*12;
end
for i=1:20
    %targets(i).position = (targets(i).position -30)*12;
end

targetsServiced = 0;

% initial display of vehicles and targets
d.Display(robots, targets, 0)

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
axis([0 90 0 65]); drawnow;

%% split into clusters for each robot
trees = SplitTree(adj2, size(robots, 1));

%% construct tour
adj3 = zeros(size(adj2, 1));

for i=1:size(robots,1);
    %tour = ConstructTour(trees(i,:));
    %tour = ConstructExactTour(trees(i,:), adj);
    tour = ConstructOptimumTour(trees(i,:), adj);

    for j=1:length(tour)-1
        adj3(tour(j), tour(j+1)) = 1;
    end
    adj3(tour(j+1), tour(1)) = 1;
end

gplot(adj3,position); 
d.DisplayNoDelete(robots, targets, 0);
axis([0 90 0 65]); drawnow;



