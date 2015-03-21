classdef RathinamAgent < Agent
    %RATHINAMAGENT Subclass of Agent - Follows calculated tour as described
    %by Rathinam - CalculateTour. Uses Eulerian walk not exact TSP as in
    %BaselineAgent
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        %no extra properties needed
    end
    
    methods
        function obj = RathinamAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Service_Target(obj, target)
            %called when this robot is servicing a target
            %need to remove target from tour
            
            global targets numRobots
            
            %need to find index of given target and remove from tour
            if targets(obj.tour(1) - numRobots).position == target.position
                obj.tour(1) = [];
            else
                %in case target visited is not the next one in the tour
                %(accidentally driving by a different point)
                for i=1:length(obj.tour)
                    targ = targets(obj.tour(i) - numRobots);
                    if targ.position == target.position
                        obj.tour(i) = [];
                        return
                    end
                end
                %if we can't find the target
                disp(target.position);
                disp(obj.position);
                throw(MException('Alan:ServiceTarget', 'Error servicing target'));
            end
                
        end
        
        function obj = Update_Velocity(obj)
            %called at each time step to update robot's velocity and
            %direction
            global targets numRobots
            
            % follow tour
            if isempty(obj.tour)
                obj.velMag = 0;
            else
                % set direction to next target
                nextTarget = obj.tour(1);
                target = targets(nextTarget - numRobots);
                vel = target.position - obj.position;
                obj.velocity = vel/norm(vel);
                obj.velMag = obj.agentVelocity;
            end
        end % function
        
    end % methods
    
end % class

