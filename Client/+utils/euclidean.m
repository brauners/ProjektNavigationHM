function [dist] = euclidean(left, right)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dist = sqrt((left(1) - right(1))^2 + (left(2) - right(2))^2);
end

