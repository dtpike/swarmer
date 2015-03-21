function adj2 = TestTreeSplit(adj)
% TESTTREESPLIT - Constructs a tree, with each target attached to its
% closest agent. Used by NearestToTargetAgent
% INPUT - adj is an adjacency matrix with weights the distances between
% nodes. First n nodes are the n robots and the other nodes are the targets
% OUTPUT - adj2 - an adjacency matrix with 1 representing connections
% between nodes
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

global numRobots

adj2 = zeros(size(adj));
adj(numRobots+1:end,numRobots+1:end) = 0;


%for each target
for i=numRobots+1:size(adj,1)
    %find index of minimum distance to a robot
    dist = min(adj(i, 1:numRobots));
    minID = find(adj(i,:) == dist, 1);
    adj2(i,minID) = 1;
end