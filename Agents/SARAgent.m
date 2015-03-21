classdef SARAgent < TilingAgent
    
    %Search and Rescue Agent: subclass of tiling agent
    %
    %Written by David Pike - David.Pike@rmc.ca
    %April 25, 2012
    
    properties
        
        MODE = 0;                                   %Corresponds to mode in multi-stage mission
                                                    %MODE 0: Exploring
                                                    %MODE 1: Monitoring
                                                    %MODE 2: Relaying
                    
        mission_control_position = [499,-499];  %Cartesion coordinates of mission control
        
    end
    
    methods
        function obj = SARAgent()
            %constructor
            obj = obj@TilingAgent();
        end
        
        function obj = Service_Target(obj, UID, time)
            %Monitor target
            obj.MODE = 1;
            fprintf('robot %d found target!\n',obj.ROBOT_INDEX);
        end
        
        function obj = Tour_Calculation(obj)
            
            global areaSize
            
            if obj.MODE == 0%Explore

                % follow tour
                if ~isempty(obj.D)
                    % set direction to next target
                    target = obj.D(1); 
                elseif ~isempty(obj.C_LOCAL)
                    target = obj.C_LOCAL(1);
                    obj.Cnext = obj.C_LOCAL(1).index;
                else
                    %end of phase
                    obj = obj.resetPhase();
                    target = obj.C_LOCAL(1);
                end

                %Update target heading
                obj.TargetHeading = target;
                
            elseif obj.MODE == 1%Monitor
                %Stay put
                obj.TargetHeading.position = obj.position;
                
            elseif obj.MODE == 2%Relay
                %Return to mission control
                obj.TargetHeading.position = obj.mission_control_position;
                
            end
            
        end%function
        
        function obj = hasArrived(obj,time)
            
            global END_CONDITION
            
            if obj.MODE == 0
                %Determine if agent has reached destination
                if Distance(obj.position,obj.TargetHeading.position) <= obj.serviceRadius
                    %agent has reached destination
                    if ~isempty(obj.D)
                        %service target
                        obj = obj.Service_Target(obj.D(1).UID,time);
                        obj.D(1) = [];

                    elseif ~isempty(obj.C_LOCAL)
                        %Remove exploration point from queue
                        obj.C_LOCAL(1) = [];

                        %Sense targets
                        obj = obj.SenseTargets();
                        %Add sensed targets to demand
                        obj.D = obj.SENSED_TARGETS;
                        if ~isempty(obj.D)
                            %Optimize route through current demand
                            obj.D = Rathinam1(obj,obj.D);
                        end
                    end
                end
                
            elseif obj.MODE == 1
                
                %Stay put
                
            elseif obj.MODE == 2
                
                %Check if at mission control
                if Distance(obj.position,obj.mission_control_position) <= obj.serviceRadius
                    END_CONDITION = 1;
                end
                
            end%if
            
        end%function
        
        function obj = setRelay(obj)
            
            obj.MODE = 2;
            obj.TargetHeading = obj.mission_control_position;
            
        end
        
    end%methods
end%classdef
            
            
            
        
        