#!/bin/bash

echo "🔥 GOD MODE HOTEL ENTITY FIX"

FILE="./Hotel.Api/Controllers/HotelsController.cs"

if [ ! -f "$FILE" ]; then
    echo "❌ HotelsController.cs nicht gefunden"
    exit 1
fi

echo "📄 Backup erstellen..."
cp "$FILE" "$FILE.backup"


echo "🧹 Entferne alte Hotel Imports..."
sed -i '' '/using Hotel.Domain.Entities;/d' "$FILE"
sed -i '' '/using HotelEntity/d' "$FILE"


echo "➕ Setze Entity Alias..."
sed -i '' '1i\
using HotelEntity = Hotel.Domain.Entities.Hotel;
' "$FILE"


echo "🔧 Ersetze alle Hotel Entity Referenzen..."

# Typen
sed -i '' 's/\bHotel\b/HotelEntity/g' "$FILE"

# Alias selbst schützen
sed -i '' 's/HotelEntity.Domain.Entities.Hotel/Hotel.Domain.Entities.Hotel/g' "$FILE"


echo "🧹 Clean cache..."
find . -type d \( -name bin -o -name obj \) -prune -exec rm -rf {} +


echo "📦 Restore..."
dotnet restore


echo "🔨 Build..."
dotnet build


echo "🏁 DONE"

