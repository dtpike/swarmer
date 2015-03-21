function [indices1,newAdj1,indices2,newAdj2] = SplitTree2 (adj)%#codgen
%SPLITTREE splits adjacency matrix given into two trees reacheable by each
%robot
%Assumed that the 2 robots are the first 2 rows/columns of the matrix
%INPUT
%adj - represents several minimum spanning trees in adjacency matrix form
%number of robots/trees to split off
%RETURNS a nx2 cell, with each row representing a robot, first column the
%indices of the points in the original matrix, and the second column the 
%smaller adjacency matrix of points it can reach
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%numRobots = 2;

%for each robot
index = 1;
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
    
    indices1 = indices;
    newAdj1 = newAdj;
    
index = 2;
    
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
    
    indices2 = indices;
    newAdj2 = newAdj;
    
end%function


