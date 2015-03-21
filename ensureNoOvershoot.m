function handles = ensureNoOvershoot(handles)

while handles.agentVelocity * handles.timeStep >= handles.serviceRadius*2
    handles.timeStep = handles.timeStep - 0.01;
end

end