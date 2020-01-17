function [point_world] = local_to_world_frame(point, angle, trans)
%LOCAL_TO_WORLD_FRAME Converts coordinates from local robot frame to world
%frame
% Angle must be in degrees

% Define the rotation matrix
R = [   cosd(angle) -sind(angle);
        sind(angle)  cosd(angle)];

point_world = (R * point' + trans');

point_world = point_world';
end

