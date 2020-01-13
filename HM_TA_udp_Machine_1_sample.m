% -----------------------------
% Hochschule München
% Fakultät für Geoinformation
% Thomas Abmayr
% 22.10.2018
% -----------------------------

clear all;
close all;
clc;

%% Define computer-specific variables
% Modify these values to be those of your first computer:
ipA = '10.22.192.105';   portA = 9091;
% Modify these values to be those of your second computer:
ipB = '10.22.192.104';  portB = 9090;
%% Create UDP Object
udpB = udp(ipA,portA, 'LocalPort', 4000);

%% Connect to UDP Object
fclose(udpB)

fopen(udpB);

while (true)
    
    fscanf(udpB)
    fscanf(udpB)
    
end

fclose(udpB)
delete(udpB)
clear ipA portA ipB portB udpB notes



