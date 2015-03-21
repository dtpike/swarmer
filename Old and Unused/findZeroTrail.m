function [f_index,l_index]=findZeroTrail(array)

array_size = size(array,2);

i=1;
current_zero = 0;
f_index = [];
l_index = [];
found = 0;

while found <= 5 || current_zero
    
    if array(i) == 0
        current_zero = 1;
    end
    
    if found == 0 && array(i) == 0
        f_index = i;
        found = found + 1;
    elseif array(i) == 0
        found = found + 1;
    else%array(i) ~= 0
        if found <= 5
            found = 0;
        else
        l_index = i;
        end
        current_zero = 0;
    end
    
    %increment index
    i = mod(i,array_size) + 1;
end%while

%check for other trail of zeros?!?!?!?!

end%function