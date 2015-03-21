classdef CircleAgent < Agent
    %CIRCLEAGENT Subclass of Agent - Simply drives in a tight circle
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
    end
    
    methods
        function obj = CircleAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Update_Velocity(obj)
            %Required method of Agent - simply drives in a circle
            theta = pi/150;
            vel = obj.velocity * [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
            vel = vel / norm(vel);
            obj.velocity = vel;
        end
        
        function obj = Service_Target(obj, ~)
            %No action required
        end
        
    end
    
end

