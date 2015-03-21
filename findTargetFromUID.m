function [target,i] = findTargetFromUID(targets,UID)

target = [];

for i=1:size(targets,1)
    %Check whether target has matching UID
    if (targets(i).UID == UID);
        %Target found
        target = targets(i);
        break;
    end
end

end