function tour = ConstructOptimumTour(cell, adj)
%CONSTRUCTOPTIMUMTOUR Constructs an optimum tour using an algorithm from
%Held and Karp 1962.
%
%INPUT cell - a 1x2 cell containing a vector mapping indices from given adjacency
%matrix to full complete adjacency matrix,
%  adj - the adjacency matrix for this walk
%RETURNS a vector of indices in the main adjacency matrix representing the
%tour
%checks for stop button being pressed
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%pull out elements of cell
indices = cell{1};
adj2 = cell{2};
tour = [];

%warns user if it might take awhile
if (length(indices) >= 10)
    disp([int2str(length(indices)), ' nodes to plan']);
    disp(['Will take approx. ', num2str(0.000010*(2^length(indices))*(length(indices)^2)), ' seconds to calculate']);
    tic;
end

start = indices(1);
indices(1) = [];

%opt(S; i) - the length of the shortest path starting at start, visiting
%all cities in S-{i} in arbitrary order, and stopping in city i
%Stored as key 's1 s2 s3;i'
opt = containers.Map;

%set opt[{i};i] to d(1,i)
for i=1:length(indices)
    opt([array2str(indices(i)),';',array2str(indices(i))]) = adj(start, indices(i));
end

%for subsets of increasing size, add to opt
%opt[S;i] = min{ opt[S-{i};j] + d(j,i) : j in S-{i} }
for setSize = 2:length(indices)
    subsets = combnk(indices, setSize);
    %for each subset
    for subInd=1:size(subsets,1)
        %let gui update and check if stop button was pressed -
        %unfortunately this takes awhile to check - TODO: could do with a faster way
        drawnow;
        %handles = guidata(gcbo);
        %if handles.stop == 1
        %    disp('Stop');
        %    return
        %end
        
        subset = subsets(subInd,:);
        subsetStr = array2str(subset);
        %for each i
        for i=1:length(subset)
            %find min
            min = Inf;
            
            %construct S - {i}
            sMinI = subset;
            sMinI(sMinI==subset(i))=[];
            sMinIstr = array2str(sMinI);
            
            %for each j in S - i
            for j=1:length(sMinI)
                %opt[S-i;j] + d(j,i)
                dist = opt([sMinIstr,';',sprintf('%d', sMinI(j))]) + adj(sMinI(j),subset(i));
                if dist < min
                    min = dist;
                    %minInd = sMinI(j);
                end
            end
            
            %store min in opt
            %disp([array2str(subset),';',array2str(subset(i))]);
            opt([subsetStr,';',array2str(subset(i))]) = min;
        end
    end
end

%find minimum distance
min = Inf;
minInd = 0;
for j=1:length(indices)
    strng = [array2str(indices),';',array2str(indices(j))];
    dist = opt(strng) + adj(indices(j),start);
    if dist < min
        min = dist;
        minInd = indices(j);
    end
end

if min == Inf
    disp(['Single point has tour length 0']);
    tour = start;
    return;
end

%display tour length details in console
tourLength = min;
disp(['Minimum length is: ', num2str(tourLength)]);
disp(['ending at point ', array2str(minInd)]);
disp(' ');

%work backwards to find actual tour
tour = [start minInd];
indices(indices==minInd) = [];
last = minInd;
while indices
    min = Inf;
    for i = 1:length(indices)
        dist = opt([array2str(indices),';',array2str(indices(i))]) + adj(indices(i), last);
        if dist < min
            min = dist;
            minInd = indices(i);
        end
    end
    indices(indices==minInd) = [];
    tour = [tour minInd];
    last = minInd;
end

% display timing for complex tours
if (length(cell{1}) >= 10)
    toc;
end