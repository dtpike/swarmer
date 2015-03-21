function handles = BatchRun(handles, hObject)
%BATCHRUN - Runs selected simulations a set number of times
% Sets up a time-stamped folder, and using parameters from GUI, creates a
% set number of position files. Runs simulations using all selected polices
% on this data, writing output to a text file also in the directory.
%
% Written by Alan Richards and Atif Rahman - alarobric@gmail.com
% Summer 2010

global VERSION

%set up folder
timeStamp = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
currentfolder = pwd;
% save the parameters in the batch data folder
newfolder = [currentfolder,'\batchdata-',timeStamp];
%create the folder if it does not exist
if ~exist(newfolder)
    mkdir(newfolder);
end

%get agent types
choice = get(handles.listbox_policies ,'Value');
stringData = get(handles.listbox_policies,'String');
agentTypes = {};
for i=1:length(choice)
    agentTypes{i} = eval([stringData{choice(i)}, 'Agent']);
end

% open the results file - if new then add heading line
cd(newfolder);
batchfile = ['BatchRunTimings','.txt'];
if ~exist(batchfile, 'file')
    fid = fopen(batchfile, 'w');
    fprintf(fid, 'TimeOfRun,RunID');
    for i=1:length(agentTypes)
        fprintf(fid, [',', class(agentTypes{i}), 'Average,', class(agentTypes{i}), 'Max']);
    end
    fprintf(fid, '\n');
    fclose(fid);
end
cd(currentfolder);

%Loop for how many times agents are to be simulated
for j = 1:str2double(get(handles.edit_batchNumber,'String'));
    
    handles.multipleRun = 1;    %marker variable for showing msgboxes each run
    %initialize with headings
    handles.runInfo = {'Agent', 'Num Serviced', 'Average Service Time', 'Max Service Time'};
    %generate initial position data
    handles = SetupFigure(handles);
    guidata(hObject, handles);
    
    %write the positions to a numbered file in the folder
    load('lastSetup.backup', '-mat');
    cd(newfolder);
    % file name "BatchDataPositions#", the number indicating which
    % simulation is running.
    namefile = ['BatchDataPositions', num2str(j), '.backup'];
    save(namefile, '-mat', 'VERSION', 'numRobots', 'numTargets', 'numPOI', 'timeStep', 'endTime', 'agentType', 'agentParameters', 'agentVelocity', 'agentMinTurningRadius', 'serviceRadius', 'lambda', 'generateTargets', 'lambdaRatio', 'targs', 'positions', 'obstacles');
    cd(currentfolder);

    %for each agent, run a simulation using the same parameters
    for i=1:length(agentTypes)
        %display dialog with current agentType for a maximum of 1 seconds
        h = msgbox(['Now running ', class(agentTypes{i}), '. Run ', num2str(j), '.'], 'Batch-Run');
        uiwait(h, 1);
        if ishandle(h)
            delete(h);
        end
        
        %call setupFigure, CalculatePaths, and RunSimulation
        %guidata call is necessary to save handle data inbetween calls
        handles = SetupFigureFromSave(handles, agentTypes{i});
        guidata(hObject, handles);
        handles = CalculatePaths(handles);
        guidata(hObject, handles);
        handles = RunSimulation(handles);
        guidata(hObject, handles);
        if handles.stop == 1
            uiwait(msgbox('Batch Run stopped during execution', 'Error'));
            return
        end
    end

    %display info to the console and a messagebox
    runInfo = handles.runInfo;

    cd(newfolder);
    %write info from each policy to file and screen
    fid = fopen(batchfile, 'a');
    date =  datestr(now);
    fprintf(fid, '%s,%d', date, j);
    for i=2:size(runInfo,1)
        fprintf(fid, ',%0.2f,%0.2f', runInfo{i,3}, runInfo{i,4});
        output = sprintf('%s - %s%d%s%0.2f\n%s%0.2f\n', runInfo{i,1}, ...
        'Average service time for ', runInfo{i,2}, ' target(s) was ', runInfo{i,3}, ...
        'Last target was serviced at ', runInfo{i,4});
        disp(output);
    end
    fprintf(fid, '\n');
    disp('===============================');
    fclose(fid);
    cd(currentfolder);

    %Message box to inform which batch run is complete, out of the total
    %number of batch runs
    h = msgbox({['Batch Run ', num2str(j), ' out of ', get(handles.edit_batchNumber,'String'), ' has been completed']}, 'Complete');
    %Show the dialogue box for 3 seconds maximum
    uiwait(h,3);
    if ishandle(h)
        delete(h);
    end
    %reset marker variable and save data to handles
    handles.multipleRun = 0;
    guidata(hObject, handles);
end
% end of Batch Run loop
% Notify the user that all Batch Run simulations have been completed
uiwait(msgbox('All Batch Runs have been completed', 'Batch runs Complete'));