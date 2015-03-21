classdef NearestTargetAgent < Agent
    %NEARESTTARGETAGENT Subclass of Agent - Drives to nearest target if
    %available
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        %extra properties required by this policy to keep track of targets
        %found
        targetsFound;
        centroid;
        numFound = 0;
    end
    
    methods       
        function obj = NearestTargetAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Service_Target(obj, target)
            %when servicing target, agent saves target to properties,
            %recalculates centroid and increments numFound
            obj.targetsFound(obj.numFound + 1, :) = target.position;
            obj.centroid = mean(obj.targetsFound, 1);
            obj.numFound = obj.numFound + 1;
        end
        
        function obj = Update_Velocity(obj)
            global targets;
            
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
                    % - the centroid calculated earlier
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

