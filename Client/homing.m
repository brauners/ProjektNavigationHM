 function state = homing()
    x = arrobot_getx();
    y = arrobot_gety();
    
    global t
    
    t_homing = t;
    string = strcat(num2str(x),',',num2str(y));
%     fprintf(t_homing, string);
    
    pause(1);
    
    if (t_homing.ByteAvailable ~= 0)
        data read = fread(t_homing, t_homing.BytesAvailable);
        char_array = char(data_read);
        distance = str2double(char_array);
    
    
    end
     if (distance <= 3) 
         state = 1;
         homing_final(t_homing,distance)
     else
         state = 0;
     end
 end
 