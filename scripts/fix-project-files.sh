#!/bin/bash

echo "🚑 Fixing corrupted csproj files..."

for file in $(find . -name "*.csproj"); do
    echo "Checking $file"

    if head -1 "$file" | grep -q "using"; then
        echo "⚠️ Removing invalid C# imports from $file"

        sed -i '' '/^using .*;/d' "$file"
    fi
done

echo "🧹 Cleaning build..."
dotnet clean

echo "📦 Restoring packages..."
dotnet restore

echo "🔨 Building solution..."
dotnet build

echo "🧪 Running tests..."
dotnet test

echo "✅ Repair finished"
