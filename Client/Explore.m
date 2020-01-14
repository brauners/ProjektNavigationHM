close all;
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
clear all
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');

load('+data\sensorPose.mat')
try
    utils.init_robot('localhost', '8101');
    
    xpositions = [];
    ypositions = [];
    
    wallsx = [];
    wallsy = [];
    
    fig = figure()
    %ph = newplot
    
    % Main control loop. End with Ctrl + C in command line.
    while (true)
        
        % get current robot position
        rx = arrobot_getx
        ry = arrobot_gety
        xpositions = [xpositions; rx];
        ypositions = [ypositions; ry];
        %plot(xpositions, ypositions);
        
        points = robot_controls.get_sensorreadings(sensorPose);
        wallsx = [wallsx; points(:, 1)];
        wallsy = [wallsy; points(:, 2)];
        scatter(wallsx, wallsy, 'b*')
        hold on
        scatter(xpositions, ypositions, 'r*')
        
        arrobot_setvel(150)
        %arrobot_setrotvel(1)
        
        pause(0.3);
    end
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end