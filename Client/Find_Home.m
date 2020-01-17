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

body = figure('Name', 'Bodyframe');

world = figure('Name', 'Worldframe');

try
    % Initialisierung
%     utils.init_robot(mode);
    colors = ['b*'; 'g*'; 'r*'; 'y*'; 'b*'; 'g*'; 'r*'; 'y*'; 'b*'; 'g*'; 'r*'; 'y*'];    

    numberOfParticles = 10000;
    particlesBody = utils.init_particle_filter(numberOfParticles);
    particlesWorld = zeros(size(particlesBody, 1), 2);
    
%     figure(body);
    %scatter(particlesBody(:, 1), particlesBody(:, 2), 'b*');
    %hold on
    
    % Home position
    realHomeWorld = [1500 1000];
    %robotPoseWorld = [[0 0 0]; [1000 0 0]; [2000 0 0]; [3000 0 0]];
    robotPoseWorld = [0 0 0];
    robotPoseBody = [0 0 0];
    transBody = [0 0];
    
    
    figure(world);
    scatter(realHomeWorld(1), realHomeWorld(2), 'g*')
    hold on
    
    for i = 1 : 10
        y = transBody(2); x = transBody(1);
        rot = atan2(y, x) * 180/pi;
        %robotPoseBody = robotPoseBody + [transBody(i, :), rot];
        transWorld = robot_controls.local_to_world_frame(transBody, robotPoseWorld(3), [0 0]);
        robotPoseWorld = robotPoseWorld + [transWorld, rot];
        
        measurement = utils.euclidean(realHomeWorld, robotPoseWorld(1:2));
        
        % Calculate the particles in body frame
        [homeBody, particlesBody] = robot_controls.expected_home(particlesBody, measurement, transBody, rot, body);
        
        % Convert to world coordinates
        homeWorld = robot_controls.local_to_world_frame(homeBody, robotPoseWorld(3), robotPoseWorld(1:2));
        for j = 1 : length(particlesBody)
            particlesWorld(j, :) = robot_controls.local_to_world_frame(particlesBody(j, 1:2), robotPoseWorld(3), robotPoseWorld(1:2));
        end
        
        figure(world);
        scatter(particlesWorld(:, 1), particlesWorld(:, 2), colors(i,:));
        utils.plot_circle([robotPoseWorld(1), robotPoseWorld(2)], measurement);
        scatter(robotPoseWorld(1), robotPoseWorld(2))
        scatter(homeWorld(1), homeWorld(2), 'k*');
        scatter(realHomeWorld(1), realHomeWorld(2), 'y+')
        
        
        figure(body);
        scatter(particlesBody(:, 1), particlesBody(:, 2), 'r*');
        axis equal
        hold on
        scatter(homeBody(1), homeBody(2), 'ko')
        
        if i == 1
            transBody = homeBody;
        else
            transBody = homeBody/3;
        end
        input('Press any key to continue....')
    end
    
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end