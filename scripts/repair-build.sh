#!/bin/bash

set -e

echo "🚀 Hotel Booking Platform - Auto Healer"

ENTITY="Hotel.Domain.Entities.Hotel"

echo "🔍 Searching namespace conflicts..."

FILES=$(grep -rl "\bHotel\b" Hotel.Api Hotel.Infrastructure Hotel.Application || true)

for FILE in $FILES
do
    echo "Checking: $FILE"

    if [[ "$FILE" != *"Hotel.Domain"* ]]; then

        if grep -q "using Hotel.Domain.Entities;" "$FILE"; then
            echo "✔ Entity import exists"
        else
            echo "➕ Adding entity import"

            sed -i '' '1i\
using Hotel.Domain.Entities;
' "$FILE"

        fi

    fi

done


echo "🔧 Replacing ambiguous Hotel references..."

find Hotel.Api Hotel.Infrastructure Hotel.Application \
-name "*.cs" \
-exec sed -i '' \
's/\bnew Hotel\b/new Hotel.Domain.Entities.Hotel/g' {} \;


echo "🔧 Fixing generic types..."

find Hotel.Api Hotel.Infrastructure Hotel.Application \
-name "*.cs" \
-exec sed -i '' \
's/ActionResult<Hotel>/ActionResult<Hotel.Domain.Entities.Hotel>/g' {} \;


echo "🧹 Clean"

dotnet clean


echo "📦 Restore"

dotnet restore


echo "🏗 Build"

dotnet build


echo "🧪 Tests"

dotnet test


echo "✅ COMPLETE"
