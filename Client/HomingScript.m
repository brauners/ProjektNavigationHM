close all;

addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
clear all
addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
 %Koordinaten HomingStation
    posdocking_x = 23.406;
    posdocking_y = 11.794;
    

load('+data\sensorPose.mat')
try
    % Initialisierung
   utils.init_robot('localhost', '8101');
   rx = 18.24;
   ry = 11.70;
 
  pos1_x = arrobot_getx()
  pos1_y = arrobot_gety()
    
    

%     [x1,y1] = arrobot_getpose;
     
   
    % Main control loop. End with Ctrl + C in command line.
    while (true)
        
   % Kontinuierlicher Code hier

dist1 =  getDistance(posdocking_x,posdocking_y,x1,y1)
if (dist1 < 3)
    arrobot_setvel(150);
    arrobot_stop()
    pause(2);
    pos2_x = arrobot_getx()
    pos2_y = arrobot_gety()
[x2,y2] = arrobot_getpose;
    dist2 = getDistance(posdocking_x,posdocking_y, x2,y2)
    [point1, point2 ] =circcirc(x1, y1 ,dist1, x2, y2, dist2)    
    driveToHS(point1(1), point2(1));
    arrobot_setvel(200);
    pause(1);
    arrobot_stop;
    distry = getDistance();
        if (dist2 < distry)
          arrobot_setvel(0);
            driveToP(point1(2), point2(2));
    
        else
           arrobot_setvel(0);
              driveToP(point1(1), point2(1));
    
    
         end
end
 
    end 
    
catch err
    disp 'error or cancelled'
    disp(err)
    arrobot_stop
    arrobot_disconnect
end


   




