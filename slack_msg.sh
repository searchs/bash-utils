#!/bin/bash
'Send message t multiple Slack channels using curl'

# Set the Slack Bot Token and message
SLACK_BOT_TOKEN="YOUR_SLACK_BOT_TOKEN"
MESSAGE="Hello World!"

# List of channel IDs to send the message to
CHANNELS=(
    "CHANNEL_ID_1"
    "CHANNEL_ID_2"
    "CHANNEL_ID_3"
)

# Loop through the channels and send the message using curl
for CHANNEL in "${CHANNELS[@]}"
do
    curl -X POST -H "Authorization: Bearer $SLACK_BOT_TOKEN" -H 'Content-type: application/json' --data "{\"channel\":\"$CHANNEL\",\"text\":\"$MESSAGE\"}" https://slack.com/api/chat.postMessage
done
