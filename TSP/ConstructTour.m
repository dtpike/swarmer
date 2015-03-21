function tour = ConstructTour(cell)
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

%pull out elements of cell
indices = cell{1};
adj = cell{2};

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