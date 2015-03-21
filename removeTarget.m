function RETURN = removeTarget(TARGETS,UID)

RETURN = TARGETS;

if ~isempty(TARGETS)
    for i=1:size(TARGETS,1)
        if TARGETS(i).UID == UID
            RETURN(i) = [];
            break;
        end
    end%for
end%if

end%function