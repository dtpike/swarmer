function point = NewPoint(index,position,serviceRadius,UID,timeCreated)

if nargin == 3
    point = struct('bPointType',0,'index',index,'UID',0,'position',position,'serviceRadius',...
        serviceRadius,'timeCreated',0,'timeServiced',0,'serviceTime',0,'serviced',0,'created',1);
elseif nargin == 5
    point = struct('bPointType',1,'index',0,'UID',UID,'position',position,'serviceRadius',...
        serviceRadius,'timeCreated',timeCreated,'timeServiced',0,'serviceTime',0,'serviced',0,'created',1);
end

end%function