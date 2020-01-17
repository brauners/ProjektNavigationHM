close all;
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
clear all
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');

load('+data\sensorPose.mat')
map = robotics.BinaryOccupancyGrid(20, 30, 10);

try
    utils.init_robot('localhost', '8101');
    
    xpositions = [];
    ypositions = [];
    
    wallsx = [];
    wallsy = [];
    
    fig = figure()
    %ph = newplot
    
    %Write KO from Robot into MapData
    file = fopen('MapData.txt', 'w');
    % Main control loop. End with Ctrl + C in command line.
    while (true)
        
        % get current robot position
        rx = arrobot_getx
        ry = arrobot_gety
        xpositions = [xpositions; rx];
        ypositions = [ypositions; ry];
        %plot(xpositions, ypositions);
        
        points = robot_controls.get_sensorreadings(sensorPose);
       pl = length(points);
        setOccupancy(map, points/1000+10, ones(pl,1));
        subplot(2,1,1);
        show(map)
      
        wallsx = [wallsx; points(:, 1)];
        wallsy = [wallsy; points(:, 2)];
        subplot(2,1,2);
        scatter(wallsx, wallsy, 'b*')
        hold on
        scatter(xpositions, ypositions, 'r*')
        arrobot_setvel(150)
        fprintf(file, '%.4f %.4f\n', rx, ry);
        pause(0.3);
        save('testAsci.txt','points', '-ascii');
    end
    
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end