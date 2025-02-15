#!/bin/bash

APP_NAME="node-backend"  # Change this to your app name
ENTRY_FILE="server.js"   # Change this to your entry file (e.g., index.js, app.js)

echo "Starting $APP_NAME using PM2..."
pm2 start $ENTRY_FILE --name $APP_NAME

echo "Saving PM2 process..."
pm2 save

echo "Enabling PM2 startup..."
pm2 startup
