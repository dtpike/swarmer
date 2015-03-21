classdef RK4Agent < Agent
    %RK4AGENT - Subclass of Agent - Baseline Agent, but sets velocity and
    %turning radius in constructor
    %STILL UNDER WORK - unused
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
    end
    
    methods
        function obj = RK4Agent(agentVelocity, minTurningRadius)
            %call superclass constructor
            obj = obj@Agent(agentVelocity, minTurningRadius);
        end
        
        function obj = Service_Target(obj, target)
            global targets numRobots
            %need to find index of given target and remove from tour
            if targets(obj.tour(1) - numRobots).position == target.position
                obj.tour(1) = [];
            else
                for i=1:length(obj.tour)
                    targ = targets(obj.tour(i) - numRobots);
                    if targ.position == target.position
                        obj.tour(i) = [];
                        return
                    end
                end
                disp(target.position);
                disp(obj.position);
                throw(MException('Alan:ServiceTarget', 'Error servicing target'));
            end
                
        end
        
        function obj = Update_Velocity(obj)
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