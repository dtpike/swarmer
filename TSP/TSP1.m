function tour = TSP1(x_pos,y_pos,targets)%#codegen
%targets: nx2 matrix of target locations

%preallocate memory for adj
%NOTE: 1-vehicle
adj = zeros(1 + size(targets,1));

%NOTE: 1-vehicle
positions = [x_pos y_pos; targets];

%Construct adjacency matrix
%TODO: add robots into adjacency matrix
for i=1:size(positions,1)
    for j=i+1:size(positions,1)
        cost = Distance(positions(i,:),positions(j,:));
        adj(i,j) = cost;
        adj(j,i) = cost;
    end
end

%Find minimum spanning tree using Prim's algorithm
tree = Prim(adj)

[odd_adj,odd_vertices] = findOddDegreeVerticesFromTree(tree,adj);

indices = min_perfect_matching(odd_adj);

%Construct multigraph




tree = tree*2

%positions

%plot TSP tours
clf;
hold on;
gplot(tree,positions)
scatter(positions(2:end,1),positions(2:end,2));
scatter(positions(1,1),positions(1,2),'filled');
hold off;


adj2(tree == 0) = 0;

%1-vehicle
indices = 1:size(positions,1);%sets indices for 'ConstructTour' which the vehicle is responsible for
tour = ConstructTour(indices,tree);


end

function A = Prim(C1)
%
% Find the minimum spanning tree using Prim's algorithm.
% C1(i,j) is the primary cost of connecting i to j.
% C2(i,j) is the (optional) secondary cost of connecting i to j, used to break ties.
% We assume that absent edges have 0 cost.
% To find the maximum spanning tree, used -1*C.
% See Aho, Hopcroft & Ullman 1983, "Data structures and algorithms", p 237.

% Prim's is O(V^2). Kruskal's algorithm is O(E log E) and hence is more efficient
% for sparse graphs, but is implemented in terms of a priority queue.

% We partition the nodes into those in U and those not in U.
% closest(i) is the vertex in U that is closest to i in V-U.
% lowcost(i) is the cost of the edge (i, closest(i)), or infinity is i has been used.
% In Aho, they say C(i,j) should be "some appropriate large value" if the edge is missing.
% We set it to infinity.
% However, since lowcost is initialized from C, we must distinguish absent edges from used nodes.

n = length(C1);
C2 = zeros(n);
A = zeros(n);

closest = ones(1,n);
used = zeros(1,n); % contains the members of U
used(1) = 1; % start with node 1
C1(C1==0)=inf;
C2(C2==0)=inf;
lowcost1 = C1(1,:);
lowcost2 = C2(1,:);

for i=2:n
  ks = find(lowcost1==min(lowcost1));
  k = ks(argmin(lowcost2(ks)));
  A(k, closest(k)) = 1;
  A(closest(k), k) = 1;
  lowcost1(k) = inf;
  lowcost2(k) = inf;
  used(k) = 1;
  NU = find(used==0);
  for ji=1:length(NU)
    for j=NU(ji)
      if C1(k,j) < lowcost1(j)
    	lowcost1(j) = C1(k,j);
        lowcost2(j) = C2(k,j);
        closest(j) = k;
      end
    end
  end
end

end

function dist = Distance (a, b)
%DISTANCE Returns standard Euclidean norm
%INPUT a,b should be 1x2 or 2x1 vectors representing points in the plane
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

dist = sqrt((a(1) - b(1))^2 + (a(2) - b(2))^2);
end

function indices = argmin(v)
% ARGMIN Return as a subscript vector the location of the smallest element of a multidimensional array v.
% indices = argmin(v)
%
% Returns the first minimum in the case of ties.
% Example:
% X = [2 8 4; 7 3 9];
% argmin(X) = [1 1], i.e., row 1 column 1

[m i] = min(v(:));
indices = ind2subv(mysize(v), i);
%indices = ind2subv(size(v), i);

end

function sub = ind2subv(siz, ndx)
% IND2SUBV Like the built-in ind2sub, but returns the answer as a row vector.
% sub = ind2subv(siz, ndx)
%
% siz and ndx can be row or column vectors.
% sub will be of size length(ndx) * length(siz).
%
% Example
% ind2subv([2 2 2], 1:8) returns
%  [1 1 1
%   2 1 1
%   ...
%   2 2 2]
% That is, the leftmost digit toggle fastest.
%
% See also SUBV2IND

n = length(siz);

if n==0
  sub = ndx;
  return;
end  

if all(siz==2)
  sub = dec2bitv(ndx-1, n);
  sub = sub(:,n:-1:1)+1;
  return;
end

cp = [1 cumprod(siz(:)')];
ndx = ndx(:) - 1;
sub = zeros(length(ndx), n);
for i = n:-1:1 % i'th digit
  sub(:,i) = floor(ndx/cp(i))+1;
  ndx = rem(ndx,cp(i));
end

end


function bits = dec2bitv(d,n)
% DEC2BITV Convert a decimal integer to a bit vector.
% bits = dec2bitv(d,n) is just like the built-in dec2bin, except the answer is a vector, not a string.
% n is an optional minimum length on the bit vector.
% If d is a vector,  each row of the output array will be a bit vector.


if (nargin<2)
  n=1; % Need at least one digit even for 0.
end
d = d(:);

[f,e]=log2(max(d)); % How many digits do we need to represent the numbers?
bits=rem(floor(d*pow2(1-max(n,e):0)),2);

end

function sz = mysize(M)
% MYSIZE Like the built-in size, except it returns n if M is a vector of length n, and 1 if M is a scalar.
% sz = mysize(M)
% 
% The behavior is best explained by examples
% - M = rand(1,1),   mysize(M) = 1,      size(M) = [1 1]
% - M = rand(2,1),   mysize(M) = 2,      size(M) = [2 1]
% - M = rand(1,2),   mysize(M) = 2,      size(M) = [1 2]
% - M = rand(2,2,1), mysize(M) = [2 2],  size(M) = [2 2]
% - M = rand(1,2,1), mysize(M) = 2,      size(M) = [1 2]

if isvector(M)
  sz = length(M);
else
  sz = size(M);
end

end%function

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

%ENSURE: adj matrix consists of more than 2 elements
    
%adj(row, col) indicates an edge from node row to node col


%GIVEN: - node index in the adjacency matrix, 
%       - adjacency matrix with links removed,
%    

%Find links for a given node and adjacency matrix
[walk,adj] = findLinks(nodeIndex,adj);

%Run Euler
%For each adjacent node, determine the number of links to each and explore
%them (recursion)

out = [];
for i=1:length(walk)-1
    [walk2 adj] = Euler(walk(i), adj);
    out = [out walk2];
end

%append starting position to end of tour
walk = [out nodeIndex];

end%function

function [walk,adj] = findLinks(nodeIndex,adj)

walk = nodeIndex;
node = walk;

while ~(isempty(find(adj(nodeIndex, :), 1)) && node == nodeIndex)%if there is a non-zero entry in adj(nodeIndex,:) && node != nodeIndex
    %pick a neighbor of node with an edge and
    next = find(adj(node, :), 1);
    adj(node, next) = 0;
    node = next;
    walk = [walk node];
end

end

function tour = ConstructTour(indices,adj)
%CONSTRUCTTOUR constructs a eulerian walk, then tour of the minimum 
%spanning tree given
%similar to pp.414 in Combinatorial Optimization: Algorithms and
%Complexity
%INPUT a 1x2 cell containing a vector mapping indices from given adjacency
%matrix to full complete adjacency matrix,
%and the adjacency matrix for this walk
%RETURNS a vector of indices in the main adjacency matrix representing the
%eulerian walk
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%get Eulerian walk
walk = Euler(1,adj);
tour = [];

%visit each node only once - turn walk into tour
for i=1:size(walk,2)
    if isempty(find(tour == walk(i), 1))
        tour = [tour walk(i)];
    end
end

%convert indices to represent those in full adjacency matrix
for i=1:length(tour)
    tour(i) = indices(tour(i));
end

end%function

function [indices,newAdj] = SplitTree (adj, numRobots)
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
    
end

end%function
