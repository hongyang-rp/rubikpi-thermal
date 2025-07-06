#!/bin/bash

cycle_time=5

start()
{
	while true; do
		temp=$(cat /sys/class/thermal/thermal_zone10/temp)

		if [ $temp -ge 90000 ]; then
			echo 255 > /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1
		elif [ $temp -ge 75000  ]; then
			echo 124 > /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1
		elif [ $temp -ge 60000 ]; then
			echo 64 > /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1
		else
			echo 0 > /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1
		fi

		sleep $cycle_time
	done
}

stop()
{
	echo 0 > /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	status)
		temp=$(cat /sys/class/thermal/thermal_zone10/temp)
		echo "Current temperature: $((temp / 1000))°C"
		echo "Current fan speed: $(cat /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1)"
		;;
	*)
		echo "Usage: $0 {start|stop|restart|status}"
		exit 1
esac

