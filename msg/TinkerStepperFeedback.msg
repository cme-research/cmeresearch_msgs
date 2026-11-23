# Feedback from one TinkerForge Silent Stepper Bricklet 2.0
# (published by cmeresearch_stepper_driver on drive_output, 10 Hz).

# frame_id is the wheel_name of the driver node.
std_msgs/Header header

# Signed motor-shaft velocity in microsteps/s (NOT rad/s), in the command
# direction convention (the driver's mirror_direction is already undone).
# Wheel rad/s = current_velocity * 2*pi / (steps_per_revolution * step_resolution * gear_ratio).
float32 current_velocity
# Raw bricklet step counter in microsteps, motor frame (not mirrored).
int32 current_position
# Remaining steps of a positioning move; 0 in continuous-drive mode.
int32 remaining_steps
# Bricklet supply voltage in mV.
int32 input_voltage
# Motor current consumption in mA.
int32 current_consumption
