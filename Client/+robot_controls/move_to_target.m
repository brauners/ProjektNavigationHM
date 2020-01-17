function [targetReached] = move_to_target(target, sensorPose)
%MOVE_TO_TARGET Moves the robot to a target position relative to current
%position

disp('start moving')

velMult = 0.5
distThresh = 35 % mm
angleThresh = 2 % deg

targetReached = false;

[startX startY startT] = arrobot_getpose;
px = target(1);
py = target(2);


while(~targetReached)
    collision = robot_controls.collision_detection(300, sensorPose)
    if collision
        arrobot_stop
        targetReached = false;
        break;
    end
    %Move forward to the target but check if angle gets off
    rx = arrobot_getx - startX;
    ry = arrobot_gety - startY;
    d = sqrt( (px - rx)^2 + (py - ry)^2 );
    %Calculate angle to target
    rt = arrobot_getth - startT;
    dt =  (atan2(py - ry, px - rx) * (180/3.14159)) - rt;
    dt = mod((dt + 180), 360) - 180;
    
    %Turn towards the target if over threshold
    if abs(dt) > angleThresh
        arrobot_stop
        pause(0.2) %Give time to stop the motion
        disp('angle off')
        while abs(dt) > angleThresh
            arrobot_setrotvel(sign(dt)*10)
            %Update value
            rt = arrobot_getth - startT;
            dt =  (atan2(py - ry, px - rx) * (180/3.14159)) - rt;
            dt = mod((dt + 180), 360) - 180
        end
        disp('angle reached')
        arrobot_stop
        pause(0.2)
    else
        if abs(d) > distThresh
            disp('moving')
            arrobot_setvel(d*velMult)
        else
            disp('stop')
            arrobot_stop
            targetReached = true;
        end
    end
    
end
end

