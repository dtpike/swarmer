classdef Obstacle
    %Obstacle Class defining an obstacle
    % Defines vertices and colors of the obstacle. Methods provided to plot
    % obstacle, and to check if a point or line is inside or crosses the
    % obstacle.
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010

    properties
        xVertices = [0];    % 
        yVertices = [0];    % 
        faceColor = 'Red';
        edgeColor = 'Black';
    end
    
    methods
        function obj = Obstacle(xVertices, yVertices, color) %constructor
            if nargin > 0
                % sets timeCreated
                obj.xVertices = xVertices;
                obj.yVertices = yVertices;
                obj.faceColor = color;
            end
        end
        
        function Draw(obj) 
            %draw obstacle
            patch(obj.xVertices, obj.yVertices, 'Red', ...
                'FaceColor', obj.faceColor, 'EdgeColor', obj.edgeColor);
        end
        
        function in = inObstacle(obj, xpoints, ypoints)
            %return matrix with 1 if that point is in the polygon
            % 0 otherwise
            if length(obj) > 1
                in = inpolygon(xpoints, ypoints, obj(1).xVertices, obj(1).yVertices);
                for i=2:length(obj)
                    in = in | inpolygon(xpoints, ypoints, obj(i).xVertices, obj(i).yVertices);
                end
            else
                in = inpolygon(xpoints, ypoints, obj.xVertices, obj.yVertices);
            end
        end
        
        function [retrn targetPosition] = throughObstacle(obj, currentPosition, targetPosition)
            %return vel as the vector from currentPosition to
            %targetPosition, or around an obstacle if there is one in the
            %way
            
            global areaSize
            
            %using while loop to be able to restart loop
            disp('enter through obstacle');
            i = 1;
            stuck = 0;
            while i<=length(obj)
                %loop through each obstacle and check for intersection
                x2 = [currentPosition(1); targetPosition(1)];
                y2 = [currentPosition(2); targetPosition(2)];
                [x0,y0] = intersections(obj(i).xVertices, obj(i).yVertices, x2, y2);
                if ~isempty(x0) || ~isempty(y0)
                    disp('Need to find new path round obstacle');
                    alt = 1;
                    vert = 1;
                    while ~isempty(x0) || ~isempty(y0)
                        targPos = targetPosition;
                        targPos(vert) = targetPosition(vert) + alt*1;
                        x2 = [currentPosition(1); targPos(1)];
                        y2 = [currentPosition(2); targPos(2)];
                        [x0,y0] = intersections(obj(i).xVertices, obj(i).yVertices, x2, y2);
                        if vert == 1
                            alt = -sign(alt) * (abs(alt) + 1);
                        end
                        if ~stuck
                            vert = mod(vert,2) + 1;
                        else
                            disp('stuck');
                            if stuck > length(obj) + 1
                                disp([num2str(currentPosition), ' - ', num2str(targetPosition)]);
                                targPos = rand(1, 2)*areaSize - areaSize/2;
                                %throw(MException('Alan:Obstacle', 'Error finding new targetPosition'));
                            end
                        end
                    end
                    targetPosition = targPos;
                    i = 0;
                    stuck = stuck + 1;
                end
                i = i+1;
            end
            retrn = targetPosition - currentPosition;
            disp('exit through obstacle');
        end %function
        
    end % end methods
    
end %end class

