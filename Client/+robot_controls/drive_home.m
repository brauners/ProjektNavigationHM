function [homeReached] = drive_home(measurement)
%DRIVE_HOME Tries to drive home. returns false if not possible
%   Detailed explanation goes here
homeReached = false;

global particlesBody;
global transBody;
global currentSensorPose;

y = transBody(2); x = transBody(1);
rot = atan2(y, x) * 180/pi;

% Calculate the particles in body frame
[homeBody, particlesBody] = robot_controls.expected_home(particlesBody, measurement, transBody, rot);

transBody = homeBody/3;

[targetReached] = robot_controls.move_to_target(transBody, currentSensorPose);

end

