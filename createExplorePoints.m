function handles = createExplorePoints(handles)

C = constructExplorePointsFromRectEnv(handles);

%Calculate size of C
%d = size(C,1);
ret = [];

for i=1:size(C,1)
    new = NewPoint(i,C(i,:),handles.serviceRadius);
    ret = [ret; new];
end

handles.C_GLOBAL = ret;

end%function



function [C] = constructExplorePointsFromRectEnv(handles)

%Find bottom left corner
x = -handles.areaSize/2;
y = -handles.areaSize/2;

sigma = handles.R_SENSE;

%Find first point in exploration set
x = x + sigma/sqrt(2);
y = y + sigma/sqrt(2);

%Find n
%Number of squares in a length (assume square environment)
n = ceil(handles.areaSize/(sqrt(2)*sigma));

%fprintf('Environment should contain roughtly %d exploration points\n',n*n);

x_b = handles.areaSize/2;
y_b = handles.areaSize/2;

%Loop
%moves in x direction

%Assign first length
[C,x,y] = assignLength(x,y,handles.areaSize/2,1,sigma);

%initialization
pol = -1;

while abs(x - x_b) > sigma/sqrt(2)
    if abs(x - x_b) <= sqrt(2)*sigma
        %fprintf('Approaching x boundary(x=%0.2f, y=%0.2f)\n',x,y);
        %new length along x border
        x = x_b;
    else%if not, standard length assignment
        x = x + sqrt(2)*sigma;
    end
    
    %create length
    [length,x,y] = assignLength(x,y,y_b,pol,sigma);
    
    %add lengeth to C
    C = [C; length];
    
    %Switch polarity
    pol = -1*pol;
    
end%finished populating C

end%function

function [length,x,y] = assignLength(x_start,y_start,Y_BOUND,pol,sigma)

%fprintf('Starting length at (x = %02f,y=%0.2f) with polarity %d\n',x_start,y_start,pol);

x = x_start;
y = y_start;

%Assume symmetric environment
y_b = Y_BOUND*pol;

%l_lower = 
%l_upper

%create initial point in C

length(1,:) = [x,y];

while abs(y - y_b)> sigma/sqrt(2)
    %Check if y is between sigma/sqrt(2) and sqrt(2)*sigma
    if abs(y - y_b) <= sqrt(2)*sigma
        %fprintf('Approaching y boundary(x=%0.2f, y=%0.2f)\n',x,y);
        %Place next y at the boundary
        y = y_b;
    else% if not, standard assignment
        y = y + pol*sqrt(2)*sigma;
    end
    
    %add to C
    length = [length; x,y];   %change C values to object values
    
end%end of length


end%function