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
 

global currentSensorPose;

mode = "real";

if mode == "real"
    load('+data\sensorPoseReal.mat')
    currentSensorPose = sensorPose;
else
    load('+data\sensorPose.mat')
    currentSensorPose = sensorPose;
end

global particlesBody;
numberOfParticles = 10000;

global transBody;

transBody = [0 0];

% remoteHost = '192.168.137.1';
% 
% % global u;
% % u = udp(remoteHost,'LocalPort', 4000);
% global t;
% t = tcpip('192.168.137.1', 3001, 'LocalHost', '192.168.137.175', 'LocalPort', 3000, 'NetworkRole', 'client');

worldFigure = figure();
occupancyFigure = figure();

filename = '..\Resourcen\video.avi'
writer = VideoWriter(filename);
writer.FrameRate = 4;


try
    % Initialisierung
    utils.init_robot(mode);
    
    controller = SharpDX.XInput.Controller(SharpDX.XInput.UserIndex.One);
    
    recOn = false;
    
    xpositions = [];
    ypositions = [];
    
    wallsx = [];
    wallsy = [];
    
    map = robotics.BinaryOccupancyGrid(30, 20, 10);
    
    particlesBody = utils.init_particle_filter(numberOfParticles);
    
    fprintf('Script started. Commands with controller. -> left stick\n');
    % Main control loop. End with Ctrl + C in command line.
    while (true)
        % Controller Eingaben abfragen
        [trans, rot, button] = utils.get_pad_command(controller);
        fprintf('%.2f, %.2f %s\n', trans, rot, button);
        
        arrobot_setvel(trans)
        arrobot_setrotvel(-rot)
        
        collision = robot_controls.collision_detection(50, currentSensorPose);
        if collision && button ~= 'Back'
            arrobot_stop
        end
        
        % Roboter Pose abfragen.
        rx = arrobot_getx;
        ry = arrobot_gety;
        th = arrobot_getth;
        
        xpositions = [xpositions; rx];
        ypositions = [ypositions; ry];
        
%         points = robot_controls.get_sensorreadings_worldframe(sensorPose);
%         wallsx = [wallsx; points(:, 1)];
%         wallsy = [wallsy; points(:, 2)];
        
        
        % Zeige die aufgenommenen Punkte in plot.
        figure(worldFigure);
        scatter(wallsx/1000, wallsy/1000, 'b*')
        hold on
        scatter(xpositions/1000, ypositions/1000, 'r*')
        title('Detected obstacles in world frame')
        xlabel('Y-Coordinate [m]')
        ylabel('X-Coordinate [m]')
        
        figure(occupancyFigure);
        length_points = length(points);
        points_meter = points/1000;
        setOccupancy(map, points_meter, ones(length_points,1));
        show(map);
        
%         if recOn
%             figure(worldFigure);
%             frame = getframe(gcf);
%             writeVideo(writer, frame);
%         end
        
        switch button
            case 'A'
                fprintf('No functionality for %s\n', button);
                distToHome = utils.get_docking_distance([rx ry])
                
            case 'B'
                fprintf('No functionality for %s\n', button);
                input('Paused. Continue with Enter')
                
            case 'Y'
%                 if recOn
%                     fprintf('Recording ended...\n');
%                     recOn = false;
%                     close(writer);
%                 else
%                     fprintf('Recording started...\n');
%                     recOn = true;
%                     open(writer);
%                 end
                
                
            case 'Start'
                fprintf('Start homing...\n')
                arrobot_stop
                pause(1)
%                 distToHome = utils.get_docking_distance([rx ry]);
                if distToHome < 5001
                    homeReached = false;
                    while ~homeReached && button ~= 'X'
                        [~, ~, button] = utils.get_pad_command(controller);
                        rx = arrobot_getx;
                        ry = arrobot_gety;
                        distToHome = utils.get_docking_distance([rx ry]);
                        homeReached = robot_controls.drive_home(distToHome);
                    end
                else
                    fprintf('Kann nicht homen weil nicht in range.\n')
                end
                
            case 'DPadUp'
%                 fprintf('No functionality for %s\n', button);
                target = [1000 0];
                robot_controls.move_to_target(target, sensorPose);
                
            case 'DPadDown'
                fprintf('No functionality for %s\n', button);
                
                
            case 'DPadLeft'
%                 fprintf('No functionality for %s\n', button);
                target = [1000 1000];
                robot_controls.move_to_target(target, sensorPose);
                
            case 'DPadRight'
%                 fprintf('No functionality for %s\n', button);
                target = [1000 -1000];
                robot_controls.move_to_target(target, sensorPose);
                
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