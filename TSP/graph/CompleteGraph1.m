function adj = CompleteGraph1(targets,p1)%#codegen

numTargets = size(targets,1);

%Assume nargin == 2
numRobots = 1;
adj = zeros(numRobots+numTargets);

for j=1:numTargets
    adj(1,j+numRobots) = Distance(p1, targets(j).position);
end
    
for i=1:numTargets

    for j=i:numTargets
        adj(i+numRobots,j+numRobots) = Distance(targets(i).position, targets(j).position);
    end
    
end

%mirror to double edges for a doubly directed graph
adj = adj + adj';

end%function