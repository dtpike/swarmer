function robots = simulateCollaboration(robots)%#codegen

%Collaboration Module
i = 1;
while i<=size(robots,1)
    j = i + 1;
    while j<=size(robots,1)
        if Distance(robots(i).position,robots(j).position) <= handles.R_COMM && ~isempty(robots(i).C_LOCAL) && ~isempty(robots(j).C_LOCAL)...
            && (robots(i).LCI ~= robots(j).ROBOT_INDEX) && (robots(j).LCI ~=robots(i).ROBOT_INDEX)
            [robots(i),robots(j)] = Collaborate2(robots(i),robots(j));
        end
        j = j + 1;
    end%while
    i = i + 1;
end%while

end
