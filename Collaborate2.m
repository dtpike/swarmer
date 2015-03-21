function [robot1,robot2] = Collaborate2(robot1,robot2,policy)

if strcmp(policy,'FI')

    %ensure both C sets are populated
    C_int = findIntersect(robot1.C_LOCAL, robot2.C_LOCAL, robot1.C_GLOBAL);

    %Check if intersection is empty
    %if so, reset phase of both agents
    if ~isempty(C_int)
        
        %Create empty structures for targets
        robot1.C_LOCAL = NewPoint(0,[0 0],0,0,0);
        robot1.C_LOCAL(1) = [];
        robot2.C_LOCAL = NewPoint(0,[0 0],0,0,0);
        robot2.C_LOCAL(1) = [];

        [robot1,robot2] = Rathinam2(robot1,robot2,C_int);

    else%intersection is empty, reset phase for both agents and run 2-tour
        [robot1,robot2] = Rathinam2(robot1,robot2,robot1.C_GLOBAL);
    end

    robot1.LCI = robot2.ROBOT_INDEX;
    robot2.LCI = robot1.ROBOT_INDEX;
    
elseif strcmp(policy,'TI')
    
    d = size(robot1.C_GLOBAL,1);
    
    %TODO
    %write  convertLocalToString
    %       removeIndex
    
    %optimize
    %       CompleteGraph
    %       minimum_spanning_tree
    %       SplitTree2
    %       new functions above
    
    robot1.c_string = convertLocalToString(robot1.C_LOCAL,d);
    robot2.c_string = convertLocalToString(robot2.C_LOCAL,d);
    
    intersect = robot1.c_string & robot2.c_string;
    
    C_int = robot1.C_GLOBAL(1);
    C_int(1) = [];
    
    %Remove intersect from robot1 and robot2
    for i=1:size(intersect,2)
        if intersect(i) == 1
            %Remove from robot1 and robot2
            robot1.C_LOCAL = removeIndex(robot1.C_LOCAL,i);
            robot2.C_LOCAL = removeIndex(robot2.C_LOCAL,i);

            %construct C_intersect
            C_int = [C_int; robot1.C_GLOBAL(i)];
        end
    end
    
    %calculate minimum spanning tree for intersect points
    if ~isempty(C_int)
        adj = CompleteGraph(C_int,robot1.position,robot2.position);
        span = minimum_spanning_tree(adj);

        adj2 = adj;
        adj2(span == 0) = 0;
        adj2(adj == -1) = 0;

        [indices1,tree1,indices2,tree2] = SplitTree2(adj2);

        indices1 = indices1(1,2:end);
        indices2 = indices2(1,2:end);

        indices1 = indices1 - 2;
        indices2 = indices2 - 2;

        %add indices to C_LOCAL
        if ~isempty(indices1)
            for i=1:size(indices1,2)
                robot1.C_LOCAL = [robot1.C_LOCAL; C_int(indices1(i))];
            end
        end
        if ~isempty(indices2)
            for i=1:size(indices2,2)
                robot2.C_LOCAL = [robot2.C_LOCAL; C_int(indices2(i))];
            end
        end

        %run 1-tour through each set of points
        robot1.C_LOCAL = Rathinam1(robot1.position,robot1.C_LOCAL);
        robot2.C_LOCAL = Rathinam1(robot2.position,robot2.C_LOCAL);
    else
        %No targets, don't change anything
    end
    

end