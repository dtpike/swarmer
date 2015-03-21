classdef detectableArea
    %DETECTABLEAREA - defines the area around an agent
    %abstract - must be subclassed
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        parent
    end %properties
    
    methods
        function obj = detectableArea(parent)
            %obj.parent = parent;
            %TODO: but this won't work since matlab doesn't pass by reference
        end
    end % methods
    
    methods (Abstract)
        %method should return a logical array with 1 for each
        %positionObject within the sensing area
        boolReturn = boolWithinArea(obj, position, heading, positionObject)
        
        %method should return only the positionObjects within the sensing area
        objReturn = objWithinArea(obj, position, heading, positionObject)
        
        %should draw the sensing area onscreen
        Draw(obj, position, heading)
    end %abstract methods 
end %classdef