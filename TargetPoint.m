classdef TargetPoint
    %TARGETPOINT Class defining a target point
    %   Tracks position, time created and serviced, status, and service
    %   radius
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        UID;                        %identifier for target point, NO TWO TARGETS HAVE SAME UID NUMBER PER TRIAL
        EXPECTED_SERVICE_TIME;
        LOCAL_SERVICE_TIME;
        
        local;
        
        position = [0, 0];          % position of the point
        timeCreated = 0;            % time point was generated
        timeServiced;               % time point was serviced
        serviceTime;                % timeServiced - timeCreated
        serviced = 0;               % set to 1 when target is serviced
        serviceRadius;              % radius robot must be within in order to service target
        targetPOI;                  % 1 if a target, 0 if a POI
        index;                      %used for indexing
        created = 0;                %boolean value indicating whether target has been generated in simulation or is still yet to be generated
        %might have service requirements?
        %might have reward levels?
    end
    
    methods
        function obj = TargetPoint(time, radius, targetOrPOI) %constructor
            if nargin > 0
                % sets timeCreated
                obj.timeCreated = time;
                obj.serviceRadius = radius;
                obj.targetPOI = targetOrPOI;
            end
        end
        
        function Draw(obj, w) 
            %draw target
            
            if obj.targetPOI
                %draw filled square
                DrawSquare(obj.position, w, 'r');
            else
                DrawSquare(obj.position, w, 'b');
            end
        end
        
        function obj = CheckRadius(obj, time)
            %CHECKRADIUS Checks and removes target if an agent within the 
            %   minimum radius to service
            %   Uses serviceRadius as minimum distance
            
            global robots targetsServiced

            %for each target, check if a robot within minimum distance
            if obj.serviced == 0
                for j = 1:size(robots, 1)
                    if Distance(obj.position, robots(j).position) < obj.serviceRadius
                        % remove target
                        obj.timeServiced = time;
                        obj.serviceTime = obj.timeServiced - obj.timeCreated;
                        %disp(['Removed target for service time of ', num2str(obj.serviceTime)]);
                        obj.serviced = 1;
                        targetsServiced = targetsServiced + 1;
                        robots(j) = robots(j).Service_Target(obj);
                        break;
                    end
                end
            end
        end %end function
    end % end methods
    
end %end class

