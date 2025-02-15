#!/bin/bash

APP_NAME="node-backend"

echo "Stopping $APP_NAME..."
pm2 stop $APP_NAME
