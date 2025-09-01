#!/usr/bin/env bash

# Executed when a line is selected
if [[ "$1" == "-run" ]]; then
    pid=$(echo "$ROFI_INFO" | awk '{print $1}')
    if [[ "$pid" =~ ^[0-9]+$ ]]; then
        confirm=$(printf "No\nYes" | rofi -dmenu -p "Kill PID $pid?" -theme-str 'window { width: 20%; }')
        if [[ "$confirm" == "Yes" ]]; then
            if kill -9 "$pid" 2>/dev/null; then
                notify-send "Killmenu" "Killed process $pid"
            else
                notify-send "Killmenu" "Failed to kill process $pid"
            fi
        fi
    fi
    exit 0
fi

# Display process list with attached info
ps -eo pid,comm --sort=-%mem | tail -n +2 | while read -r pid cmd; do
    # Format: <label>\x00info\x1f<data>\x1e
    echo -e "${pid} ${cmd}\x00info\x1f${pid} ${cmd}\x1e"
done