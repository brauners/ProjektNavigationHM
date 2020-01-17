function connectDocking(ip,port)


%Baut eine Verbindung zur DockingStation her
global t

t = tcpip(ip,port,'NetworkRole','client');

fopen(t);

end

