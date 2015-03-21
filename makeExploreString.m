function string = makeExploreString(C_i,d)%#codegen

string = zeros(1,d);

for i=size(C_i,1)
    string(C_i.index) = 1;
end

end%function