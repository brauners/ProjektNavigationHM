function [pointcloud] = pad_control(controller, sensorPose)
%PAD_CONTROL Starts the control over a gamepad, collects a map and returns
%the pointcloud collected during this control

%   Load the library necessary
% controllerLibrary = NET.addAssembly([pwd '\SharpDX.XInput.dll']);
% myController = SharpDX.XInput.Controller(SharpDX.XInput.UserIndex.One);
pointcloudx = [];
pointcloudy = [];

while true
    [trans, rot, stop] = get_pad_command(controller);
    arrobot_setvel(trans)
    arrobot_setrotvel(-rot)
    
    points = robot_controls.get_sensorreadings(sensorPose);
    pointcloudx = [pointcloudx; points(:, 1)];
    pointcloudy = [pointcloudy; points(:, 2)];
    scatter(pointcloudx, pointcloudy, 'b*')

    fprintf('%.2f\t %.2f\t\n', trans, rot);
    
    if stop == 'X'
        arrobot_stop
        break;
    end
    
    pause(.1);
end

pointcloud = [pointcloudx, pointcloudy];
end

function [trans, rot, button] = get_pad_command(controller)
State = controller.GetState();
deadzone = State.Gamepad.LeftThumbDeadZone;

trans = State.Gamepad.LeftThumbY;
trans = double(mapping(trans, deadzone, 50));

rot = State.Gamepad.LeftThumbX;
rot = double(mapping(rot, deadzone, 800));

button = State.Gamepad.Buttons.ToString;

end

function val = mapping(input, deadzone, devisor)
val = 0;
if abs(input) > deadzone
    val = input;
    val = val/devisor;
end
end
