#!/bin/bash

RIGHT_MONITOR="DP-1"
LEFT_MONITOR="DP-2"

MODE_RIGHT="3440x1440@175.000+vrr"
MODE_LEFT="3440x1440@120.000+vrr"

STATE_FILE="/tmp/gdctl_monitor_state"

# Read current state (default to 'dual' if unknown)
if [ -f "$STATE_FILE" ]; then
    CURRENT_STATE=$(cat "$STATE_FILE")
else
    CURRENT_STATE="dual"
fi

# Cycle: Right Only -> Left Only -> Dual -> Right Only
if [ "$CURRENT_STATE" == "right" ]; then
    gdctl set \
        --logical-monitor \
            --primary \
            --monitor "$LEFT_MONITOR" \
            --mode "$MODE_LEFT" \
            --color-mode default
    echo "left" > "$STATE_FILE"

elif [ "$CURRENT_STATE" == "left" ]; then
    gdctl set \
        --logical-monitor \
            --primary \
            --monitor "$RIGHT_MONITOR" \
            --mode "$MODE_RIGHT" \
            --color-mode bt2100 \
        --logical-monitor \
            --left-of "$RIGHT_MONITOR" \
            --monitor "$LEFT_MONITOR" \
            --mode "$MODE_LEFT" \
            --color-mode default

    echo "dual" > "$STATE_FILE"
    echo "Switched to Dual Mode"

else
    gdctl set \
        --logical-monitor \
            --primary \
            --monitor "$RIGHT_MONITOR" \
            --mode "$MODE_RIGHT" \
            --color-mode bt2100

    echo "right" > "$STATE_FILE"
    echo "Switched to Right Only"

fi
