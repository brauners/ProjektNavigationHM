function init_robot(ip, port)
%INIT_ROBOT Prepares the connection to the "hardware" of the robot
% Make sure there is no connection
arrobot_disconnect
pause(0.5)
% Initialize connection
aria_init(['-rh' ip '-rrtp' port])
pause(0.5)
% Make connection
arrobot_connect()
pause(0.5)
% Reset estimated pose
arrobot_resetpos()
end

