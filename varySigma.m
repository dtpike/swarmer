function [ret] = varySigma(handles,iterations,trials)

%script to run trials varying simga

addpath('Agents'); 
addpath('graph'); 
addpath('detectableAreas');

fid = fopen('results1.txt','w');

%Default 10
num_trials = size(trials,2);

ret = zeros(num_trials,1+iterations);
trial_index = 1;

start_time = datestr(now);

for i=trials
    
    handles.R_SENSE = i;
    %handles = setRadiusFromSensingCoverage(handles);
    handles.R_COMM = handles.R_SENSE;
    
    [ret(trial_index,:)] = RunTrials(handles,iterations,fid);
    
    trial_index = trial_index + 1;
    
end

fclose(fid);

end_time = datestr(now);

start_time
end_time


end