function [pointcloud] = get_sensorreadings_worldframe(sensorPose)
%GET_SENSORREADINGS_WORLDFRAME Gets the points from the sensor in the world
%frame

[pointcloud, pose] = robot_controls.get_sensorreadings(sensorPose);

if ~isempty(pointcloud)
    for i = 1 : size(pointcloud, 1)
        pointcloud(i, :) = robot_controls.local_to_world_frame(pointcloud(i, :), pose(i, 3), pose(i, 1:2));
    end
end
end

