u = udp('127.0.0.1', 4000);

fopen(u);

in = '';

while string(in) ~= string('q')
    in = input('Data to be sent\n', 's')
    fwrite(u, in);
    disp(in)
end

fclose(u);