%% Lade die Bibliothek zur Verbindung mir dem Roboter
close all;
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
clear all
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');

%% Lade die Bibliothek zur Verbindung zum Gamepad
try
    library = NET.addAssembly([pwd '\SharpDX.dll']);
    controllerLibrary = NET.addAssembly([pwd '\SharpDX.XInput.dll']);
 catch ex
     ex.ExceptionObject.LoaderExceptions.Get(0).Message
end
 
%% Initialisiere Variablen die global benötigt werden
[y, Fs] = audioread('..\Resourcen\collision.m4a');
global player;
player = audioplayer(y,Fs);

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

global collThresh
collThresh = 300;

transBody = [0 0];

%% Benötigte Variablen zur Darstellung
worldFigure = figure();
occupancyFigure = figure();

filename = '..\Resourcen\video.avi'
writer = VideoWriter(filename);
writer.FrameRate = 4;

% input('Start script with enter...')
try
    %% Initialisierung des Roboters abhängig vom Modus (Real - Simulation)
    utils.init_robot(mode);
    
    %% Gamepad zur Steuerung
    controller = SharpDX.XInput.Controller(SharpDX.XInput.UserIndex.One);
    
    %% Vorbereitung weiterer beötigter Variablen
    recOn = false;
    
    xpositions = [];
    ypositions = [];
    
    wallsx = [];
    wallsy = [];
    
    map = robotics.BinaryOccupancyGrid(30, 20, 10);
    
    particlesBody = utils.init_particle_filter(numberOfParticles);
    
    fprintf('Script started. Commands with controller. -> left stick\n');
    %% Hauptkontrollschleife. Beende mit X auf dem Gamepad
    while (true)
        %% Controller Eingaben abfragen
        [trans, rot, button] = utils.get_pad_command(controller);
        fprintf('%.2f, %.2f %s\n', trans, rot, button);
        
        if button == 'RightShoulder'
            trans = trans*2;
        end
        
        %% Setze Bewegungsbefehle
        arrobot_setvel(trans)
        arrobot_setrotvel(-rot)
        
        %% Kontrolliere auf Kollisionsgefahr
        collision = robot_controls.collision_detection(collThresh, currentSensorPose);
        if collision && button ~= 'Back'
            arrobot_stop
        end
        
        %% Roboter Pose abfragen.
        rx = arrobot_getx;
        ry = arrobot_gety;
        th = arrobot_getth;
        
        %% Lese die Sensoren und setze Objekte in Karte
        points = robot_controls.get_sensorreadings_worldframe(currentSensorPose);
        
        if ~isempty(points)
            wallsx = [wallsx; points(:, 1)];
            wallsy = [wallsy; points(:, 2)];
        end
        
        xpositions = [xpositions; rx];
        ypositions = [ypositions; ry];
        
        %% Darstellung der Karte
        figure(worldFigure);
        scatter(wallsx/1000, wallsy/1000, 'b*')
        hold on
        scatter(xpositions/1000, ypositions/1000, 'r*')
        title('Detected obstacles in world frame')
        xlabel('Y-Coordinate [m]')
        ylabel('X-Coordinate [m]')
        
        %% Darstellung des Occupancy Grids
        if ~isempty(points)
            figure(occupancyFigure);
            length_points = length(points);
            points_meter = points/1000;
            setOccupancy(map, points_meter, ones(length_points,1));
            show(map);
        end
        
        %% Möglichkeit zum Aufnehmen der aktuellen Karte in einem Video
        if recOn
            figure(worldFigure);
            frame = getframe(gcf);
            writeVideo(writer, frame);
        end
        
        %% Verarbeite zusätzliche Eingaben am Gamepad
        switch button
            case 'A'
                fprintf('No functionality for %s\n', button);
                distToHome = utils.get_docking_distance([rx ry])
                
            case 'B'
                fprintf('No functionality for %s\n', button);
                input('Paused. Continue with Enter')
                
            case 'Y'
                % Toggle recording
                if recOn
                    fprintf('Recording ended...\n');
                    recOn = false;
                    close(writer);
                else
                    fprintf('Recording started...\n');
                    recOn = true;
                    open(writer);
                end
                
                
            case 'Start'
                fprintf('Start homing...\n')
                arrobot_stop
                pause(1)
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
                
            % Starte Bewegung zu Zielpunkt
            case 'DPadUp'
                target = [2000 0];
                robot_controls.move_to_target(target, sensorPose);

            case 'DPadLeft'
%                 fprintf('No functionality for %s\n', button);
                target = [1000 1000];
                robot_controls.move_to_target(target, sensorPose);
                
            case 'DPadRight'
%                 fprintf('No functionality for %s\n', button);
                target = [1000 -1000];
                robot_controls.move_to_target(target, sensorPose);
                
        end
        
        % Beende die Kontrollschleife
        if button == 'X'
            arrobot_stop
            break;
        end
        pause(0.1);
    end
    
catch err
    %% Beende die Verbindung falls ein Fehler auftritt
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
    
end

%% Beende die Verbindung falls Abbruch durch Benutzer
arrobot_stop
arrobot_disconnect

%% Aufgerufene eigene Funktionen
%% init_robot
%% init_particle_filter
%% get_pad_command
%% collision_detection
%% get_sensorreadings_worldframe
%% get_docking_distance
%% move_to_target