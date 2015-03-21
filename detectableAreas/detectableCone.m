classdef detectableCone < detectableArea
    %DETECTABLECONE - Represents a cone shape (circular sector) in front of
    %the robot with viewing angle centralAngle 
    %       and radius given
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        radius = 75;
        centralAngle = 90;
        
        xVertices;
        yVertices;
        position;
        heading;
    end
    
    methods
        function obj = detectableCone(radius, centralAngle)
            obj = obj@detectableArea();
            obj.radius = radius;
            obj.centralAngle = centralAngle;
        end
        
        function boolReturn = boolWithinArea(obj, position, heading, positionObjects)
            %generate polygon
            [X, Y] = generatePolygon(obj, position, heading);
            
            boolReturn = zeros(size(positionObjects));
            %return matrix with 1 if the object is in the cone
            for i=1:length(positionObjects)
                boolReturn(i) = inpolygon(positionObjects(i).position(1), positionObjects(i).position(2), X, Y);
            end
        end
        
        function objReturn = objWithinArea(obj, position, heading, positionObjects)
            %generate polygon
            [X, Y] = generatePolygon(obj, position, heading);
            
            in = zeros(size(positionObjects));
            %return matrix with 1 if the object is in the cone
            for i=1:length(positionObjects)
                in(i) = inpolygon(positionObjects(i).position(1), positionObjects(i).position(2), X, Y);
            end
            
            %return objects within the cone
            objReturn = positionObjects(in > 0);
        end
        
        function Draw(obj, position, heading)
            %generate the polygon then plot it
            [X, Y] = obj.generatePolygon(position, heading);
            plot(X,Y,'-');
        end
        
        function [X, Y] = generatePolygon(obj, position, heading)
            theta = obj.centralAngle/2;
            
            %convert heading vector to an angle
            angle = atan(heading(2)/heading(1));
            if heading(1) < 0, angle = angle + pi; end;
            
            %calculate angles of edges of circular sector
            angle1 = angle + theta;
            angle2 = angle - theta;
            
            %generate points along arc of circle between angles
            NOP = 20;
            THETA = linspace(angle1, angle2, NOP);
            RHO = ones(1, NOP) * obj.radius;
            [X,Y] = pol2cart(THETA, RHO);
            
            %add origin to list of points
            Y = [0 Y 0];
            X = [0 X 0];
            
            %translate all points to current position
            X=X+position(1);
            Y=Y+position(2);
        end %generatePolygon
        
    end %methods
end %classdef