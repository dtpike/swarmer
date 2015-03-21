function PlotVoronoi(robots)
%PLOTVORONOI - Plots voronoi regions, given positions of robots.
%INPUT array of agents
% Will only display if 3 or more robots
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%Check there are enough robots - need at least 3
if size(robots,1) <= 2
    return
end

%make matrix of robots positions
posn = [];
for i=1:size(robots,1)
    posn = [posn ; robots(i).position];
end

%calculate and plot Voronoi regions
[vx, vy] = voronoi(posn(:,1), posn(:,2));
plot(vx,vy,'b-');
