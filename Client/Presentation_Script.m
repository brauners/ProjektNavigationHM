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
    
    
    % Main control loop. End with Ctrl + C in command line.
    while (true)
        % Controller Eingaben abfragen
        [trans, rot, button] = utils.get_pad_command(controller);
        fprintf('%.2f, %.2f %s\n', trans, rot, button);
        
        arrobot_setvel(trans)
        arrobot_setrotvel(-rot)
        
        % Roboter Pose abfragen.
        rx = arrobot_getx;
        ry = arrobot_gety;
        th = arrobot_getth;
        
        switch button
            case 'A'
                fprintf('No functionality for %s\n', button);
            case 'B'
                fprintf('No functionality for %s\n', button);
            case 'Y'
                fprintf('No functionality for %s\n', button);
            case 'Start'
                fprintf('No functionality for %s\n', button);
            case 'Back'
                fprintf('No functionality for %s\n', button);
        end
        
        if button == 'X'
            arrobot_stop
            break;
        end
        pause(0.1);
    end
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end

arrobot_stop
arrobot_disconnect