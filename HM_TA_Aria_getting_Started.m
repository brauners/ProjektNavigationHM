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
addpath('C:\HM\prj\MobileRobots\ARIA_2.9.1 (64-bit)_matlab_precompiled');

% disconnet robot
arrobot_disconnect
% nochmals clear notwendig
clear all
% pfad hinzufügen
addpath('C:\HM\prj\MobileRobots\ARIA_2.9.1 (64-bit)_matlab_precompiled');
% <==

%% connect to the robot:
aria_init -rh 10.22.192.161  -rrtp 8102
arrobot_connect


%% make the robot drive in a small circle:
arrobot_setvel(300)
arrobot_setrotvel(35)

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
% reply = input('Enter control command \r\n', 's');
% switch reply
%     case 'i'         % i
%         break;
% end

%% pause und disconnect
pause(2);
arrobot_disconnect
