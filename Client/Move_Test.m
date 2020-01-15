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
    % Initialisierung
    utils.init_robot(mode);
    
    
    % Main control loop. End with Ctrl + C in command line.
    target = [1000 0];
    robot_controls.move_to_target(target, sensorPose);
    
    arrobot_disconnect
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end