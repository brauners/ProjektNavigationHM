function rrTcpIp = tcp_scan(t)

read = fread(t, t.BytesAvailable);
charArray = char(read');
rrTcpIp = str2double(charArray);

end

