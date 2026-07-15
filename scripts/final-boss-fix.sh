#!/bin/bash

echo "🚀 Hotel Booking Platform FINAL BOSS FIX"

echo "🔍 Searching Hotel namespace collision..."

FILE="./Hotel.Api/Controllers/HotelsController.cs"

if [ -f "$FILE" ]; then

echo "🛠 Fixing HotelsController..."

# Entferne falsche Hotel usings
sed -i '' '/using Hotel;/d' "$FILE"

# Stelle sicher Entity Alias vorhanden ist
grep -q "using HotelEntity" "$FILE" || \
sed -i '' '1i\
using HotelEntity = Hotel.Domain.Entities.Hotel;
' "$FILE"


# Ersetze nur Typverwendungen
sed -i '' 's/\bList<Hotel>/List<HotelEntity>/g' "$FILE"
sed -i '' 's/\bIEnumerable<Hotel>/IEnumerable<HotelEntity>/g' "$FILE"
sed -i '' 's/\bActionResult<Hotel>/ActionResult<HotelEntity>/g' "$FILE"
sed -i '' 's/\bTask<Hotel>/Task<HotelEntity>/g' "$FILE"

echo "✅ Controller fixed"

fi


echo "🧹 Removing cache..."

find . -type d \( -name bin -o -name obj \) -prune -exec rm -rf {} +


echo "📦 Restore..."
dotnet restore


echo "🔨 Build..."
dotnet build


echo "🧪 Test..."
dotnet test


echo "🏁 DONE"
