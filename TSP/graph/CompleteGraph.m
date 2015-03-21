function adj = CompleteGraph(targets,p1,p2)%#codegen
%TODO: edit comments for only two robots
%COMPLETEGRAPH Constructs an adjacency matrix representing the complete
%graph of robots and targets.
%Euclidean distance is used as the cost between any two targets, or between
%a target and a robot. Cost between two robots is -1 (zero cost), since the
%minimum_spanning_tree algorithm uses zero already to denote empty edges.
%INPUTS
%robots - nx1 array of Agent (robot) class objects
%targets - mx1 array of TargetPoint objects
%
%targets is reduced to those which have not been serviced
%RETURNS adj - n+m x n+m adjacency matrix with robots as first n rows or columns
%position - n+m x 2 matrix representing objects positions on plane
%mapIndices - the indices of the targets in the graph - necessary to
%   convert indices from the completeGraph to indices of the array targets
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

numTargets = size(targets,1);

if nargin == 2
    
    numRobots = 1;
    adj = zeros(numRobots+numTargets);
    
    for j=1:numTargets
        adj(1,j+numRobots) = Distance(p1, targets(j).position);
    end
    
elseif nargin == 3
    
    numRobots = 2;
    adj = zeros(numRobots+numTargets);
    adj(1,2) = -1;
    
    for j=1:numTargets
        adj(1,j+numRobots) = Distance(p1,targets(j).position);
    end
    
    for j=1:numTargets
        adj(2,j+numRobots) = Distance(p2,targets(j).position);
    end
    
end

for i=1:numTargets

    for j=i:numTargets
        adj(i+numRobots,j+numRobots) = Distance(targets(i).position, targets(j).position);
    end
    
end

%mirror to double edges for a doubly directed graph
adj = adj + adj';

end

