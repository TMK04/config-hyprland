#!/bin/sh
asus_platform_dir='/sys/devices/platform/asus-nb-wmi'
echo 1 > "$asus_platform_dir/throttle_thermal_policy"
asus_pwm_enable_files=$(find "$asus_platform_dir/hwmon" -path '*_enable')
for asus_pwn_enable_file in $asus_pwn_enable_files; do
  echo 2 > "$asus_pwn_enable_file"
done

