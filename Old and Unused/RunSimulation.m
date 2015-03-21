function handles = RunSimulation(handles)
% RUNSIMULATION - called by gui
% iterates through time steps, updating positions, checking targets and
% getting new velocities
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

global robots targets generated_targets

%==========================================================================
%TIME STEPS
%==========================================================================
set(handles.saveVideo, 'Enable', 'Off');
Vidstatus = get(handles.saveVideo, 'Value');
if (Vidstatus  == 1);
    %aviobj = avifile('test.avi');
    framecount=1;
end

%iterate through time steps until simulation is complete
for t = 0:handles.timeStep:handles.endTime
    %check if stop was pressed
    drawnow;
    handles = guidata(gcbo);
    if handles.stop == 1
        disp('Stop');
        return
    end
    
    % update velocity
    for i = 1:handles.numRobots
        robots(i) = robots(i).Update_Velocity(); 
    end
    
    % move robots
    for i = 1:handles.numRobots
        %euler 1st order
        robots(i).position = robots(i).position + robots(i).velocity * handles.timeStep * robots(i).velMag;
    end
    
    % check if an agent close enough to a target and remove
    targets = CheckTargetRadius(targets, t);
       
    % display new position
    handles.d.DisplayTourVoronoi(robots, targets, t, handles);
    
    
    %TODO: Change to accomodate for all targets (not just POIs)
    
    %end condition for simulation - all targets serviced
    if sum([targets([targets.targetPOI]==1).serviced]) == sum([targets.targetPOI]==1)
    %if sum([targets([targets.targetPOI]==1).serviced]) == handles.numTargets 
    %if targetsServiced == size(targets, 1)
        break
    end
    
    %Add more POI
    if handles.generateTargets
        oldNumTargs = size(targets, 1);
        targets = [targets; NewTarget(handles.lambda, t, handles.serviceRadius, handles.areaSize, handles.lambdaRatio)];
        
        %Keep unchecked from now on
        if handles.recalculatePaths && oldNumTargs ~= size(targets, 1)
            %uiwait(msgbox('Updating paths'));
            handles = CalculatePaths(handles);
            guidata(gcf, handles);
        end
    end

    %Add frame to video
    if (Vidstatus == 1)
        VidArray(framecount) = getframe(gca);
        framecount = framecount+1;
    end

end


%==========================================================================
%CLEAN UP
%==========================================================================
disp(' ');
disp('==============================');

% display average service time - both in console and a popupbox
serviceTimes = ([targets(([targets.serviced]==1 .* [targets.targetPOI]==1) == 1).serviceTime]);
totalTime = sum(serviceTimes);
numServiced = size(serviceTimes,2);

if handles.multipleRun
    %add run info to handles
    handles.runInfo = [handles.runInfo ; ...
      {class(robots(1)), numServiced, totalTime/numServiced, max(serviceTimes)}];
else
    %display run info onscreen
    disp(['Average service time for ',num2str(numServiced),' target(s) was ', num2str(totalTime/numServiced)]);
    disp(['Last target was serviced at ', num2str(max(serviceTimes))]);
    uiwait(msgbox({['Average service time for ',num2str(numServiced),' target(s) was ', num2str(totalTime/numServiced)], ...
    ['Last target was serviced at ', num2str(max(serviceTimes))]}, 'Simulation Finished'));
end

%if making movie
if (Vidstatus==1);
    saveRobotVideo(VidArray);
end
set(handles.saveVideo, 'Enable', 'On');

end

