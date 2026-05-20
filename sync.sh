#!/bin/bash
# 1. Update the timestamp in the cheat sheet
echo "### Last Sync: $(date '+%Y-%m-%d %H:%M:%S')" >> dev-cheat-sheet.md
# 2. Stage all changes
git add .
# 3. Commit with a timestamped message
git commit -m "Update project and documentation: $(date '+%Y-%m-%d %H:%M:%S')"
# 4. Push to origin
git push origin main
echo "Successfully synced to GitHub!"
