#!/bin/bash

echo "🚑 Final Hotel Backend Healer"

echo "🔧 Restoring missing Domain Entity imports..."

find . -name "*.cs" \
-not -path "*/bin/*" \
-not -path "*/obj/*" | while read file
do

    if grep -Eq "\b(Room|Booking|User|Hotel)\b" "$file"; then

        if ! grep -q "using Hotel.Domain.Entities;" "$file"; then

            echo "➕ Adding entity namespace: $file"

            sed -i '' '1i\
using Hotel.Domain.Entities;
' "$file"

        fi

    fi

done


echo "🧹 Removing build cache..."
find . -type d \( -name bin -o -name obj \) -prune -exec rm -rf {} +


echo "📦 Restore..."
dotnet restore


echo "🔨 Build..."
dotnet build


echo "🧪 Test..."
dotnet test


echo "✅ Finished"
