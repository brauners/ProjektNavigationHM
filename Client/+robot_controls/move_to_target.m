function [targetReached] = move_to_target(target, sensorPose)
%MOVE_TO_TARGET Moves the robot to a target position relative to current
%position

disp('start moving')

velMult = 0.4
distThresh = 100 % mm
angleThresh = 5 % deg

targetReached = false;

[startX startY startT] = arrobot_getpose;
px = target(1);
py = target(2);

dts = [];8
subplot(2,1,2)
scatter(px, py, 'r*')
hold on

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
    subplot(2,1,2)
    scatter(rx, ry, 'b*')
    pause(0.2)
    
    d = sqrt( (px - rx)^2 + (py - ry)^2 );
    %Calculate angle to target
    rt = arrobot_getth - startT;
    dt =  (atan2(py - ry, px - rx) * (180/3.14159)) - rt;
    dt = mod((dt + 180), 360) - 180;
    dts = [dts; dt];
    subplot(2,1,1);
    plot(dts)
    
    %Turn towards the target if over threshold
    if abs(dt) > angleThresh
        arrobot_stop
        pause(0.4) %Give time to stop the motion
        disp('angle off')
        while abs(dt) > angleThresh
            arrobot_setrotvel(sign(dt)*10)
            %Update value
            rt = arrobot_getth - startT;
            dt =  (atan2(py - ry, px - rx) * (180/3.14159)) - rt;
            dt = mod((dt + 180), 360) - 180
            dts = [dts; dt];
            subplot(2,1,1);
            plot(dts)
            pause(0.05)
        end
        disp('angle reached')
        arrobot_stop
        pause(0.4)
    else
        if abs(d) > distThresh
            fprintf('%.2f  %.2f; d: %.2f\n', rx, ry, d);
            %arrobot_setvel(d*velMult)
            arrobot_setvel(80)
        else
            disp('stop')
            arrobot_stop
            targetReached = true;
        end
        %pause(0.2)
    end
    pause(0.1)
end
end

