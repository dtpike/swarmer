classdef BasicAgent < Agent
    %BASICAGENT Subclass of Agent - Simply drives forward
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
    end
    
    methods
        function obj = BasicAgent()
            %constructor
            obj = obj@Agent();
        end
        
        function obj = Update_Velocity(obj)
            %simply leaves velocity unchanged to drive in a straight line           
        end
        
        function obj = Service_Target(obj, ~)
            %no action required
        end
        
    end
    
end

