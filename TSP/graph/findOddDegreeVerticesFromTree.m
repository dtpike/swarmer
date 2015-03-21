function [odd_adj,vertices] = findOddDegreeVerticesFromTree(tree,adj)%#codegen

vertices = [];

for i=1:size(tree,2)%Go through columns i
    degree = sum(tree(:,i));
    if mod(degree,2) == 1
        %fprintf('Vertex %d is odd\n',i)
        vertices = [vertices i];
    end

end

%construct adjacency matrix of odd degree vertices
odd_adj = zeros(size(vertices,2));

for i=1:size(vertices,2)
    for j=i:size(vertices,2)
        odd_adj(i,j) = adj(vertices(i),vertices(j));
        odd_adj(j,i) = adj(vertices(i),vertices(j));
    end
end

end%function