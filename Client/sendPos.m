function sendPos(t)


%%Gibt aktuelle Position des Roboters zur�ck
xr = arrobot_getx();
yr = arrobot_gety();
string = strcat(num2str(x), ' , ' , num2str(y));
fprintf(t, string);

end

