function init_robot(mode)
%INIT_ROBOT Prepares the connection to the "hardware" of the robot
% Make sure there is no connection
arrobot_disconnect
pause(0.5)
% Initialize connection

aria_shutdown

if mode == "real"
    aria_init -rp COM3
else
    aria_init
end
pause(0.5)
% Make connection
 connected = arrobot_connect();
 
 if ~connected
     ME = MException('MyComponent:noRobotConnection', 'No connection to robot possible. Check if running');
     throw(ME)
 end

pause(0.5)
% Reset estimated pose
arrobot_resetpos()
end
