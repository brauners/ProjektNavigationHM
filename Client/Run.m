close all;
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
clear all
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');

try
    library = NET.addAssembly([pwd '\SharpDX.dll']);
    controllerLibrary = NET.addAssembly([pwd '\SharpDX.XInput.dll']);
 catch ex
     ex.ExceptionObject.LoaderExceptions.Get(0).Message
 end
 
controller = SharpDX.XInput.Controller(SharpDX.XInput.UserIndex.One);



mode = "sim";

if mode == "real"
    load('+data\sensorPoseReal.mat')
else
    load('+data\sensorPose.mat')
end

try
    % Initialisierung
    utils.init_robot(mode);
    
    xpositions = [];
    ypositions = [];
    
    wallsx = [];
    wallsy = [];
    
    stepSize = 500;
    
    fig = figure()
    command = ' ';
    
    while command ~= 'q'
        command = input('Enter control command\n', 's');
        switch command
            case '8'
                target = [stepSize 0];
                robot_controls.move_to_target(target, sensorPose);
            case '2'
                target = [0 0];
                robot_controls.move_to_target(target, sensorPose);
            case '4'
                target = [stepSize stepSize];
                robot_controls.move_to_target(target, sensorPose);
            case '6'
                target = [stepSize -stepSize];
                robot_controls.move_to_target(target, sensorPose);
            case '5'
                arrobot_stop
            case 'i'
                [x, y, th] = arrobot_getpose
            case 'm'
                pointcloud = robot_controls.get_sensorreadings_worldframe(sensorPose);
            case 'p'
                pointcloud = utils.pad_control(controller, sensorPose);
                %scatter(pointcloud(:, 1), pointcloud(:, 2), 'b*')
            case 'j'
                while true
                    State = myController.GetState();
                    left = double(State.Gamepad.LeftTrigger);
                    right = double(State.Gamepad.RightTrigger);
                    arrobot_setvels(left, right);
                end
            case 'q'
                disp('Quitting...');
                arrobot_disconnect
            otherwise
                disp('Wrong input');
        end
        
        
%         % get current robot position
%         rx = arrobot_getx;
%         ry = arrobot_gety;
%         xpositions = [xpositions; rx];
%         ypositions = [ypositions; ry];
%         %plot(xpositions, ypositions);
%         
%         points = robot_controls.get_sensorreadings(sensorPose);
%         wallsx = [wallsx; points(:, 1)];
%         wallsy = [wallsy; points(:, 2)];
%         scatter(wallsx, wallsy, 'b*')
%         hold on
%         scatter(xpositions, ypositions, 'r*')

    end
    
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end