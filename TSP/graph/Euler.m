function [walk, adj] = Euler(nodeIndex, adj)
%EULER constructs a eulerian walk from a given adjacency matrix
%recursively calls itself to create a eulerian walk from nodeIndex using
%the adjacency matrix given
%Uses the cycle finding algorithm
%(http://www.algorithmist.com/index.php/Euler_tour), easier than Fleury's
%to implement
%RETURNS a walk, multiple points will be visisted, and will need to be
%simplified
%also returns the adjacency matrix with visted points removed
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%if only one point return it
if find(adj(nodeIndex, :), 1) == -1
    walk = nodeIndex;
    return
end
    
%adj(row, col) indicates an edge from node row to node col
walk = nodeIndex;
node = walk;
while ~(isempty(find(adj(nodeIndex, :), 1)) && node == nodeIndex)
    %pick a neighbor of node with an edge and
    next = find(adj(node, :), 1);
    adj(node, next) = 0;
    node = next;
    walk = [walk node];
end

out = [];
for i=1:length(walk)-1
    [walk2 adj] = Euler(walk(i), adj);
    out = [out walk2];
end
walk = [out nodeIndex];

