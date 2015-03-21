function [robot1,robot2] = CollaborateTI(handles,robot1,robot2)

%ensure both C sets are populated
C_int = findIntersect(robot1.C_LOCAL, robot2.C_LOCAL, robot1.C_GLOBAL);

robot1.c_string = convertLocalToString(robot1.C_LOCAL);
robot2.c_string = convertLocalToString(robot2.C_LOCAL);

%find intersection
intersect = robot1.c_string & robot2.c_string;

%intialize C_int then empty it
C_int = handles.C_GLOBAL(1);
C_int(1) = [];

%Remove intersect from robot1 and robot2
for i=1:size(intersect,2)
    if intersect(i) == 1
        %Remove from robot1 and robot2
        robot1.C_LOCAL = removeIndex(robot1.C_LOCAL,i)
        robot2.C_LOCAL = removeIndex(robot2.C_LOCAL,i)
        
        %construct C_intersect
        C_int = [C_int; handles.C_GLOBAL(i)]
    end
end

%calculate minium spanning tree of intersect points
adj = CompleteGraph2(robot1.position,robot2.position,C_int);
tree = MST(adj);













%Check if intersection is empty
%if so, reset phase of both agents
if ~isempty(C_int)

    robot1.C_LOCAL = TargetPoint().empty();
    robot2.C_LOCAL = TargetPoint().empty();

    [robot1,robot2] = Rathinam2(robot1,robot2,C_int);
    
else%intersection is empty, reset phase for both agents and run 2-tour
    [robot1,robot2] = Rathinam2(robot1,robot2,robot1.C_GLOBAL);
end

robot1.LCI = robot2.ROBOT_INDEX;
robot2.LCI = robot1.ROBOT_INDEX;
    

end