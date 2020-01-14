function [collision] = collision_detection(threshold, sensorPose)
%COLLISION_DETECTION Summary of this function goes here
%   Detailed explanation goes here
n = arrobot_getnumsonar;
n_input = length(sensorPose);
if n ~= n_input
    ME = MException('MATLAB:odearguments:InconsistentDataType', 'Wrong sensor definition');
    throw(ME)
end
collision = false;

% Read each sensor measurement
for i = 1 : n
    val = arrobot_getsonarrange(i-1);
    if val < threshold
        collision = true;
        arrobot_stop
        arrobot_disable_motors
        break;
    end
end
end


