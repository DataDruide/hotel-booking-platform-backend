#!/bin/bash

set -e

echo "======================================"
echo "📦 BACKUP CHECK"
echo "======================================"

DATE=$(date +"%Y%m%d_%H%M%S")
BRANCH="upgrade-backup-$DATE"

echo "Aktueller Branch:"
git branch --show-current

echo ""
echo "Erstelle Backup Branch:"
git checkout -b "$BRANCH" || true

echo ""
echo "Git Status:"
git status

echo ""
echo "Backup Branch erstellt:"
git branch --show-current

echo ""
echo "======================================"
echo "✅ BACKUP COMPLETE"
echo "======================================"
