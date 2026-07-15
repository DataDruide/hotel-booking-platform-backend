#!/bin/bash

echo "🚀 Hotel Booking Platform - Ultimate Auto Fix"

ROOT=$(pwd)

echo "🧹 Cleaning corrupted build files..."
find . -type d \( -name bin -o -name obj \) -prune -exec rm -rf {} +

echo "🧽 Cleaning corrupted csproj files..."
find . -name "*.csproj" | while read file; do
    sed -i '' '/^using .*;/d' "$file" 2>/dev/null || true
done

echo "🔍 Fixing Hotel namespace conflicts..."

# Controllers reparieren
find . -name "*.cs" | while read file; do

    if grep -q "Hotel" "$file"; then

        # Nur echte C# Dateien bearbeiten
        if [[ "$file" != *"/obj/"* ]] && [[ "$file" != *"/bin/"* ]]; then

            echo "Checking $file"

            if grep -q "Hotel.Domain.Entities" "$file"; then

                sed -i '' 's/using Hotel.Domain.Entities;/using HotelEntity = Hotel.Domain.Entities.Hotel;/' "$file"

            fi

            # Repository/Generic Typen
            sed -i '' \
            -e 's/IRepository<Hotel>/IRepository<HotelEntity>/g' \
            -e 's/List<Hotel>/List<HotelEntity>/g' \
            -e 's/IEnumerable<Hotel>/IEnumerable<HotelEntity>/g' \
            -e 's/new Hotel(/new HotelEntity(/g' \
            "$file"

        fi
    fi
done


echo "🔎 Checking Entity Stars property..."

ENTITY=$(find . -path "*Domain*" -name "Hotel.cs" | head -1)

if [ -n "$ENTITY" ]; then

    if ! grep -q "Stars" "$ENTITY"; then

        echo "➕ Adding Stars property"

        sed -i '' '/public class Hotel/a\
    public int Stars { get; set; }
' "$ENTITY"

    fi

fi


echo "📦 Restoring packages..."
dotnet restore


echo "🔨 Building solution..."
dotnet build


if [ $? -eq 0 ]; then
    echo "✅ BUILD SUCCESSFUL"
else
    echo "❌ Remaining errors:"
    dotnet build --verbosity minimal
fi


echo "🧪 Running tests..."
dotnet test


echo "🏁 Finished"
