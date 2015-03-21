function [D_first,D_last] = UpdateRoutingTable(DEMAND,time,position,vel)
        
    time_holder = time;
    position_holder = position;

    D_first = [];
    D_last = [];

    %Verify demand is not empty
    if ~isempty(DEMAND)
        %Calculate local expected service times
        for i=1:size(DEMAND,1)
            distance = Distance(position_holder,DEMAND(i).position);
            DEMAND(i).LOCAL_SERVICE_TIME = time_holder + distance/vel;

            %Check whether EXPECTED_SERVICE_TIME is closer than LOCAL_SERVICE_TIME
            if DEMAND(i).LOCAL_SERVICE_TIME < DEMAND(i).EXPECTED_SERVICE_TIME
                %target can be serviced fastest locally, 
                %add to D_INTERNAL
                DEMAND(i).EXPECTED_SERVICE_TIME = DEMAND(i).LOCAL_SERVICE_TIME;
                D_first = [D_first; DEMAND(i)];
                time_holder = DEMAND(i).EXPECTED_SERVICE_TIME;
                position_holder = DEMAND(i).position;

            else
                %target can be serviced faster externally
                %add to D_EXTERNAL
                D_last = [D_last; DEMAND(i)];
            end

        end%for

        DEMAND = [D_first; D_last];
    end
            
            
end%function