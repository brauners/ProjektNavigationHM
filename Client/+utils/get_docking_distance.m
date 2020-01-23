function [distance] = get_docking_distance(robotPos)
%GET_DOCKING_DISTANCE Summary of this function goes here
%   Detailed explanation goes here

% global u;
% fopen(u);
% 
% global t;
% fopen(t);
% robotPos
% fwrite(t, robotPos, 'double')

distance = euclidean([0 0], robotPos);



% fclose(t);
% fclose(u);

end

function [dist] = euclidean(left, right)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dist = sqrt((left(1) - right(1))^2 + (left(2) - right(2))^2);
end