function string = convertLocalToString(targets,d)

%Ensure size(targets,1) is not larger than d
if size(targets,1) > d
    fprintf('Error\n');
end

string = zeros(1,d);
for i=1:size(targets,1)
    string(targets(i).index) = 1;
end

end%function