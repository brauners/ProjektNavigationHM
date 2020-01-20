function [targetReached, targetBody, targetWorld, state] = move_to_target_nonblocking(targetBody, sensorPose, state)
%MOVE_TO_TARGET_NONBLOCKING Moves the robot to a target position relative to current
%position

targetReached = false;

robotPoseStart = arrobot_getpose;
targetWorld = robot_controls.local_to_world_frame(targetBody, robotPoseStart(3), robotPoseStart(1:2))

% Distance to the target
dist = utils.euclidean(targetBody, robotPoseStart(1:2));
% Angle to the target

dt =  (atan2(targetBody(2), targetBody(1)) * (180/3.14159));% - robotPoseStart(3);
dt = mod((dt + 180), 360) - 180;

fprintf('%.2f, %.2f\n', dist, dt);
turning = state(1);
driving = state(2);

if dist > 200
    if abs(dt) > 2
        if driving
            arrobot_stop
            driving = false;
            turning = true;
            pause(1)
        end
        arrobot_setvel(0)
        arrobot_setrotvel(sign(dt)*5)
    else
        if turning
            arrobot_stop
            driving = true;
            turning = false;
            pause(1)
        end
        arrobot_setvel(50)
        arrobot_setrotvel(0)
    end
else
    arrobot_stop
    targetReached = true;
end

pause(0.1)
robotPoseEnd = arrobot_getpose;

deltaPoseWorld = robotPoseEnd - robotPoseStart;
targetWorld = targetWorld - deltaPoseWorld(1:2);

targetBody = world_to_local_frame(targetWorld, robotPoseEnd);

state = [turning, driving];
end

function [pointBody] = world_to_local_frame(point, pose)
%LOCAL_TO_WORLD_FRAME Converts coordinates from local robot frame to world
%frame
% Angle must be in degrees

% Define the rotation matrix
R = [   cosd(-pose(3)) -sind(-pose(3));
        sind(-pose(3))  cosd(-pose(3))];

pointBody = point' - pose(1:2)';
pointBody = R * pointBody;
pointBody = pointBody';
end


