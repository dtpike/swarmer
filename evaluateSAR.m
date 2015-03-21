function cost = evaluateSAR(handles,instance)

%EvaluateProblemInstance - evalutes problem isntance
%INPUTS-    handles: system parameters
%           ProblemInstnace: initial configuration of robots and targets and generated locations of future targets            

%Set detectable region for R_SENSE
handles.detectableRegion = detectableCircle(handles.R_SENSE);

%declare globals
global robots targets generated_targets robot_positions areaSize targetsServiced

areaSize = handles.areaSize;

robot_positions = instance.ROBOT_POSITIONS;
targets = instance.ALL_TARGETS;

cost = simulateSAR(handles);

end