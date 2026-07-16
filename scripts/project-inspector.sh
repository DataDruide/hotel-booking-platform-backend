#!/bin/bash

set -e

PROJECT_ROOT="$(pwd)"
REPORT="scripts/reports/project-inspection.md"

echo "🚀 HOTEL BOOKING PLATFORM PROJECT INSPECTOR"
echo "=========================================="

echo "📁 Project: $PROJECT_ROOT"

cat > "$REPORT" <<EOF
# Hotel Booking Platform - Project Inspection

Generated: $(date)

---

## System

EOF

echo "Checking system..."

{
echo "- OS: $(uname -s)"
echo "- Architecture: $(uname -m)"

if command -v dotnet >/dev/null; then
echo "- .NET: $(dotnet --version) ✅"
else
echo "- .NET ❌"
fi

if command -v git >/dev/null; then
echo "- Git: Installed ✅"
else
echo "- Git ❌"
fi

if command -v docker >/dev/null; then
echo "- Docker: Installed ✅"
else
echo "- Docker ❌"
fi

} >> "$REPORT"


echo "" >> "$REPORT"
echo "## Solution Structure" >> "$REPORT"

for folder in \
Hotel.Api \
Hotel.Application \
Hotel.Domain \
Hotel.Infrastructure \
Hotel.Tests
do

if [ -d "$folder" ]; then
echo "- $folder ✅" >> "$REPORT"
else
echo "- $folder ❌" >> "$REPORT"
fi

done


echo "" >> "$REPORT"
echo "## Backend Analysis" >> "$REPORT"


if find . -name "*.csproj" | grep -q .; then
echo "- C# Projects detected ✅" >> "$REPORT"
else
echo "- C# Projects missing ❌" >> "$REPORT"
fi


if find . -name "*DbContext.cs" | grep -q .; then
echo "- Entity Framework Core detected ✅" >> "$REPORT"
else
echo "- Entity Framework Core missing ❌" >> "$REPORT"
fi


if grep -R "JwtBearer" . >/dev/null 2>&1; then
echo "- JWT Authentication detected ✅" >> "$REPORT"
else
echo "- JWT Authentication missing ❌" >> "$REPORT"
fi


if grep -R "BCrypt" . >/dev/null 2>&1; then
echo "- BCrypt Password Hashing detected ✅" >> "$REPORT"
else
echo "- BCrypt missing ❌" >> "$REPORT"
fi


echo "" >> "$REPORT"
echo "## Frontend Analysis" >> "$REPORT"


if [ -d "frontend" ]; then
echo "- Frontend folder exists ✅" >> "$REPORT"

if [ -f "frontend/package.json" ]; then
echo "- Node Project detected ✅" >> "$REPORT"
fi

else
echo "- Next.js Frontend not installed ❌" >> "$REPORT"
fi


echo "" >> "$REPORT"
echo "## Docker" >> "$REPORT"


if [ -f "docker-compose.yml" ]; then
echo "- Docker Compose detected ✅" >> "$REPORT"
else
echo "- Docker Compose missing ❌" >> "$REPORT"
fi


echo "" >> "$REPORT"
echo "## Documentation" >> "$REPORT"


for file in README.md ARCHITECTURE.md SECURITY.md API_DOCUMENTATION.md
do

if [ -f "$file" ]; then
echo "- $file ✅" >> "$REPORT"
else
echo "- $file ❌" >> "$REPORT"
fi

done


echo "" >> "$REPORT"
echo "## Build Validation" >> "$REPORT"

if dotnet build >/dev/null 2>&1; then
echo "- dotnet build ✅" >> "$REPORT"
else
echo "- dotnet build FAILED ❌" >> "$REPORT"
fi


echo "" >> "$REPORT"
echo "## Git"

git status --short >> "$REPORT" || true


echo ""
echo "=========================================="
echo "✅ INSPECTION COMPLETE"
echo "=========================================="
echo ""
echo "Report created:"
echo "$REPORT"

