function [trans, rot, button] = get_pad_command(controller)
State = controller.GetState();
deadzone = State.Gamepad.LeftThumbDeadZone;

trans = State.Gamepad.LeftThumbY;
trans = double(mapping(trans, deadzone, 50));

rot = State.Gamepad.LeftThumbX;
rot = double(mapping(rot, deadzone, 800));

button = State.Gamepad.Buttons.ToString;

end

function val = mapping(input, deadzone, devisor)
val = 0;
if abs(input) > deadzone
    val = input;
    val = val/devisor;
end
end
