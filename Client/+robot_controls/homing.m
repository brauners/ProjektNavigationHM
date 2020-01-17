function homing ()

%Koordinaten HomingStation
posdocking_x = 10;
posdocking_y = 10;

pos1_x = arrobot_getx();
pos1_y = arrobot_gety();

dist1 =  getDistance(posdocking_x,posdocking_y,pos1_x,pos1_y);
if (dist1 < 3)
    arrobot_setvel(100);
    pause(1);
    arrobot_stop()
    pause(2);
    pos2_x = arrobot_getx();
    pos2_y = arrobot_gety();
    dist2 = getDistance(posdocking_x,posdocking_y, pos2_x,pos2_y);
    [point1, point2 ] =circcirc(pos1_x,pos1_y,dist1, pos2_x, pos2_y, dist2);
    driveToHS(point1(1), point2(1));
    % arrobot_setvel(200);
    % pause(1);
    % arrobot_stop;
    distry = getDistance();
        if (dist2 < distry)
          arrobot_setvel(0);
            driveToP(point1(2), point2(2));
            
        else
            
           arrobot_setvel(0);
              driveToP(point1(1), point2(1));
    
    
        end
        
end

    
% pos3_x = arrobot_getx();
% pos3_y = arrobot_gety();
% dist3 = getDistance(posdocking_x,posdocking_y,pos3_x,pos3_y);


end







