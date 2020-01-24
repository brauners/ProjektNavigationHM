% -------------------------------------------------------------------
% Adept MobileRobots Robotics Interface for Applications (ARIA)
% Copyright (C) 2004-2005 ActivMedia Robotics LLC
% Copyright (C) 2006-2010 MobileRobots Inc.
% Copyright (C) 2011-2014 Adept Technology
% -------------------------------------------------------------------
% mod by T. Abmayr Jan. 2016
% -------------------------------------------------------------------

clear all;
close all;

ver

%% Aria Pfad und Neustart
% ==> notwendiger work around
% pfad hinzufügen
addpath('C:\Users\Sysadmin\Desktop\PS2020\ARIA_2.9.1 (64-bit)_matlab_precompiled');

% disconnet robot
arrobot_disconnect
% nochmals clear notwendig
clear all
% pfad hinzufügen
addpath('C:\Users\Sysadmin\Desktop\PS2020\ARIA_2.9.1 (64-bit)_matlab_precompiled');
% <==

%% connect to the robot:
aria_init -rh localhost  -rrtp 8101
arrobot_connect


%% make the robot drive in a small circle:
% arrobot_setvel(300)
% arrobot_setrotvel(35)



%%Aktuelle Postition des Roboters abfragen
x = arrobot_getx();
y = arrobot_gety();


%% Position abfragen
figure(1);
for i=1:10
    x = arrobot_getx();
    y = arrobot_gety();
    hold on;
    plot(x, y, '*')
    pause(0.5);
end






%% simple Steuerung
 while (true)
reply = input('Enter control command \r\n', 's');
 switch reply
     
     %%Vorwärts
     case 'w'         % i
         arrobot_setvel(800);
         pause(3);
         arrobot_stop;
         
     %%Rückwärts    
     case 's'
         arrobot_setvel(-500);
         pause(1);
         arrobot_stop;
       
     %%Links    
     case 'a'
         arrobot_setdeltaheading(90);
            pause(1.5);
     %%Rechts    
     case 'd'
         arrobot_setdeltaheading(-90);
            pause(1);
        
     case 'q'
         arrobot_stop;
            pause(1);
         
     case 'c'
         t = false;
     case 'p'
         figure(2);
         show(map)
         hold on;
         
     case 'x'
         arrobot_stop;
%          goHome
         
     case 'y'
         break;
         
    
 end
end
%  counter = counter+1;

%% pause und disconnect
pause(2);
arrobot_disconnect
