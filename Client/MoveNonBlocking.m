close all;
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
clear all
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');

mode = "sim";

if mode == "real"
    load('+data\sensorPoseReal.mat')
else
    load('+data\sensorPose.mat')
end

try
    library = NET.addAssembly([pwd '\SharpDX.dll']);
    controllerLibrary = NET.addAssembly([pwd '\SharpDX.XInput.dll']);
 catch ex
     ex.ExceptionObject.LoaderExceptions.Get(0).Message
 end
 
controller = SharpDX.XInput.Controller(SharpDX.XInput.UserIndex.One);

bodyFrame = figure();
worldFrame = figure();


try
    % Initialisierung
    utils.init_robot(mode);
    
    targetBody = [900 900];
    targetReached = false;
    
    state = [true, false];
    
    % Main control loop. End with Ctrl + C in command line.
    while (~targetReached)
        [lx, ly, rx, ry, button] = utils.get_pad_command(controller);
        
        [targetReached, targetBody, targetWorld, state] = robot_controls.move_to_target_nonblocking(targetBody, sensorPose, state);
        
        figure(worldFrame)
        scatter(targetWorld(1), targetWorld(2), '+')
        title('World');
        hold on
        scatter(arrobot_getx, arrobot_gety, 'bo')
        xlim([-2000 2000])
        ylim([-2000 2000])
        
        
        figure(bodyFrame)
        scatter(targetBody(1), targetBody(2), '+')
        title('Body');
        xlim([-2000 2000])
        ylim([-2000 2000])
        %pause(0.1)
        
        
        
        if targetReached || button == "X"
            arrobot_stop
            break,
        end
    end
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end

arrobot_stop
arrobot_disconnect