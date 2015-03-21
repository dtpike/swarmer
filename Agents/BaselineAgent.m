classdef BaselineAgent < Agent
    %BASELINEAGENT Subclass of Agent - Follows calculated tour using Rathinam method 
    % to split into tours for each vehicle. Uses optimal TSP instead or Eulerian tour. See RathinamAgent
    %no optimization of direction of tour - however
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        %no extra properties needed
    end
    
    methods
        function obj = BaselineAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Service_Target(obj, target)
            %required method of Agent - called when a target is within
            %servicing range. Finds index of given target and removes from
            %tour
            global targets numRobots
            
            %if the next target (normally the case)
            if targets(obj.tour(1) - numRobots).position == target.position
                obj.tour(1) = [];
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
                %if we still can't find it, throw an exception
                disp(target.position);
                disp(obj.position);
                throw(MException('Alan:ServiceTarget', 'Error servicing target'));
            end
                
        end
        
        function obj = Update_Velocity(obj)
            %required method of Agent - called at each time step to get a
            %new velocity
            %finds direction to next target on tour and sets as velocity
            global targets numRobots
            
            % if no more targets to visit
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

