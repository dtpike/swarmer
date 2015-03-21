function obstacles = readObstacles(filename)
%READOBSTACLES - reads obstacle positions in from a file
%INPUT optional - filename - if not specified will prompt user
%
% *.obstacle file should contain space seperated numbers. Each obstacle is
% three lines. The first line is the x vertices of the obstacle, second
% line is the y verticese of the obstacle, and the third is the face color,
% specified as a matlab rgb triple (eg. [0 0.4 0.6]
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%if no filename specified, get one from the user
if nargin == 0
    %get the filename
    [filename, pathname] = uigetfile({ '*.obstacle', 'obstacle file (*.obstacle)';}, ... 
            'Load obstacles','*.obstacle');
    %if user cancels load command, nothing happens
    if isequal(filename,0) || isequal(pathname,0)
        obstacles = []
        return
    end
    origpath = pwd;
    %move to path specified by user and load file
    cd(pathname);
    input = dlmread(filename);
    cd(origpath);
else
    assert(exist(filename, 'file') == 2);
    input = dlmread(filename);
end

%check number of rows
assert(mod(size(input, 1),3) == 0);

numObstacles = size(input, 1) / 3;
obstacles = [];

%create each obstacle
for i=1:numObstacles
    %get parameters from rows
    xVertices = input((i-1)*3 + 1,:);
    yVertices = input((i-1)*3 + 2,:);
    faceColor = input((i-1)*3 + 3,:);
    
    %remove trailing zeros
    xVertices(find(xVertices, 1, 'last')+1:end) = [];
    yVertices(find(yVertices, 1, 'last')+1:end) = [];
    faceColor(4:end) = [];
    
    %check validity
    if length(xVertices) ~= length(yVertices)
        uiwait(msgbox('Error in obstacle file - number of vertices mismatched', 'ERROR'));
        obstacles = [];
        return
    elseif length(faceColor) ~= 3
        uiwait(msgbox('Error in obstacle file - face color should be three numbers specifying an rgb color', 'ERROR'));
        obstacles = [];
        return
    end
    
    %double last point
    if xVertices(1) ~= xVertices(end) || yVertices(1) ~= yVertices(end)
        xVertices(end + 1) = xVertices(1);
        yVertices(end + 1) = yVertices(1);
    end
    
    %create obstacle
    obstacles = [obstacles; Obstacle(xVertices, yVertices, faceColor)];
end
