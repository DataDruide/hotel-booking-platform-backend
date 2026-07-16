#!/bin/bash

set -e

echo "======================================"
echo "🚀 HOTEL ENTERPRISE UPGRADE"
echo "======================================"

ROOT=$(pwd)

echo ""
echo "📦 Projekt:"
echo "$ROOT"

echo ""
echo "🔍 Git Status"
git status

echo ""
echo "======================================"
echo "1/9 Backup"
echo "======================================"
./scripts/install/01-backup.sh

echo ""
echo "======================================"
echo "2/9 JWT Authentication"
echo "======================================"
./scripts/install/02-jwt-auth.sh

echo ""
echo "======================================"
echo "3/9 Role Authorization"
echo "======================================"
./scripts/install/03-role-auth.sh

echo ""
echo "======================================"
echo "4/9 Dashboard"
echo "======================================"
./scripts/install/04-dashboard.sh

echo ""
echo "======================================"
echo "5/9 Hotels"
echo "======================================"
./scripts/install/05-hotels.sh

echo ""
echo "======================================"
echo "6/9 Rooms"
echo "======================================"
./scripts/install/06-rooms.sh

echo ""
echo "======================================"
echo "7/9 Bookings"
echo "======================================"
./scripts/install/07-bookings.sh

echo ""
echo "======================================"
echo "8/9 Tests"
echo "======================================"
./scripts/install/08-tests.sh

echo ""
echo "======================================"
echo "9/9 Build"
echo "======================================"
./scripts/install/09-build.sh


echo ""
echo "======================================"
echo "✅ HOTEL ENTERPRISE UPGRADE COMPLETE"
echo "======================================"

echo ""
echo "Docker Status:"
docker compose ps

echo ""
echo "API:"
curl -I http://localhost:8080/swagger/index.html || true

echo ""
echo "Frontend:"
curl -I http://localhost:3000 || true

echo ""
echo "======================================"
