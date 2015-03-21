function dist = Distance (a, b)%#codegen
%DISTANCE Returns standard Euclidean norm
%INPUT a,b should be 1x2 or 2x1 vectors representing points in the plane
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

dist = sqrt((a(1) - b(1))^2 + (a(2) - b(2))^2);
end

