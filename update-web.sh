#!/bin/bash
set -e

echo "Building Flutter web..."
flutter build web

echo "Copying build to GitHub pages folder..."
cp -rf /mnt/Nvme/AlgoBook/build/web/. /mnt/Nvme/yazuc.github.io

cd /mnt/Nvme/yazuc.github.io

echo "Adding, committing, and pushing changes..."
git add .
git commit -m "auto-update"
git push

echo "Deployment complete."
