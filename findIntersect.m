function ret = findIntersect(targets1,targets2,GLOBAL)

ret = NewPoint(0,[0,0],0,0,0);
ret(1) = [];

%Check whether target sets are populated
if ~isempty(targets1) && ~isempty(targets2)
    s = [];
    t = [];

    for i=1:size(targets1,1)
        s = [s; targets1(i).index];
    end

    for i=1:size(targets2,1)
        t = [t; targets2(i).index];
    end

    int_str = intersect(s,t);

    %fprintf('Populating %d entries in intersection\n',size(int_str,1));
    if ~isempty(int_str)
        for i=1:size(int_str,1)
            ret(i,1) = GLOBAL(int_str(i));

            %fprintf('Populating intersection with position x = %0.2f, y=%0.2f\n, index = %d\n',ret(i,1).position(1), ret(i,1).position(2), ret(i,1).index);
        end
    end

elseif ~isempty(targets1)
    ret = targets1;
elseif ~isempty(targets2)
    ret = targets2;
else
    ret = [];
end

end