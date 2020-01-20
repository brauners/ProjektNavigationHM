u = udp('192.168.137.28', 4000);

fopen(u);

in = '';

while string(in) ~= string('q')
    in = input('Data to be sent\n', 's')
    fwrite(u, string(in));
    disp(in)
end

fclose(u);