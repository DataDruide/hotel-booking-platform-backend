#!/bin/bash

echo "======================================"
echo "🔥 HOTEL PLATFORM AUTH TEST SUITE"
echo "======================================"

echo ""
echo "📋 Container Status"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🌐 Swagger Test"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/swagger/index.html)
echo "Swagger HTTP Status: $STATUS"

echo ""
echo "🗄 Alten Testuser löschen"

docker exec hotel-postgres \
psql -U hoteladmin -d hotelbooking \
-c 'DELETE FROM "Users" WHERE "Email"='\''admin@hotel.com'\'';'


echo ""
echo "👤 Register Admin Test"

curl -s -X POST http://localhost:8080/api/auth/register \
-H "Content-Type: application/json" \
-d '{
"email":"admin@hotel.com",
"password":"Test123!",
"role":"Admin"
}'

echo ""
echo ""
echo "🔍 Datenbank Rolle prüfen"

docker exec hotel-postgres \
psql -U hoteladmin -d hotelbooking \
-c 'SELECT "Email","Role" FROM "Users" WHERE "Email"='\''admin@hotel.com'\'';'


echo ""
echo "🔑 Login Test"

RESULT=$(curl -s -X POST http://localhost:8080/api/auth/login \
-H "Content-Type: application/json" \
-d '{
"email":"admin@hotel.com",
"password":"Test123!"
}')

echo $RESULT


echo ""
echo "🧪 Rolle prüfen"

if echo "$RESULT" | grep -q "Admin"; then
    echo "✅ ADMIN LOGIN ERFOLGREICH"
else
    echo "❌ ADMIN ROLE FEHLER"
fi


echo ""
echo "📋 API Logs"

docker logs hotel-api --tail 40


echo ""
echo "======================================"
echo "✅ TEST SUITE BEENDET"
echo "======================================"
