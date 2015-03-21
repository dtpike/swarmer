function tess_area = CalcAreaVoronoi(robots, areaSize)
%CALCAREAVORONOI Given the position of the robots and areaSize (side length)
% returns a list of areas of voronoi regions
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%make matrix of robot positions
posn = [];
for i=1:size(robots,1)
    posn = [posn ; robots(i).position]; %#ok<AGROW>
end

%make matrix of mirrored robot positions (outside simulation area)
newPosn = [];
for i=1:size(posn,1)
    newPosn = [newPosn; posn(i,1) - 2*abs((-(areaSize/2) - posn(i,1))), posn(i,2)]; %#ok<AGROW>
    newPosn = [newPosn; 2*abs(((areaSize/2) - posn(i,1))) + posn(i,1), posn(i,2)]; %#ok<AGROW>
    newPosn = [newPosn; posn(i,1), posn(i,2) - 2*abs((-(areaSize/2) - posn(i,2)))]; %#ok<AGROW>
    newPosn = [newPosn; posn(i,1), 2*abs(((areaSize/2) - posn(i,2))) + posn(i,2)]; %#ok<AGROW>
end

%plot robot and mirrored positions
plot(newPosn(:,1), newPosn(:,2), '+r')
hold on;
plot(posn(:,1), posn(:,2), '+b')
posn2 = [posn ; newPosn];

%calculate and plot voronoi regions using mirrored positions
[vx, vy] = voronoi(posn2(:,1), posn2(:,2));
plot(vx,vy,'b-');

%calculate vertices and cells, then set any vertices ouside the area to Inf
[v , c] = voronoin(posn2);
i=1;
while (i<size(v,1))
    if abs(v(i,1)) > areaSize/2*1.1
        v(i,:) = [Inf Inf];
    elseif abs(v(i,2)) > areaSize/2*1.1
        v(i,:) = [Inf Inf];
    end
    i = i+1;
end

%calculate areas of regions
for i = 1 : size(c ,1)
    ind = c{i}';
    tess_area(i,1) = polyarea( v(ind,1) , v(ind,2) ); %#ok<AGROW>
end

%remove those regions outside the area, by checking for NaN
tessNAN = isnan(tess_area);
for i=1:size(tess_area,1)
    if tessNAN(i) == 1
        tess_area(i) = 0; %#ok<AGROW>
    end
end
i=1;
while i <= size(tess_area,1)
    if tess_area(i) == 0
        tess_area(i) = []; %#ok<AGROW>
    else
        i=i+1;
    end
end

%now we're left with the regions within the simulation area - return these