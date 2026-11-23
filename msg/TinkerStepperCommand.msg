# Velocity command for one TinkerForge Silent Stepper Bricklet 2.0
# (consumed by cmeresearch_stepper_driver on drive_input).

std_msgs/Header header

# Wheel angular velocity in rad/s. The driver applies gear_ratio and
# mirror_direction and converts it to microsteps/s.
float32 velocity
# Unused (ignored by the driver). For position moves run the driver in
# control_mode "position" and use the MoveSteps action.
int32 position
