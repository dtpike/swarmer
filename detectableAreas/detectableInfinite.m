classdef detectableInfinite < detectableArea
    %DETECTABLEINFINITE - Represents a robot with infinite sensing radius.
    %Does not draw anything
    %
    % Written by Alan Richards - alarobric@gmail.com
    % Summer 2010
    
    properties
        
    end
    
    methods
        function obj = detectableInfinite()
            obj = obj@detectableArea();
        end
        
        function boolReturn = boolWithinArea(obj, ~, ~, positionObject)
            %return all ones
            boolReturn = ones(size(positionObject));
        end
        
        function objReturn = objWithinArea(obj, ~, ~, positionObject)
            %return everything given
            objReturn = positionObject;
        end
        
        function Draw(obj, ~, ~)
        end
        
    end %methods
end %classdef