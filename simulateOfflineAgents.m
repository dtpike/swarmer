function simulateOfflineAgents(handles)

%NOTE: various bugs associated with offline DTRP

global robots targets generated_targets FLAG_NEW_INFO

%setup figure, robots, targets
handles = setupFigureOffline(handles);
handles = calculatePaths(handles);


END_CONDITION = 0;

t = 0;

%while ~END_CONDITION
%for t=0:handles.timeStep:handles.endTime 
while ~END_CONDITION
    
%     if mod(t,5) == 0 && t~=0
%         fprintf('Halt for debugging: Pre-timestep\n');
%     end
    
    
    %Update Velocity
    for i=1:size(robots,1)
        robots(i) = robots(i).Update_Velocity();
    end
    
    %Move robots
    for i=1:size(robots,1)
        robots(i).position = robots(i).position + robots(i).velocity * handles.timeStep * robots(i).velMag;
    end
    
    %Record distance
    for i=1:size(robots,1)
        robots(i) = robots(i).updateDistanceTraveled(handles.timeStep);
    end
    
    %Check if any agents are within service radius of any targets
    targets = CheckTargetRadius(targets, t);
    
    %Display new positions
    %Voronoi???
    if handles.showDisplay == 1
        handles.d.Display(robots, targets, t, handles);
    end
    
    %Target generation and end condition
    if ~isempty(generated_targets)%check to see if there are targets left to generate
        %fprintf('%d targets left to generate\n',size(generated_targets,1));
        oldNumTags = size(targets,1);

        %Targets left to generate, check poisson random number
        f = poissrnd(handles.lambda*handles.timeStep,1,1);%number of targets to generate (usually 0 or 1)
        %Check if 1 target left to be generated
        
        for i=1:f
            %Check if generated_targets is empty
            if ~isempty(generated_targets)
                targets = [targets; generated_targets(1)];
                generated_targets(1) = [];
            end
        end
        
        %Check for new information
        if oldNumTags ~= size(targets,1)
            handles = calculatePaths(handles);
            %Necessary???
            %guidata(gcf,handles);
        end
        
    else
        END_CONDITION = 1;
        for i=1:size(targets,1)
            if targets(i).serviced == 0
                %end condition not met
                END_CONDITION = 0;
            end
        end
    end         

    %increment timer
    t = t + handles.timeStep;

end%simulation

end%function