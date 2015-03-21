function tour = BestTourDirection(tour, adj)
%BESTTOURDIRECTION - Called from CalculatePaths to optimize the direction
%of a tour
%INPUT tour - a list of indices describing a tour - first item is the robot
%      adj - an adjacency matrix representing the distances between points
%RETURNS a tour optimized in terms of direction of travel for minimum
%average service time
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

% no need to do anything if only one node
if length(tour) <= 2
    return
end

%initialize to zeros
times = zeros(1, length(tour)-1);
totalTime = 0;

%in forward direction
%times will contain distance along tour to that POI
for i=1:length(tour)-1
    totalTime = totalTime + adj(tour(i),tour(i+1));
    times(i) = totalTime;
end
averageForwardTime = sum(times)/length(times);

%in reverse direction
totalTime = adj(tour(1), tour(end));
times(1) = totalTime;
for i=length(tour)-1:-1:2
    totalTime = totalTime + adj(tour(i),tour(i+1));
    times(length(tour)-i+1) = totalTime;
end
averageBackwardTime = sum(times)/length(times);

%switch direction if necessary
%disp(['Forward: ', num2str(averageForwardTime), ' Backward: ', num2str(averageBackwardTime)]);
if averageBackwardTime < averageForwardTime
    tour = [tour(1) tour(end:-1:2)];
end
