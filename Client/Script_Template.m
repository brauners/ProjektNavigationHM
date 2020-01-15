close all;
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
clear all
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');

load('+data\sensorPose.mat')
try
    % Initialisierung
    utils.init_robot('localhost', '8101');
    
    
    % Main control loop. End with Ctrl + C in command line.
    while (true)
        
        % Kontinuierlicher Code hier
        arrobot_setvel(150)

        
        
        pause(0.3);
    end
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end