function minIndices = ConstructExactTour(cell, adj)
%CONSTRUCTEXACTTOUR Simply brute forces all permutations. Works well to 9
%nodes, slow on 10 nodes, and crashes on 11 nodes (including start)
%
%INPUT a 1x2 cell containing a vector mapping indices from given adjacency
%matrix to full complete adjacency matrix,
%and the adjacency matrix for this walk
%RETURNS a vector of indices in the main adjacency matrix representing the
%tour
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%pull out elements of cell
indices = cell{1};
adj2 = cell{2};

%exact brute force method

%get permutations
walks = perms(indices);

%find minimum walk
min=Inf;
minIndices = [];

for i=1:size(walks,1)
    dist = 0;
    for j=1:size(walks,2)-1
        dist = dist + adj(walks(i,j),walks(i,j+1));
    end
    dist = dist + adj(walks(i,j+1),walks(i,1));
    if dist < min
        min = dist;
        minIndices = walks(i,:);
    end
end
