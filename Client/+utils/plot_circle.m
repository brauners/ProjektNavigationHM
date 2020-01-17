function plot_circle(center, radius)
%CIRCLE Summary of this function goes here
%   Detailed explanation goes here
%// radius
r = radius;

%// center
c = center;

pos = [c-r 2*r 2*r];
rectangle('Position',pos,'Curvature',[1 1])
axis equal
end

