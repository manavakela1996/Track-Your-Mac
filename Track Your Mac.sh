#!/bin/sh

###############
# Preset Part #
###############


mob="+919876543210"
msg="LED Closed"

loop=false
debug=false

lock=false


###############
#  code part  #
###############

script_path=$(realpath "$0")
script_name=$(basename "$0")

parent_pid=$PPID
parent_command=$(ps -p $parent_pid -o comm=)

if [ $parent_command == -zsh ]; then
  caffeinate -i "./$script_name"
else
  if [ "$lock" = "true" ]; then
    osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
  fi
  while true; do
    status=$(ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | head -1 | awk '{print $NF}')

    if [ "$debug" = "true" ]; then
      echo "Lid Status: $status"
    fi

    if [ "$status" = "Yes" ]; then
      #afplay /System/Library/Sounds/Glass.aiff
      osascript -e "tell application \"Messages\" to send \"$msg\" to buddy \"$mob\""

      if [ "$loop" = "false" ]; then
        exit 1
      fi

      while true; do
        status=$(ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | head -1 | awk '{print $NF}')

        if [ "$status" = "No" ]; then
          break
        fi

        sleep 1
      done
    fi

    sleep 1
  done
fi
