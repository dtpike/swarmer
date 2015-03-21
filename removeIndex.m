function targets = removeIndex(targets,index)%#codegen

for i=1:size(targets,1)
    if targets(i).index == index
        targets(i) = [];
        break;
    end
end

end%function