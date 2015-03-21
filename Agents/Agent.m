classdef Agent
    %AGENT Abstract class for an agent. Must be subclassed and extended.
    %   Has position, velocity unit vector, and velocity magnitude, but
    %   Update_Velocity must be defined in a subclass. 
    %   Allows easy writing of new algorithms and properties using a base
    %   agent class.
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        position = [0, 0];      % x, y position
        velocity = [1, 0];      % unit vector denoting direction of movement
        velMag = 1;             % magnitude of velocity
        heading = 0;            % heading
        tour = [];              % indexes of POI to visit (calculated by CalculatePaths)
        minTurningRadius = 0;
        agentVelocity = 15;
        distanceTraveled = 0;   %total distance traveled by agent
                                %possible tracking of visited targets, communication radius, target
        detectArea;
        TargetHeading;          %Target the agent is currently going for (target point or exploratino point)
        serviceRadius;          %Radius for which vehicle can service payloads
        ROBOT_INDEX;            %index for robots based on global array
    end
    
    methods
        function obj = Agent(detectArea, agentVelocity, minTurningRadius)
            %Constructor
            % set detectArea if one argument
            % if none default to infinite sensing
            if nargin > 0
                obj.detectArea = detectArea;
            else
                obj.detectArea = detectableInfinite;
            end
            
            %Used if using RK4
            if nargin == 3
                obj.agentVelocity = agentVelocity;
                obj.minTurningRadius = minTurningRadius;
            end
        end %constructor
        
        function obj = set.velocity(obj, value)
            % check that the new velocity is a 2d unit vector
            if size(value) == [1 2]
                if value ~= [0,0]
                    if norm(value) < 1.0001 && norm(value) > 0.9999
                        obj.velocity = value;
                        obj.heading = acos(value(1));
                    else
                        display('New velocity should be a unit vector - magnitude is velMag');
                    end
                end
            else
                display('New velocity should be a 2-d unit vector');
            end
        end %function
        
        function obj = set.position(obj, value)
            global obstacles
            if ~isempty(obstacles)
                if sum(obstacles.inObstacle(value(1), value(2))) > 0
                    %don't move
                    obj.position = obj.position;
                    %or raise error
                    throw(MException('Alan:setPosition', 'Trying to move into an obstacle'));
                    %or simply ignore
                    return;
                end
            end
            obj.position = value;
        end %function
        
        function Draw(obj, h, b)
            %DRAW Draws the agent as a triangle with height h and width b
            DrawTriangle(obj.position, obj.velocity, h, b, 'k');
        end
        
        function obj = updateDistanceTraveled(obj,timestep)
            obj.distanceTraveled = obj.distanceTraveled + obj.velMag*timestep;
            
        end%function
        
        function obj = Update_Velocity(obj)
            
            if Distance(obj.TargetHeading.position,obj.position) >= obj.serviceRadius
                vel = obj.TargetHeading.position - obj.position;
                obj.velocity = vel/norm(vel);
                obj.velMag = obj.agentVelocity;
            else
                obj.velocity = [0,0];
                obj.velMag = 0;
            end
            
        end
    end %methods
    
    methods (Abstract)  %must be implemented by any subclass
        %obj = Update_Velocity(obj)    %Called at each time step to allow agent to change direction or speed
            %can add other arguments in implementation
        obj = Service_Target(obj, target)   %Called when an agent is close enough to service a target
    end
    
end %classdef

