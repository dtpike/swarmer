function waypoints = createWaypoints(num_points,bound)

waypoints = zeros(num_points,2);

for i=1:num_points
    waypoints(i,:) = rand(1,2)*bound - bound/2;
end

end%function
