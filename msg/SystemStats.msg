# Periodic snapshot of the controller's Linux host (CPU / memory / thermal)
# plus Raspberry Pi throttling state. Published by
# cmeresearch_robot_state/system_stats_node at a configurable rate
# (default 0.2 Hz / every 5 s).

std_msgs/Header header

# CPU utilisation averaged over the last publish interval, 0..100 percent.
# NaN if /proc/stat could not be read.
float32 cpu_percent

# Memory in MB and percent used. memory_percent = 100 * (used / total).
uint32 memory_total_mb
uint32 memory_used_mb
float32 memory_percent

# SoC temperature in degrees Celsius. NaN if no thermal sensor was readable.
float32 temperature_c

# Raspberry Pi throttle bits from `vcgencmd get_throttled`. See
# https://www.raspberrypi.com/documentation/computers/os.html#vcgencmd-get_throttled
# Currently-active bits (also reflected in throttle_active):
#   0x1     under-voltage detected
#   0x2     ARM frequency capped
#   0x4     currently throttled
#   0x8     soft temperature limit active
# Sticky "has occurred since boot" bits:
#   0x10000 under-voltage has occurred
#   0x20000 ARM frequency capping has occurred
#   0x40000 throttling has occurred
#   0x80000 soft temperature limit has occurred
# 0 on non-Pi hosts where vcgencmd is unavailable.
uint32 throttle_bits

# True iff any of the currently-active bits (0x1 | 0x2 | 0x4 | 0x8) are set.
bool throttle_active

# Root-filesystem usage (defaults to "/", configurable via the
# `disk_mount_point` parameter on system_stats_node). `disk_used_mb` is
# computed against blocks-available-to-non-root (f_bavail), so it matches
# what `df -h` reports rather than f_bfree which includes reserved blocks.
uint32 disk_total_mb
uint32 disk_used_mb
float32 disk_percent

# Host identification — published with every sample so MQTT retain keeps the
# latest set available for late subscribers without a separate "hello" topic.
# All three are empty strings when the source file/syscall is unavailable
# (e.g. `hardware_model` on non-Pi hosts where /proc/device-tree/model
# doesn't exist).
string os_pretty_name      # /etc/os-release PRETTY_NAME
string kernel_release      # uname -r
string hardware_model      # /proc/device-tree/model (Raspberry Pi model)
