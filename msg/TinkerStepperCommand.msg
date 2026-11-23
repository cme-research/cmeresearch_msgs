# Velocity command for one TinkerForge Silent Stepper Bricklet 2.0
# (consumed by cmeresearch_stepper_driver on drive_input).

std_msgs/Header header

# Wheel angular velocity in rad/s. The driver applies gear_ratio and
# mirror_direction and converts it to microsteps/s.
float32 velocity
# Target position in steps. Reserved: currently ignored by the driver, which
# only runs in continuous-drive (velocity) mode.
int32 position
