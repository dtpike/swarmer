classdef TilingAgent < Agent
    %TILING AGENT Subclass of Agent - 
    %
    % Written by David Pike - David.Pike@rmc.ca
    % January 23, 2012
    
    %TODO-investigate speedup
    %   SenseTargets!!!
    %   TSP calculation
    
    properties
        
        C_GLOBAL;               %Global exploration points for environment
                                %TargetPoint objects with POI value 0
        C_LOCAL;                %Local exploration responsibility
                                %TargetPoint objects with POI value 0
                                
        c_string;
        
        D;                      
                                
        SENSED_TARGETS;         %Targets sensed while at exploration points
                                %To be cleared before use
        
        R_SENSE;                %Sensing radius of robot
        R_COMM;                 %Communication radius of robot

                                %through sensing (SenseTargets) or collaboration
        
        LCI = 0;                %index representing the last collaborating agent
        
    end
    
    methods
        function obj = TilingAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Service_Target(obj, UID, time)

            global targets current_targets targetsServiced
            
            try
            if ~targets(UID).serviced
            
                %Find Target index i
                targets(UID).serviced = 1;
                targets(UID).timeServiced = time;
                targets(UID).serviceTime = targets(UID).timeServiced - targets(UID).timeCreated;

                %remove target from current targets

                for i=1:size(current_targets,1)
                    if UID == current_targets(i,1).UID
                        current_targets(i) = [];
                        break;
                    end%if
                end%for

                %increase targetsServiced index
                targetsServiced = targetsServiced + 1;

            end
            catch err
                UID
                targets(UID).serviced
                output_targets = targets
                output_current_targets = current_targets
                rethrow(err);
            end%try/catch

        end%function
        
        function obj = Tour_Calculation(obj)
            %called at each time step to update robot's velocity and
            %direction
            %sets obj.TargetHeading from D and C_LOCAL
            
            % follow tour
            if ~isempty(obj.D)
                % set direction to next target
                target = obj.D(1); 
            elseif ~isempty(obj.C_LOCAL)
                target = obj.C_LOCAL(1);
            else
                %end of phase
                obj = obj.resetPhase();
                target = obj.C_LOCAL(1);
            end
            
            %Update target heading
            obj.TargetHeading = target;
   
        end % function
        
        function obj = SenseTargets(obj)
            
            %Clears SENSED_TARGETS buffer
            %calls global set 'targets' and determines which targets exist
            %within sensing radius of local agent

            global current_targets
            
            %Clear previous entries in buffer
            obj.SENSED_TARGETS = [];
            if ~isempty(current_targets)             
                obj.SENSED_TARGETS = senseTargets(obj.position,obj.R_SENSE,current_targets);
            end
            
        end%function
        
        function obj = hasArrived(obj,time)
            
            %Determine if agent has reached destination
            if Distance(obj.position,obj.TargetHeading.position) <= obj.serviceRadius
                %agent has reached destination
                if ~isempty(obj.D)%Attempting to reach target and have arrived
                    %service target
                    obj = obj.Service_Target(obj.D(1).UID,time);
                    obj.D(1) = [];

                elseif ~isempty(obj.C_LOCAL)%Attempting to reach exploration point and have arrived
                    
                    %Remove exploration point from queue
                    obj.C_LOCAL(1) = [];
                    
                    %Sense targets
                    obj = obj.SenseTargets();
                    %Add sensed targets to demand
                    obj.D = obj.SENSED_TARGETS;
                    if ~isempty(obj.D)
                        %Optimize route through current demand
                        obj.D = Rathinam1(obj.position,obj.D);
                    end
                    
                else%Attempting to reach ??? and have arrived???
                    %not possible - hopefully
                    %applicable when D and C_LOCAL are both empty
                    %have not verified the above is true
                end
            end
        end%function
        
        function obj = resetPhase(obj)
            obj.C_LOCAL = Rathinam1(obj.position,obj.C_GLOBAL);
            obj.LCI = 0;
            fprintf('\nPhase Reset for agent %d\ng=%d\n',obj.ROBOT_INDEX,obj.LCI);
            %fprintf('Resetting phase for robot %d\n',1);
        end%function
        
    end % methods
    
end % class