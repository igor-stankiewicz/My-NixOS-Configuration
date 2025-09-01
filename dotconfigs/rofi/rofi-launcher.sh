#!/usr/bin/env bash

MODE=$(cat /tmp/rofi_mode_state 2>/dev/null || echo drun)

rofi -show "$MODE" \
     -modi drun,killmenu:"$HOME/.config/rofi/killmenu.sh" \
     -theme "$HOME/.config/rofi/my-theme.rasi"
