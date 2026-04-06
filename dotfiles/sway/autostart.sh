#!/bin/bash
swaymsg "workspace 1; exec element-desktop; exec mattermost-desktop; exec keepassxc"
sleep 3
swaymsg "workspace 2; exec qpwgraph"
sleep 3
swaymsg "workspace 4; exec librewolf"
sleep 2
#swaymsg "workspace 5; exec feishin"
