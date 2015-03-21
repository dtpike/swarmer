function points = calcLocalPointsFromIntersection(p_local,p_neighbour,intersection)

%construct adjacency matrix

tree = MST(intersection)

[indices1,newAdj1,indices2,newAdj2] = SplitTree2(adj)