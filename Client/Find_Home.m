% -----------------------------
% Hochschule München
% Fakultät für Geoinformation
% Andre Braunersreuther
% 16.01.2020
% -----------------------------

% Script zur simulierten Berechnung der Home position mit Hilfe des
% Partikelfilters
% Eine Dockingstation wird auf der Position (0, 0) angenommen.
% Die Startposition des Roboters ist (1.5, 1) im world frame in metern.
% Als bespielhafte Bewegung des Roboters wird nach jeder Iteration 1/3 der 
% Strecke in Richtung der berechneten home Position zurückgelegt.

body = figure('Name', 'Bodyframe');

world = figure('Name', 'Worldframe');


colors = ['b*'; 'g*'; 'r*'; 'y*'; 'b*'; 'g*'; 'r*'; 'y*'; 'b*'; 'g*'; 'r*'; 'y*'];    

numberOfParticles = 10000;
particlesBody = utils.init_particle_filter(numberOfParticles);
particlesWorld = zeros(size(particlesBody, 1), 2);

% Home position
realHomeWorld = [1500 0];
robotPoseWorld = [0 0 0];
robotPoseBody = [0 0 0];
transBody = [0 0];


figure(world);
scatter(realHomeWorld(1), realHomeWorld(2), 'g*')
hold on

for i = 1 : 4
    y = transBody(2); x = transBody(1);
    rot = atan2(y, x) * 180/pi;
    transWorld = robot_controls.local_to_world_frame(transBody, robotPoseWorld(3), [0 0]);
    robotPoseWorld = robotPoseWorld + [transWorld, rot];

    measurement = utils.euclidean(realHomeWorld, robotPoseWorld(1:2));
    
    % Calculate the particles in body frame
    [homeBody, particlesBody] = robot_controls.expected_home(particlesBody, measurement, transBody, rot);

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
    title('Estimated home position in world frame')
    xlabel('X-Coordinate in mm');
    ylabel('Y-Coordinate in mm');


    figure(body);
    scatter(particlesBody(:, 1), particlesBody(:, 2), 'r*');
    axis equal
    hold on
    scatter(homeBody(1), homeBody(2), 'ko')

    if i == 1
        transBody = homeBody/2;
    else
        transBody = homeBody/3;
    end
    input('Press any key to continue....')
end