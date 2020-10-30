#!/bin/sh

time='20s'

# =================== PARSE ARGUMENTS =========================
VALUE=$(echo $1 | awk -F= '{print $2}')
case $1 in
  --sleep=*|-s=*) time=$VALUE
    ;;
esac

# Kill all conky
killall conky

# Wait for 20s for the system to boot up
sleep $time 

# Finally startup conky
conky --daemonize --pause=1 -c /home/utkarsh/.conky/ut.conkyrc
# conky --daemonize --pause=5 -c /home/utkarsh/.conky/WeatherConky/conky_weather
