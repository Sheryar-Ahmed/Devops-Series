#!/bin/bash

APP_NAME="node-backend"

echo "Restarting $APP_NAME..."
pm2 restart $APP_NAME
