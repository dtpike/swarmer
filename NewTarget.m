function target = NewTarget(UID,time,areaSize,serviceRadius,arg_str)

%NOTE: set timeServiced and serviceTime to 0 to initialize struct for MEX
%files


new_position = rand(1,2)*areaSize - areaSize/2;
target = struct('UID',UID,'position',new_position,'timeCreated',time,'timeServiced',0,'serviceTime',0,'serviced',0,'serviceRadius',serviceRadius,'created',1);

if nargin == 5
    if strcmp(arg_str,'empty')
        target = [];
    end
end

end


