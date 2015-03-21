function main()

initialize_batch();

handles.numRobots = 5;
handles.serviceRadius = 6;
handles.agentVelocity = 100;
handles.endTime = 50;
varyLambda(handles,1,7.5);

end