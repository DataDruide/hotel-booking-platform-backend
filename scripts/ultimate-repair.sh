#!/bin/bash

echo "🚀 Hotel Booking Platform Ultimate Repair"

echo "🧹 Removing corrupted build cache..."

find . -type d -name obj -prune -exec rm -rf {} +
find . -type d -name bin -prune -exec rm -rf {} +

echo "🔎 Searching Hotel namespace conflicts..."

FILES=$(find . \
-path "./*/obj" -prune -o \
-path "./*/bin" -prune -o \
-name "*.cs" -print)

for file in $FILES
do
    if grep -q "Hotel " "$file"; then
        echo "Checking $file"

        if grep -q "using Hotel.Domain.Entities;" "$file"; then
            echo "✔ Entity import found"
        else
            echo "➕ Adding entity import to $file"

            sed -i '' '1i\
using Hotel.Domain.Entities;\
' "$file"
        fi
    fi
done


echo "🔧 Fixing ambiguous Hotel entity references..."

find . \
-path "./*/obj" -prune -o \
-path "./*/bin" -prune -o \
-name "*.cs" -print | while read file
do

sed -i '' \
's/List<Hotel>/List<Hotel.Domain.Entities.Hotel>/g' "$file"

sed -i '' \
's/IEnumerable<Hotel>/IEnumerable<Hotel.Domain.Entities.Hotel>/g' "$file"

sed -i '' \
's/Task<Hotel>/Task<Hotel.Domain.Entities.Hotel>/g' "$file"

done


echo "📦 Restore..."

dotnet restore


echo "🔨 Build..."

dotnet build


echo "🧪 Tests..."

dotnet test


echo "✅ Finished"
