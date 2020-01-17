% close all;
% addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');
% clear all
% addpath('..\..\ARIA_2.9.1 (64-bit)_matlab_precompiled');

load('+data\sensorPose.mat')
try
%     % Initialisierung
%     utils.init_robot('localhost', '8101');
    
   % Accept a connection 
    disp ('Dockingstation starten..');
    t = tcpip('localhost', 8101,'NetworkRole', 'server');

%wird solang angezeigt, bis Verbindung steht
disp('Warten auf Verbindung..');

%Open a connection.
fopen(t);
disp('Verbindung wurde aufgestellt..');

pause(1)

%muss 1 liefern, damit wir eine Verbindung haben
while(strcmp(t.status, 'open') == 1)
    
    if(t.BytesAvailable ~= 0)
        data = fread(t,t.BytesAvailable);
        plot(data)
        chararray = char(data');
        
        if(data == 1)
            disp('Keine Verbindung');
            break;
              
        else
            coord = strsplit(chararray,',');
            x = str2double(coord(1,1));
            y = str2double(coord(1,2));
        end
        
        c = (sqrt(x^2 + y^2)/1000);
        
        if(c < 3)
            disp('Der Sensor ist in der Nähe von der Dockingstation.');
            
            fprintf(t,num2str(c));
        else
            disp('Der Sensor ist weit weg von der Dockingstation.');
        end        
    end
end
   
    
% catch err
%     disp 'error or cancelled'
%     disp(err)
%     arrobot_stop
%     arrobot_disconnect
end