#!/bin/bash

# Your Telegram Bot Token and Chat ID
BOT_TOKEN={{ TELEGRAM.TOKEN }}
CHAT_ID={{ TELEGRAM.CHAT_ID }}

# Check if one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 arg1"
    exit 1
fi

arg=$1

# Function to send notification to Telegram
message="ℹ *${arg}* has finished"
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id=$CHAT_ID -d text="$message" -d parse_mode="Markdown"