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

global currentSensorPose;

mode = "sim";

if mode == "real"
    load('+data\sensorPoseReal.mat')
    currentSensorPose = sensorPoseReal;
else
    load('+data\sensorPose.mat')
    currentSensorPose = sensorPose;
end

global particlesBody;
numberOfParticles = 10000;

global transBody;

transBody = [0 0];

worldFigure = figure();
occupancyFigure = figure();


try
    % Initialisierung
    utils.init_robot(mode);
    
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
        %fprintf('%.2f, %.2f %s\n', trans, rot, button);
        
        arrobot_setvel(trans)
        arrobot_setrotvel(-rot)
        
        % Roboter Pose abfragen.
        rx = arrobot_getx;
        ry = arrobot_gety;
        th = arrobot_getth;
        
        xpositions = [xpositions; rx];
        ypositions = [ypositions; ry];
        
        points = robot_controls.get_sensorreadings_worldframe(sensorPose);
        wallsx = [wallsx; points(:, 1)];
        wallsy = [wallsy; points(:, 2)];
        
        switch button
            case 'A'
                fprintf('No functionality for %s\n', button);
                
            case 'B'
                fprintf('No functionality for %s\n', button);
                
            case 'Y'
                % Zeige die aufgenommenen Punkte in plot.
                figure(worldFigure);
                scatter(wallsx, wallsy, 'b*')
                hold on
                scatter(xpositions, ypositions, 'r*')
                figure(occupancyFigure);
                length_points = length(points);
                setOccupancy(map, points/1000+10, ones(length_points,1));
                show(map);
                
            case 'Start'
                fprintf('Start homing...\n')
                arrobot_stop
                pause(1)
                distToHome = utils.get_docking_distance();
                if distToHome < 5001
                    homeReached = false;
                    while ~homeReached && button ~= 'X'
                        [~, ~, button] = utils.get_pad_command(controller);
                        distToHome = utils.get_docking_distance();
                        homeReached = robot_controls.drive_home(distToHome);
                    end
                else
                    fprintf('Kann nicht homen weil nicht in range.\n')
                end
                
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