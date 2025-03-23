#!/bin/bash
POLYBAR_TARGET=~/personal/dotfiles/polybar
POLYBAR_LINK=~/.config/polybar

# Remove existing symlink if it exists
[ -L "$POLYBAR_LINK" ] && rm "$POLYBAR_LINK"

# Create a new symlink
ln -s "$POLYBAR_TARGET" "$POLYBAR_LINK"

# Kill existing Polybar instances
killall -q polybar
killall -q polybar

export POLYBAR_PATH="$HOME/.config/polybar/v3"
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload bar -c $POLYBAR_PATH/config.ini  &
    done
else
    polybar bar -c $POLYBAR_PATH/config.ini 2>&1 | tee -a /tmp/poybar1.log & disown
fi

echo "POLYBAR LAUNCHED."

