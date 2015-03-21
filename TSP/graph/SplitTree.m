function trees = SplitTree (adj, numRobots)
%SPLITTREE splits adjacency matrix given into trees reacheable by each
%robot
%Assumed that the n robots are the first n rows/columns of the matrix
%INPUT
%adj - represents several minimum spanning trees in adjacency matrix form
%number of robots/trees to split off
%RETURNS a nx2 cell, with each row representing a robot, first column the
%indices of the points in the original matrix, and the second column the 
%smaller adjacency matrix of points it can reach
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

trees = {};

%for each robot
for index=1:numRobots
    %find all the indices of points it can reach
    indices = index;
    next = find(adj(index,:));
    indices = [indices next];
    while next
        children = find(adj(next(1),:));
        children = children(~ismember(children, indices));
        next = [next children];
        indices = [indices children];
        next(1) = [];
    end
    indices = unique(indices);

    %now make new adjacency matrix
    newAdj = adj(indices, indices);
    
    trees{index,1} = indices;
    trees{index,2} = newAdj;
end


