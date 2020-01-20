u = udp('192.168.137.175', 4000);

fopen(u);

in = '';

while true
    fprintf('Sending...\n');
    fwrite(u, [0 20]);
    pause(2);
end

fclose(u);