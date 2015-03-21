function varyLambda(handles,iterations,trials)

handles.serviceRadius = 6;

date_str = datestr(now,1);
path_str = sprintf('Results/varyLambda_%s.txt',date_str);
fid = fopen(path_str,'w');

start_time = datestr(now)

for i=trials
    handles.lambda = i;
    array = RunTrials(handles,iterations);
    writeArrayToFile(fid,array);
end

fclose(fid);

end_time = datestr(now);

%Formal print screen with timestamp difference
start_time
end_time

end