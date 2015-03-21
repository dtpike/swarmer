classdef ModifiedBaselineAgent < Agent
    %MODIFIEDBASELINEAGENT Subclass of Agent - Follows calculated tour using Rathinam method 
    % to split into tours for each vehicle. Uses optimal TSP instead of
    % Eulerian tour. Optimizes for direction of tour.
    %Same code as SmartBaselineAgent, but draws sensing radius around
    %robot.
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        newDirection = [0 0];       %point the robot is aiming for
    end
    
    methods       
        function obj = ModifiedBaselineAgent()
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
            global targets numRobots obstacles areaSize
            
            localTargets = targets([targets.serviced] == 0);
            localTargets = obj.detectArea.objWithinArea(obj.position, obj.velocity, localTargets);
            
            %if no direction set - ie simulation just started
            %TODO: move to setup figure
            if obj.newDirection == [0 0];
                obj.newDirection = rand(1, 2)*areaSize - areaSize/2;
                newDirectionBool = 1;
            end
            
            % if localTargets
            if size(localTargets, 1) > 0
                % find closest target
                minDist = 9999;
                minID = -1;
                for i=1:size(localTargets, 1)
                    if localTargets(i).serviced == 0
                        if Distance(obj.position, localTargets(i).position) < minDist
                            minDist = Distance(obj.position, localTargets(i).position);
                            minID = i;
                        end
                    end
                end

                % set direction to closest target
                if minDist ~= 9999
                    obj.newDirection = localTargets(minID).position;
                    newDirectionBool = 1; %marker to show newDirection has been set
                end
            else
                % continue in random direction until edge of map reached
                if abs(obj.position(1)) > areaSize/2 || abs(obj.position(2)) > areaSize/2
                    obj.newDirection = rand(1, 2)*areaSize - areaSize/2;
                    newDirectionBool = 1;
                    disp(['New direction:', num2str(obj.newDirection)]);
                end
                if Distance(obj.position, obj.newDirection) < 10 %obj.detectRadius
                    obj.newDirection = rand(1, 2)*areaSize - areaSize/2;
                    newDirectionBool = 1;
                    disp(['New direction:', num2str(obj.newDirection)]);
                end
            end
            %set direction
            if exist('newDirectionBool', 'var')
                %check if path is through an obstacle
                [vel obj.newDirection] = obstacles.throughObstacle(obj.position, obj.newDirection);
                %vel = obj.newDirection - obj.position;
                obj.velocity = vel/norm(vel);
                obj.velMag = obj.agentVelocity;
            end
        end % function
        
        function Draw(obj, h, b)
            %DRAW Draws the agent as a triangle with height h and width b
            DrawTriangle(obj.position, obj.velocity, h, b, 'k');
            plot(obj.newDirection(1), obj.newDirection(2), 'go');
        end
        
    end % methods
    
end % class

