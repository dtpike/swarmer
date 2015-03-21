function handles = setRadiusFromSensingCoverage(handles)

handles.R_COMM = sqrt((handles.areaSize^2)*handles.SENSING_COVERAGE/handles.numRobots/pi);
handles.R_SENSE = sqrt((handles.areaSize^2)*handles.SENSING_COVERAGE/handles.numRobots/pi);

end