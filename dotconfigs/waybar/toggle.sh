#!/usr/bin/env bash

PIDFILE="$HOME/.config/waybar/waybar.pid"

if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
  echo "Killing Waybar (PID $(cat $PIDFILE))"
  kill "$(cat $PIDFILE)"
  rm "$PIDFILE"
else
  echo "Starting Waybar"
  nohup waybar >/dev/null 2>&1 &
  echo $! > "$PIDFILE"
fi
