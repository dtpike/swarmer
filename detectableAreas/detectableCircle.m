classdef detectableCircle < detectableArea
    %DETECTABLECIRCLE - Represents a circle around the robot of radius
    %detectRadiius
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        detectRadius = 75;
    end
    
    methods
        function obj = detectableCircle(radius)
            obj = obj@detectableArea();
            obj.detectRadius = radius;
        end
        
        function boolReturn = boolWithinArea(obj, position, ~, positionObjects)
            %return 1 for objects within radius
            for i=1:length(positionObjects)
                dists(i) = Distance(positionObjects(i).position, position);
            end
            boolReturn = dists < obj.detectRadius;
        end
        
        function objReturn = objWithinArea(obj, position, ~, positionObjects)
            %return objects within radius
            for i=1:length(positionObjects)
                dists(i) = Distance(positionObjects(i).position, position);
            end
            objReturn = positionObjects(dists < obj.detectRadius);
        end
        
        function Draw(obj, position, ~)
            %draw circle around robot with radius given and consisting of
            %35 points
            circle(position, obj.detectRadius, 35, '-');
        end
        
    end %methods
end %classdef