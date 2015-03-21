function NEW_LOCAL_DEMAND = Rathinam1(robot_position,OLD_LOCAL_DEMAND)

if size(OLD_LOCAL_DEMAND,1) > 1
    adj = CompleteGraph(OLD_LOCAL_DEMAND,robot_position);
    span = minimum_spanning_tree(adj);
    adj2 = adj;
    adj2(span==0) = 0;%ensure all costs from one spot to the same spot is 0
    adj2(adj==-1) = 0;

    %NOTE: if 'robot' is required to have only one entry
    tree = SplitTree(adj2, 1);
    tour = ConstructTour(tree);

    %Remove first point on NEW_LOCAL_DEMAND
    tour = tour(:,2:end);
    tour = tour - 1;

    for i=1:size(OLD_LOCAL_DEMAND,1)
        %i
        NEW_LOCAL_DEMAND(i,1) = OLD_LOCAL_DEMAND(tour(i));
    end

else
    NEW_LOCAL_DEMAND = OLD_LOCAL_DEMAND;
end

end%function