# Navigation status derived from the Nav2 NavigateToPose action. Published by
# cmeresearch_robot_state/nav_status_node and bridged to the web dashboard over
# MQTT (mqtt_bridge -> topic navigation/status).

std_msgs/Header header

# High-level state, mapped from action_msgs/GoalStatus:
#   idle | navigating | canceling | canceled | aborted | succeeded
string status

# Live progress from the NavigateToPose action feedback. All zero unless
# status == "navigating".
float32 distance_remaining        # m, distance left to the goal
float32 estimated_time_remaining  # s, Nav2's ETA to the goal (0 if unknown)
float32 navigation_time           # s, elapsed time on the current goal
int16 number_of_recoveries        # recovery behaviours run on the current goal
