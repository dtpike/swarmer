function [robot1,robot2] = Collaborate2vSAR(robot1,robot2)

fprintf('Robot %d and %d in comms range!\n',robot1.ROBOT_INDEX,robot2.ROBOT_INDEX);

%Check the modes of each robot
if robot1.MODE == 0 && robot2.MODE == 0
    %ensure both C sets are populated
    C_int = findIntersect(robot1.C_LOCAL, robot2.C_LOCAL, robot1.C_GLOBAL);

    %Check if intersection is empty
    %if so, reset phase of both agents
    if ~isempty(C_int)
        
        %optimize code - use '.empty()'
        robot1.C_LOCAL = TargetPoint();
        robot1.C_LOCAL(1) = [];
        robot2.C_LOCAL = TargetPoint();
        robot2.C_LOCAL(1) = [];

        [robot1,robot2] = Rathinam2(robot1,robot2,C_int);

    else%intersection is empty, reset phase for both agents and run 2-tour
        [robot1,robot2] = Rathinam2(robot1,robot2,robot1.C_GLOBAL);
    end

    robot1.LCI = robot2.ROBOT_INDEX;
    robot2.LCI = robot1.ROBOT_INDEX;
    
elseif robot1.MODE == 1
    %Send robot2 back to mission control
    robot2.MODE = 2;
    robot2.TargetHeading.position = robot2.mission_control_position;
    
elseif robot2.MODE == 1
    %Send robot1 back to mission control
    robot1.MODE = 2;
    robot1.TargetHeading.position = robot1.mission_control_position;
    
end%endif

    

end