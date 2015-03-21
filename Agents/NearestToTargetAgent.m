classdef NearestToTargetAgent < Agent
    %NEARESTTOTARGETAGENT Subclass of Agent - Follows calculated tour using a new method 
    % to split into tours for each vehicle. Each target is assigned to its 
    % closest agent. Uses optimal TSP after to determine tour.
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        %no extra properties needed
    end
    
    methods
        function obj = NearestToTargetAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Service_Target(obj, target)
            %required method of Agent - called when a target is within
            %servicing range. Finds index of given target and removes from
            %tour
            global targets numRobots robots
            
            %if the next target (normally the case)
            if ~isempty(obj.tour)
                if targets(obj.tour(1) - numRobots).position == target.position
                    obj.tour(1) = [];
                end
            %if not the next target (accidentally serviced while moving to
            %a different target), then find out which target it is
            else
                for i=1:length(obj.tour)
                    targ = targets(obj.tour(i) - numRobots);
                    if targ.position == target.position
                        obj.tour(i) = [];
                        return
                    end
                end
                %if we still can't find it, try out of all available
                %targets
                for i=1:length(targets)
                    if targets(i).position == target.position
                        %then this target needs to be removed from
                        %whichever's robot's tour it is in
                        index = i + numRobots;
                        for j=1:numRobots
                            if sum(ismember(robots(j).tour, index))
                                robots(j).tour(ismember(robots(j).tour, index)) = [];
                                return;
                            end
                        end
                        %return anyway in case it wasn't in a tour (for
                        %target generation)
                        return;                        
                    end
                end                
                %and if we still can't find it, throw an exception
                disp(target.position);
                disp(obj.position);
                throw(MException('Alan:ServiceTarget', 'Error servicing target'));
            end
                
        end
        
        function obj = Update_Velocity(obj)
            %required method of Agent - called at each time step to get a
            %new velocity
            %finds direction to next target on tour and sets as velocity or
            %if none left in tour, moves to closest
            global targets numRobots
            
            % if no more targets to visit
            if isempty(obj.tour)
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
                end
            else
                % set direction to next target in tour
                nextTarget = obj.tour(1);
                target = targets(nextTarget - numRobots);
                vel = target.position - obj.position;
                obj.velocity = vel/norm(vel);
                obj.velMag = obj.agentVelocity;
            end
        end % function
        
    end % methods
    
end % class

