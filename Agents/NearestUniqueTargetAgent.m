classdef NearestUniqueTargetAgent < Agent
    %NEARESTUNIQUETARGETAGENT Subclass of Agent - Drives to nearest target
    %within own Voronoi region, or if no targets returns to its FT point.
    %At the start, before the robot has visited any targets, it will chase
    %all targets.
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        targetsFound;
        centroid;
        numFound = 0;
    end
    
    methods
        function obj = NearestUniqueTargetAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Service_Target(obj, target)
            obj.targetsFound(obj.numFound + 1, :) = target.position;
            obj.centroid = mean(obj.targetsFound, 1);
            obj.numFound = obj.numFound + 1;
        end
        
        function obj = Update_Velocity(obj)
            global targets robots
            
            % find closest target
            minDist = 9999;
            minID = -1;
            for i=1:size(targets, 1)
                if targets(i).serviced == 0
                    if Distance(obj.position, targets(i).position) < minDist
                        minDist = Distance(obj.position, targets(i).position);
                        minID = i;
                    end
                end
            end
            
            % set direction to closest target
            if minDist ~= 9999
                %and we are the closest robot
                closest = 1;
                for i=1:size(robots, 1)
                    if Distance(robots(i).position, targets(minID).position) < minDist
                        closest = 0;
                        break
                    end
                end
            end
            if minDist ~= 9999 && (closest || obj.numFound == 0)
                vel = (targets(minID).position - obj.position);
                obj.velocity = vel/norm(vel);
                obj.velMag = 15;
            else
                %if no targets
                if obj.numFound > 0;
                    %and robot has found previous targets, move to location
                    %minimizing distance to previous target
                    %(Fermat-Torricelli point)
                    %TODO - for now just the average of the previous points
                    vel = obj.centroid - obj.position;
                    obj.velocity = vel/norm(vel);
                    if norm(vel) < 2
                        obj.velMag = 0;
                    else
                        obj.velMag = 15;
                    end
                else
                    obj.velMag = 0;
                end
            end
        end % function
        
    end % methods
    
end % class

