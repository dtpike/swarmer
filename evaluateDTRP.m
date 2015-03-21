function cost = evaluateDTRP(handles,instance)          

%Set detectable region for R_SENSE
handles.detectableRegion = detectableCircle(handles.R_SENSE);

%Ensure no overshoot
handles = ensureNoOvershoot(handles);

%declare globals
global robots targets current_targets generated_targets robot_positions areaSize targetsServiced

areaSize = handles.areaSize;

robot_positions = instance.ROBOT_POSITIONS;
targets = [];

%Assume no initial targets
current_targets = [];

%simulate problem instance

simulateDTRP(handles);

%calculate total wait time
% total_service_time = 0;
% for i=1:size(targets,1)
%     total_service_time = total_service_time + targets(i).serviceTime;
% end

max_wait_time = 0;
for i=1:size(targets,1)
    if max_wait_time < targets(i).serviceTime
        max_wait_time = targets(i).serviceTime;
    end
end

for i=1:size(targets,1)
    if targets(i).serviceTime ~= 0
        wait_times(i) = targets(i).serviceTime;
    end
end

%Remove all zero entries in wait_times
wait_times(wait_times==0) = [];

%Take the last 10 percent of these values and calculate the steady-state
%wait time
ss_wait_time = mean(wait_times(ceil(size(wait_times,2)*0.9):end));

if strcmp(handles.cost,'max')
    cost = max_wait_time;
elseif strcmp(handles.cost,'ss')
    cost = ss_wait_time;
end

end