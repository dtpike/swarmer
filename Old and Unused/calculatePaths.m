function handles = calculatePaths(handles)
%CALCULATEPATHS - Called from the main GUI.
% Calculates a tour for each robot based mostly on the method in
% Rathinam2005 (see accompanying report for bibliography).
%
% Constructs a minimum spanning tree of the complete graph with edges
% determined by euclidean distance. Distance between robots is set to
% "zero". Then by removing zero cost edges we get a tree for each robot.
% A tour for each robot is then calculated using either Eulerian walks (as
% in Rathinam) or an exact TSP solution (Held1962)
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

global robots targets numRobots

agentType = class(robots(1));
agentType = agentType(1:end-5);

%Move code to agent class definition????

if strcmp(agentType, 'NearestToTarget')
    [adj position mapIndices] = CompleteGraph(robots, targets);
    adj2 = TestTreeSplit(adj);  %create trees based on nearest agent to target
    adj2 = adj2 + adj2';        %mirror trees in other direction
    gplot(adj2,position);       %plot
    handles.d.DisplayNoDelete(robots, targets, 0);
    %axis([0 90 0 65]); 
    drawnow;
    % split into clusters for each robot
    trees = SplitTree(adj2, size(robots, 1));
elseif strcmp(agentType, 'SmartBaseline') || strcmp(agentType, 'Baseline') || strcmp(agentType, 'Rathinam')
    % construct minimum spanning trees
    %construct complete graph with edges determined by euclidean distance
    %-1 for edges between robots
    [adj position mapIndices] = CompleteGraph(robots, targets);

    %calculate minimum spanning tree of the graph
    span = minimum_spanning_tree(adj);
    %then adjacency matrix representing tree with Euclidean distances
    adj2=adj;
    adj2(span==0) = 0; 

    %remove zero cost edges (actually -1) to get a tree for each vehicle
    adj2(adj==-1) = 0;

    %display minimum spanning tree and robots and targets
    gplot(adj2,position); 
    handles.d.DisplayNoDelete(robots, targets, 0);
    drawnow;

    % split into clusters for each robot
    trees = SplitTree(adj2, size(robots, 1));
else
    %do nothing
    %for policies which do not create a tour
    handles.d.DisplayNoDelete(robots, targets, 0);
    drawnow;
    handles.pathMatrix = 1;
    handles.pathPoints = [1 1];
    return;
end

% construct tour
adj3 = zeros(size(adj2, 1));

for i=1:size(robots,1);
    if strcmp(agentType, 'Rathinam')
        %if agent is Rathinam, construct a tour using eulerian walks
        tour = ConstructTour(trees(i,:));
    elseif strcmp(agentType, 'Baseline')
        %construct an optimum tour
        tour = ConstructOptimumTour(trees(i,:), adj);
    elseif strcmp(agentType, 'SmartBaseline') || strcmp(agentType, 'NearestToTarget')
        tour = ConstructOptimumTour(trees(i,:), adj);
        %if agent is SmartBaseline, find the best direction to start the tour
        tour = BestTourDirection(tour, adj);
    else
        tour = i;
        %do nothing
    end
    %save this tour to the robot, removing itself from the front
    robots(i).tour = mapIndices(tour(2:end) - numRobots) + numRobots;
    if isempty(tour) %this checks if we hit stop and returns the handles so we know
        handles = guidata(gcbo);
        return;
    end

    %constructs adjacency matrix of tours, so we can plot them easily
    for j=1:length(tour)-1
        adj3(tour(j), tour(j+1)) = 1;
    end
    adj3(tour(j+1), tour(1)) = 1;
end

%plots tour, robots, and targets
gplot(adj3,position); 
handles.d.DisplayNoDelete(robots, targets, 0);
%axis([0 90 0 65]); 
drawnow;
handles.pathMatrix = adj3;
handles.pathPoints = position;