u = udp('127.0.0.1', 4000);

fopen(u);

data = '';

while string(data) ~= string('q')
    fprintf('Waiting for data\n');
    data = fread(u);
    fprintf('Data incoming...\n');
    disp(data)
end

fclose(u);