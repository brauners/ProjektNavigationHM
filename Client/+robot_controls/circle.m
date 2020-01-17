function circle(rx, ry, dis)

%dis == radius

ang = 0:0.1:2*pi;
xp = dis*cos(ang);
yp = dis*sin(ang);
plot (x + xp, y+ yp);

end

