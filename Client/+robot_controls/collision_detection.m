function [collision, angle] = collision_detection(threshold, sensorPose)
%COLLISION_DETECTION Durchläuft alle Sensoren und checkt ob kleiner als
%gegebener Schwellenwert.
% Threshold/Schwelle wird in mm angegeben

global player

n = length(sensorPose);
collision = false;

% Read each sensor measurement
for i = 1 : n
    val = arrobot_getsonarrange(i-1);
    %Wenn Messwert kleiner als zugelassener Wert, dann Kollision
    if val < threshold 
        collision = true;
        angle = sensorPose(i,3);
        fprintf("Achtung Kollisionsgefahr!!! Distanz: %.2f, Winkel: %.2f\n", val, angle);
        break;
    end
end

% Auditive Signalisierung 
if collision
    if ~isplaying(player)
        play(player);
    end
end
end


