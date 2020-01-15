function [pointcloud] = get_sensorreadings(sensorPose)
%GET_SENSORREADINGS Reads the sonar sensor and returns a pointcloud of
%detected objects around the robot in body coordinate system of the robot
%Unit is in mm

n = length(sensorPose);

pointcloud = [];
sensor_values = zeros(n, 1);

% Read each sensor measurement
for i = 1 : n
    val = arrobot_getsonarrange(i-1);
    if val ~= 5000
        % Read estimated robot position
        rx = arrobot_getx;
        ry = arrobot_gety;
        th = arrobot_getth;
        
        [x, y] = koppel(rx, ry, th, val, sensorPose(i, 3));
        % Apply correct position of the sensor
        x = x + sensorPose(i, 1)*1000;
        y = y + sensorPose(i, 2)*1000;
        pointcloud = [pointcloud; [x, y]];
    end
end
end

function [x, y] = koppel(posx, posy, theta, dist, angle)
x = posx + dist * cosd(angle+theta);
y = posy + dist * sind(angle+theta);
end


