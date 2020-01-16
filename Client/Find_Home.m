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

body = figure();

world = figure();

try
    % Initialisierung
%     utils.init_robot(mode);
    colors = ['b*'; 'g*'; 'r*'; 'y*'];    

    numberOfParticles = 1000;
    particles = utils.init_particle_filter(numberOfParticles);
    
    figure(body);
    scatter(particles(:, 2), particles(:, 1), 'b*');
    hold on
    
    % Home position
    realHomeWorld = [1500 1000];
    robotPoseWorld = [[0 0 0]; [500 0 0]; [1000 0 0]; [1500 0 0]];
    transBody = [[500, 0]; [500, 0]; [500, 0]]; rot = [0; 0; 0];
    
    
    figure(world);
    scatter(realHomeWorld(1), realHomeWorld(2), 'g*')
    hold on
    
    for i = 1 : length(robotPoseWorld)
        figure(world);
        scatter(robotPoseWorld(i, 1), robotPoseWorld(i, 2), 'r*')
        measurement = utils.euclidean(realHomeWorld, robotPoseWorld(i, 1:2));
        
        [homeBody, particles] = robot_controls.expected_home(particles, measurement, transBody(i, :), rot(i));
        figure(world);
        scatter(homeBody(1), homeBody(2), 'b*')
        
        figure(body)
        scatter(particles(:, 2), particles(:, 1), colors(i,:));
    end
    
    
    
    
    
    
    
    scatter(particles(:, 1), particles(:, 2), 'r*');
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end