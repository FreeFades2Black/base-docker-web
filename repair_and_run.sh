#!/bin/bash

echo "=== 1. Syncing Image Asset ==="
mkdir -p static
if [ -f c6caaec0-b83b-4622-ab42-e84738effe8e.jpg ]; then
    cp c6caaec0-b83b-4622-ab42-e84738effe8e.jpg static/background.jpg
    echo "Success: Image moved to static/background.jpg"
else
    echo "Warning: Source image not found in root directory. Checking static folder..."
fi

echo "=== 2. Clearing Cached Containers ==="
docker compose down
docker compose build --no-cache web

echo "=== 3. Starting the Stack ==="
docker compose up -d

echo "=== 4. Waiting for Cloudflare Tunnel to Establish ==="
sleep 8

echo "=== 5. YOUR REAL LIVE PUBLIC URL IS BELOW ==="
echo "--------------------------------------------------------"
docker compose logs tunnel | grep -o 'https://[^ ]*trycloudflare.com' | tail -n 1
echo "--------------------------------------------------------"
