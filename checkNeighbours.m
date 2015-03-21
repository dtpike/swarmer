function neighbours = checkNeighbours(positions,R_COMM)%#codegen

%coder.varsize('neighbours',[50 2],[1 0]);
neighbours = [];

i = 1;
while i<=size(positions,1)
    j = i + 1;
    while j<=size(positions,1)
        if Distance(positions(i,:),positions(j,:)) <= R_COMM
            neighbours = [neighbours; i, j];
        end
        j = j + 1;
    end
    i = i + 1;
end

end
            