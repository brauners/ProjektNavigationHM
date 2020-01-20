function [lx, ly, rx, ry button] = get_pad_command(controller)
State = controller.GetState();
deadzone = State.Gamepad.LeftThumbDeadZone;

ly = State.Gamepad.LeftThumbY;
ly = double(mapping(ly, deadzone, 100));

lx = State.Gamepad.LeftThumbX;
lx = double(mapping(lx, deadzone, 100));

ry = State.Gamepad.RightThumbY;
ry = double(mapping(ry, deadzone, 100));

rx = State.Gamepad.RightThumbX;
rx = double(mapping(rx, deadzone, 100));

button = State.Gamepad.Buttons.ToString;

end

function val = mapping(input, deadzone, devisor)
val = 0;
if abs(input) > deadzone
    val = input;
    val = val/devisor;
end
end