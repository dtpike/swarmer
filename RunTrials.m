function [array] = RunTrials(handles,num_trials)

%------------------------------------------------------------------------%
%General MonteCarlo parameters
%------------------------------------------------------------------------%
%Ensures targets are being generated the entire time
handles.NUM_TARGETS = handles.endTime*handles.lambda + 100%ouput handles variables to command line

%Parallelize?
PARALLEL = handles.bParallel;

if ~PARALLEL
    fprintf('Running %d trials...\n',num_trials);
    
    %initialize output array
    output = zeros(1,num_trials);
    
    for z=1:num_trials
        instance = createDTRP(handles);
        output(z) = evaluateDTRP(handles,instance);
        fprintf('Completed trial #%d/%d @%s with cost = %0.2f\n',...
            z,...
            num_trials,...
            datestr(now),...
            output(z));
    end

    array = [handles.R_SENSE*0.001, handles.lambda, handles.numRobots, handles.agentVelocity*0.001, output];
    
else
    %------------------------------------------------------------------------%
    %Parallelization parameters
    %------------------------------------------------------------------------%
    NUM_PROCS = 6%display number of threads to command line

    %Calculate number of trials being calculated per thread
    num_thread_iterations = ceil(num_trials/NUM_PROCS);
    thread_output = zeros(1,num_thread_iterations);

    %Initialize matlab pool if no already open
    if matlabpool('size') == 0
        matlabpool('open','local',NUM_PROCS);
    elseif matlabpool('size') < NUM_PROCS
        matlabpool('close');
        matlabpool('open','local',NUM_PROCS);
    end

    fprintf('Running %d trials with %d threads...\n',NUM_PROCS*num_thread_iterations,NUM_PROCS);
    
%-------------------------------------------------------------------------%
%----------------------------Parallel-Code--------------------------------%
%-------------------------------------------------------------------------%
    
    spmd(NUM_PROCS)

        thread_output = zeros(1,num_thread_iterations);
        for z=1:num_thread_iterations

            %reset random number generator
            reset(RandStream.getDefaultStream,sum(100*clock*labindex));
            instance = createDTRP(handles);     
            thread_output(z) = evaluateDTRP(handles,instance);
            
            %print out cost and timestamp
        	fprintf('Completed trial #%d/%d @%s with cost = %0.2f\n',...
            z,...
            num_thread_iterations,...
            datestr(now),...
            thread_output(z));
        end

        %Collect data
        if labindex == 1%master thread: collect data
            output = thread_output;
            for i=2:NUM_PROCS
                output = [output, labReceive(i)];
            end
            %size_output = size(output,2)
        else%slave thread: send data to master
            labSend(thread_output,1);
        end

    end%parallelization

    %matlabpool('close');

    array = [handles.R_SENSE*0.001, handles.lambda, handles.numRobots, handles.agentVelocity*0.001, output{1}];
    
%-------------------------------------------------------------------------%
%---------------------------End-Parallel-Code-----------------------------%
%-------------------------------------------------------------------------%

end%if

fprintf('\nCompleted %d trials with :\n sigma:%0.2f\n lambda:%0.2f\n m:%d\n v:%0.2f\n',...
    size(array(1,5:end),2),...
    handles.R_SENSE*0.001,...
    handles.lambda,...
    handles.numRobots,...
    handles.agentVelocity*0.001);

end