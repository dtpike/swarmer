function [robot1,robot2] = Rathinam2(robot1,robot2,COLLECTIVE_DEMAND)
%TODO:optimize code with MEX functions

robots = [robot1; robot2];

adj = CompleteGraph(COLLECTIVE_DEMAND,robot1.position,robot2.position);
span = minimum_spanning_tree(adj);
adj2 = adj;
adj2(span==0) = 0;%ensure all costs from one spot to the same spot is 0
adj2(adj==-1) = 0;

trees = SplitTree(adj2, 2);
tour1 = ConstructTour(trees(1,:));
tour2 = ConstructTour(trees(2,:));

tour1 = tour1(:,2:end);
tour2 = tour2(:,2:end);

tour1 = tour1 - 2;
tour2 = tour2 - 2;

for i=1:size(tour1,2)
    robot1.C_LOCAL(i,1) = COLLECTIVE_DEMAND(tour1(i));
end

for i=1:size(tour2,2)
    robot2.C_LOCAL(i,1) = COLLECTIVE_DEMAND(tour2(i));
end

end