function adj = CompleteGraph2(targets,p1,p2)%#codegen

numTargets = size(targets,1);

numRobots = 2;
adj = zeros(numRobots+numTargets);
adj(1,2) = -1;

for j=1:numTargets
    adj(1,j+numRobots) = Distance(p1,targets(j).position);
end

for j=1:numTargets
    adj(2,j+numRobots) = Distance(p2,targets(j).position);
end
    
for i=1:numTargets

    for j=i:numTargets
        adj(i+numRobots,j+numRobots) = Distance(targets(i).position, targets(j).position);
    end
    
end

%mirror to double edges for a doubly directed graph
adj = adj + adj';

end%function