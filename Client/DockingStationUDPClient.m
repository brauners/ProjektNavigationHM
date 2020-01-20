remoteHost = '192.168.137.248';

global u;
u = udp(remoteHost,'LocalPort', 4000);

fopen(u);

data = '';

while data ~= string('q')
    dist = utils.get_docking_distance([0 0]);
    if dist ~= -1
        disp(dist);
    end
end

fclose(u);