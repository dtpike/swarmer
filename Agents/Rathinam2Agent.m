classdef Rathinam2Agent < Agent
    %LOCAL AGENT Subclass of Agent - 
    %
    % Written by David Pike - David.Pike@rmc.ca
    % September 16, 2011
    
    properties

        D;                      %Local demand
        D_HAT;
        D_received;             %Demand received from neighbours
        LOCAL_DEMAND;           %Local demand
        D_GLOBAL;               %Local realization of global demand
        D_EXTERNAL;
        D_INTERNAL;             %
        
        B;                      %Targets serviced
        B_INDEX;                %Array of indices serviced
        SERVICED_INDICES = [];
        
        SENSED_TARGETS;         %Targets picked up within R_SENSE
        RECEIVED_TARGETS;       %Targets received through collaboration
                                %To be consolidated with D and B after
                                %every timestep then cleared
        
        R_SENSE;                %Sensing radius of robot
        R_COMM;                 %Communication radius of robot
        FLAG_NEW_INFO = 1;      %Flag indicating new information was received 
                                %through sensing (SenseTargets) or collaboration
    end
    
    methods
        function obj = Rathinam2Agent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = SenseTargets(obj)

            global targets
            %Check if any global targets are within R_SENSE of agent
            %fprintf('Checking %d global targets\n',size(targets,1));
            
            for i=1:size(targets,1);%iterate through targets
                
                %Check if target position is within R_SENSE
                if (Distance(targets(i).position,obj.position) <= obj.R_SENSE && targets(i).serviced == 0);
                    
                    obj.D = addTarget(obj.D,targets(i),obj.ROBOT_INDEX);

                end %if
            end %for
            
        end%function
        
        function obj = TourCalculation(obj)
            
            %Local tour calculation module
            %For Rathinam2 agent, continue on D
            
            
        end
        
        function obj = Service_Target(obj, target)

            global targets
            
            %Check to ensure target has not already been serviced
            CURRENT_UID = target.UID;
            current_target = findTargetFromUID(targets,CURRENT_UID);
            
            
            %Verify target being serviced is first one in LOCAL_DEMAND
            if CURRENT_UID == obj.D(1).UID
                %current_target = findTargetFromUID(targets,CURRENT_UID);
                fprintf('Robot %d servicing target %d\n',obj.ROBOT_INDEX,CURRENT_UID);
                
                if (current_target.serviced == 0);
                    
                    %Add target to B
                    obj.B = [obj.B; obj.D(1)];
                    obj.SERVICED_INDICES = [obj.SERVICED_INDICES; obj.D(1).UID];    
                    
                    %Remove target from local demand
                    obj.D(1) = [];
                
                else%otherwise????
                    obj.D(1) = [];
                    %wtf, why did you send me here?
                end
                
            else%target being serviced is not that of current tour, accidently landed here?????
                %Need to find entry for current target being serviced
            end%if
        end%function
        
        function obj = Update_Velocity(obj)
            %called at each time step to update robot's velocity and
            %direction
            %Check to ensure next target isn't being serviced faster
%             while (obj.D(1).EXPECTED_SERVICE_TIME < obj.D(1).LOCAL_SERVICE_TIME && ~isempty(obj.D))
%                 obj.D(1) = [];
%             end
            
            % follow tour
            if isempty(obj.D)
                obj.velMag = 0;
                %Exploration maneuver
                %fprintf('Local demand empty for robot %d\n',obj.ROBOT_INDEX);
                
            else
                
                % set direction to next target
                %fprintf('Robot %d moving towards target %d\n',obj.ROBOT_INDEX,obj.LOCAL_DEMAND(1).UID);
                %Check if target's expeceted service time?!?!?!?!?!?!
                
                target = obj.D(1);
                vel = target.position - obj.position;
                obj.velocity = vel/norm(vel);
                obj.velMag = obj.agentVelocity;
            end
        end % function
        
        function obj = OptimizeTour(obj)
            
            %Optimize tour of local known demand - for now Christofides
            %algorithm
            if (size(obj.D,1) > 1 && size(obj.D,2 > 0))
                size_demand = size(obj.D,1);
                obj.D = Rathinam1(obj,obj.D);
                size_demand2 = size(obj.D,1);
                
                if size_demand ~= size_demand2
                    fprintf('Warning: OptimizeTour adding targets to robot %d\n',obj.ROBOT_INDEX);
                end
            end
            
        end %function
        

        
        function obj = hasArrived(obj)
            
            global targets
            
            if isempty(obj.LOCAL_DEMAND)
                %no destination
            else
                %Check whether agent is within service radius of desired target
                if Distance(obj.position,obj.LOCAL_DEMAND(1).position) <= obj.LOCAL_DEMAND(1).serviceRadius
                    %Has target been serviced?
                    if targets(obj.LOCAL_DEMAND(1).UID).serviced == 1
                        %Remove from local demand
                        obj.LOCAL_DEMAND(1) = [];
                    else
                        %service target???? should have been done in
                        %CheckTargetRadius
                        throw(MException('LocalAgent:hasArrived','hasArrived function error'));
                    end
                end
            end
            
        end%function
        
        function obj = UpdateRoutingTable(obj,time)
            
            time_holder = time;
            position_holder = obj.position;

            obj.D_INTERNAL = [];
            obj.D_EXTERNAL = [];
            
            %Verify demand is not empty
            if ~(size(obj.D,2) == 0)
                %Calculate local expected service times
                for i=1:size(obj.D,1)
                    distance = Distance(position_holder,obj.D(i).position);
                    obj.D(i).LOCAL_SERVICE_TIME = time_holder + distance/obj.velMag;
                    
                    %Check whether EXPECTED_SERVICE_TIME is closer than LOCAL_SERVICE_TIME
                    if obj.D(i).LOCAL_SERVICE_TIME < obj.D(i).EXPECTED_SERVICE_TIME
                        %target can be serviced fastest locally, 
                        %add to D_INTERNAL
                        obj.D(i).EXPECTED_SERVICE_TIME = obj.D(i).LOCAL_SERVICE_TIME;
                        obj.D_INTERNAL = [obj.D_INTERNAL; obj.D(i)];
                        time_holder = obj.D(i).EXPECTED_SERVICE_TIME;
                        position_holder = obj.D(i).position;

                    else
                        %target can be serviced faster externally
                        %add to D_EXTERNAL
                        obj.D_EXTERNAL = [obj.D_EXTERNAL; obj.D(i)];
                    end
    
                end%for
                

                %Update routing table
                if ~isempty(obj.D_INTERNAL)
                    %Rathinam tour
                    obj.D_INTERNAL = Rathinam1(obj,obj.D_INTERNAL);
                    time_holder = time;
                    position_holder = obj.position;
                    for i=size(obj.D_INTERNAL,1)
                        distance = Distance(position_holder,obj.D_INTERNAL(i).position);
                        obj.D_INTERNAL(i).EXPECTED_SERVICE_TIME = time_holder + distance/obj.velMag;
                        time_holder = obj.D_INTERNAL(i).EXPECTED_SERVICE_TIME;
                        position_holder = obj.D_INTERNAL(i).position;
                    end
                end
                obj.D = [obj.D_INTERNAL; obj.D_EXTERNAL];
            end
            
            
        end%function
        
        function obj = truncateDemands(obj)
            for i=1:size(obj.RECEIVED_TARGETS)
                if obj.RECEIVED_TARGETS(i).serviced == 1
                    %Add to B
                    obj.B = addTarget(obj.B,obj.RECEIVED_TARGETS(i).obj.ROBOT_INDEX);
                else
                    obj.D = addTarget(obj.D,obj.RECEIVED_TARGETS(i),obj.ROBOT_INDEX);
                end
            end
            obj.RECEIVED_TARGETS = [];
        end%function
        
            
    end % methods
    
end % class