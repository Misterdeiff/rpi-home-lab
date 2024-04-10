#!/bin/bash

# Your Telegram Bot Token and Chat ID
BOT_TOKEN={{ TELEGRAM.TOKEN }}
CHAT_ID={{ TELEGRAM.CHAT_ID }}
ALERT_LIMIT={{ DISK_ALERT_LIMIT }} # Set alert threshold

# Fetch all disks mounted that start with /dev/
DISK_PATHS=$(df -h | awk '$1 ~ /^\/dev\// {print $1}')

# Function to send notification to Telegram
send_telegram() {
    local disk_path=$1
    local disk_usage=$2
    local mount_location=$(df -h | grep "$disk_path" | awk '{print $6}')
    local message="⚠️ Disk *${disk_path}* usage (mounted at *${mount_location}*) is at *${disk_usage}%*"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id=$CHAT_ID -d text="$message" -d parse_mode="Markdown"
}

# Check disk usage for each path and send notification if threshold exceeded
for disk_path in $DISK_PATHS; do
    disk_usage=$(df -h | grep "$disk_path" | awk '{print $5}' | sed 's/%//g')
    if [ $disk_usage -ge $ALERT_LIMIT ]; then
        send_telegram $disk_path $disk_usage
    fi
done