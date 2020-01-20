
 % Accept a connection 
disp ('Dockingstation starten..')
echocpip('on',4000)
t = tcpip('localhost', 4000);

%wird solang angezeigt, bis Verbindung steht
disp('Warten auf Verbindung..');

%Open a connection.
fopen(t);
disp('Verbindung wurde aufgestellt..');

pause(1)

%Koordinaten
x = 10;
y = 10;

%Koordinaten Roboter
[xr, yr] = get_pos_from_client %Ich bekomme die Koordinaten vom Client

%Distanz
dis = getDistance(x,y,xr,yr);
while(true)
    
data = fread(t.BytesAvailable);
end



%Position in world

%distanz
%Position 