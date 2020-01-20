u = udp('192.168.137.28', 4000);

fopen(u);

data = '';

while string(data) ~= string('q')
    fprintf('Waiting for data\n');
    if get(u, 'ValuesReceived') > 0
        data = fread(u);
        fprintf('Data incoming...\n');
        disp(data)
    end
end

fclose(u);