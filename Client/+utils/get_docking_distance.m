function [distance] = get_docking_distance(robotPos)
%GET_DOCKING_DISTANCE Summary of this function goes here
%   Detailed explanation goes here

global u;

distance = -1;
num = u.BytesAvailable();
if num == 2
    data = fread(u, num);
    tmp = euclidean(data, robotPos);
    if tmp < 5000
        distance = tmp;
    end
else
%     flushinput(u);
end


end

function [dist] = euclidean(left, right)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dist = sqrt((left(1) - right(1))^2 + (left(2) - right(2))^2);
end