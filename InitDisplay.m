classdef InitDisplay
%INITDISPLAY Sets up figure and fixes axes
%   Call Display(robots, targets, time) to update display with positions of robots and
%   targets and current time
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

    properties
        sideLength      % side length of display area
        rect_axis       % [xmin, xmax, ymmin, ymax]
        h = 30;         % height of triangle to draw
        b = 7.5;        % 1/2 base of triangle to draw
        w = 10;         % width of square to draw
        plotTour = 1;   % whether or not to plot the calculated tour over the positions
        plotVoronoi = 0;% whether or not to plot the Voronoi regions over the positions
        top;            % top of display window
    end
    
    methods
        function obj = InitDisplay(handles, sideLength, h, b, w, plotTour, plotVoronoi) 
            %constructor           
            if nargin == 7
                obj.h = h;
                obj.b = b;
                obj.w = w;
                obj.plotTour = plotTour;
                obj.plotVoronoi = plotVoronoi;
                obj.top = handles.areaSize/2 + 100;
            end
            
            obj.sideLength = sideLength;

            %set current axes to main window's
            axes();

            %set axis scale
            obj.rect_axis = [-sideLength/2, sideLength/2, -sideLength/2, sideLength/2];
            axis(obj.rect_axis);

            %rect = [70,80,850,750];
            %set(f,'Position',rect)      % set position on monitor (before GUI)

            %sets viewing angle to standard x-y, probably unneccesary
            ViewPoint = [0 90];
            view(ViewPoint);       
        end
        
        function Display(obj, robots, targets, time, handles)
            %DISPLAY Updates figure with new positions of robots, deleting
            %previous data.
            %   Robots must be an array of Agents
            %   Targets an array of Targets
            %   Time a number to be displayed
            
            global targetsServiced obstacles num_generated_targets

            delete(findobj('Type', 'Line'));    % deletes the previous agents
            delete(findobj('Type', 'Text'));    % deletes previous text
            hold on;
            plot(0, 0,'color', 'w')     %this seems to be necessary to actually 
                                            %delete the previous objects
            %reset axis scale
            axis(obj.rect_axis);
            
            %add text above graph
            text(-1000,obj.top,['Time = ',num2str(time)]);
            text(0, obj.top,['Target Count = ', num2str(num_generated_targets)]);
            text(1000,obj.top,['Serviced = ',num2str(targetsServiced)]);
            
            %for each robot and unserviced target, call its draw method
            for i=1:size(robots,1)
                robots(i).Draw(obj.h, obj.b);
                robots(i).detectArea.Draw(robots(i).position, robots(i).velocity);
            end
            for i = 1:size(targets, 1)
                if ~targets(i).serviced && targets(i).created
                    DrawSquare(targets(i).position,obj.w,'r');
                    %targets(i).Draw(obj.w)
                end
            end
            for i = 1:size(obstacles)
                obstacles(i).Draw();
            end
            
            %plot the Voronoi regions associated with the robots
            %if get(handles.check_Voronoi, 'Value')
            %    PlotVoronoi(robots);
            %end

            %clear the buffer
            drawnow;
            hold off;
        end
        
        function DisplayNoDelete(obj, robots, targets, time)
            %DISPLAYNODELETE Updates figure with new positions of robots
            %   Robots must be an array of Agents
            %   Targets an array of Targets
            %   Time a number to be displayed
            % BUT DOES not delete previous objects       
            
            global targetsServiced obstacles
            
            hold on;
            
            %reset axis scale in case it changed
            axis(obj.rect_axis);
            
            %add text above graph
            text(-1000,obj.top,['Time = ',num2str(time)]);
            text(0, obj.top,['Total POI Remaining = ', num2str(size(targets,1) - targetsServiced)]);
            text(1000,obj.top,['Targets Remaining = ',num2str(size(targets((([targets.serviced]==0) .* ([targets.targetPOI]==1)) == 1), 1))]);
            
            %call draw method of each robot and unserviced target
            for i=1:size(robots,1)
                robots(i).Draw(obj.h, obj.b);
                robots(i).detectArea.Draw(robots(i).position, robots(i).velocity);
            end
            for i = 1:size(targets, 1)
                if ~targets(i).serviced
                    DrawSquare(targets(i).position,obj.w,'r');
                end
            end
            for i = 1:size(obstacles)
                obstacles(i).Draw();
            end

            %clear buffer
            drawnow;
            hold off;
        end
        
        function DisplayTourVoronoi(obj, robots, targets, time, handles)
            %DISPLAYTOURVORONOI Updates figure with new positions of robots
            %   Robots must be an array of Agents
            %   Targets an array of Targets
            %   Time a number to be displayed
            % BUT DOES not delete previous objects
            % Checks InitDisplay properties to decide to plot tour or
            % voronoi
            
            global targetsServiced obstacles
            
            %plotting the tour erases previous plot data, so we don't need
            %to delete if we plot it
            if obj.plotTour
                gplot(handles.pathMatrix,handles.pathPoints);
            else
                delete(findobj('Type', 'Line'));    % deletes the previous agents
                delete(findobj('Type', 'Text'));    % deletes previous text
                plot(0, 0,'color', 'w')     %this seems to be necessary to actually 
            end                             %delete the previous objects
            
            hold on;
            %reset axis scale
            axis(obj.rect_axis);
            
            %add text above graph
            text(-1000,obj.top,['Time = ',num2str(time)]);
            text(0, obj.top,['Total POI Remaining = ', num2str(size(targets,1) - targetsServiced)]);
            text(1000,obj.top,['Targets Remaining = ',num2str(size(targets((([targets.serviced]==0) .* ([targets.targetPOI]==1)) == 1), 1))]);
            
            %call draw method of each robot and unserviced target
            for i=1:size(robots,1)
                robots(i).Draw(obj.h, obj.b);
                robots(i).detectArea.Draw(robots(i).position, robots(i).velocity);
            end
            for i = 1:size(targets, 1)
                if ~targets(i).serviced
                    targets(i).Draw(obj.w)
                end
            end
            if obj.plotVoronoi
                PlotVoronoi(robots)
            end
            for i = 1:size(obstacles)
                obstacles(i).Draw();
            end

            if ~isempty(obstacles) && targetsServiced == -1
                xpoints = (rand(1000,1)-.5)*1000;
                ypoints = (rand(1000,1)-.5)*1000;
                in = obstacles.inObstacle(xpoints, ypoints);
                plot(xpoints(in),ypoints(in),'r+',xpoints(~in),ypoints(~in),'bo')
            end

            %empty buffer
            drawnow;
            hold off;
        end
    end
end

