function T = getLowerBound(handles)

m = handles.numRobots;
v = handles.agentVelocity/1000;
beta = 0.712;
lambda = handles.lambda;
A = handles.areaSize^2;

%from Enright and Frazzoli
T = (beta^2)*lambda/((m^2)*(v^2));

end