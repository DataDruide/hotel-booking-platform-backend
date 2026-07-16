
#!/bin/bash

set -e

echo "======================================"
echo "🔐 JWT VALIDATION AUTO FIX"
echo "======================================"

FILE="Hotel.Api/Program.cs"

if [ ! -f "$FILE" ]; then
    echo "❌ Program.cs nicht gefunden"
    exit 1
fi


echo ""
echo "📋 Prüfe aktuelle JWT Konfiguration..."

grep -n "AddAuthentication" $FILE || true
grep -n "AddJwtBearer" $FILE || true


echo ""
echo "🛠 Ergänze JWT Imports..."

python3 <<'PY'
from pathlib import Path

p = Path("Hotel.Api/Program.cs")
text = p.read_text()

imports = [
"using Microsoft.AspNetCore.Authentication.JwtBearer;",
"using Microsoft.IdentityModel.Tokens;",
"using System.Text;"
]

for imp in imports:
    if imp not in text:
        text = imp + "\n" + text

p.write_text(text)

print("✅ Imports geprüft")
PY


echo ""
echo "🛠 Ergänze JWT Middleware..."


python3 <<'PY'
from pathlib import Path

p = Path("Hotel.Api/Program.cs")
text = p.read_text()


jwt_block = r'''

builder.Services
.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    var jwtKey = builder.Configuration["Jwt:Key"];

    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,

        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],

        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(jwtKey!)
        )
    };
});

'''


if "AddJwtBearer" not in text:

    text = text.replace(
        "var app = builder.Build();",
        jwt_block + "\nvar app = builder.Build();"
    )

    print("✅ JWT Service hinzugefügt")

else:
    print("ℹ️ JWT Service bereits vorhanden")


if "app.UseAuthentication();" not in text:

    text = text.replace(
        "app.UseAuthorization();",
        "app.UseAuthentication();\napp.UseAuthorization();"
    )

    print("✅ Authentication Middleware hinzugefügt")

else:
    print("ℹ️ Middleware bereits vorhanden")


p.write_text(text)

PY


echo ""
echo "🔎 Program.cs Prüfung..."

grep -n "AddJwtBearer" Hotel.Api/Program.cs
grep -n "UseAuthentication" Hotel.Api/Program.cs


echo ""
echo "🏗 Dotnet Build..."

dotnet build


echo ""
echo "🐳 Docker Rebuild..."

docker compose down

docker compose build --no-cache

docker compose up -d


echo ""
echo "⏳ Warte auf API..."

sleep 8


echo ""
echo "🔑 Hole neuen JWT Token..."

export TOKEN=$(curl -s \
-X POST http://localhost:8080/api/auth/login \
-H "Content-Type: application/json" \
-d '{
"email":"admin@hotel.com",
"password":"Test123!"
}' | python3 -c "import sys,json; print(json.load(sys.stdin)['accessToken'])")


if [ -z "$TOKEN" ]; then
    echo "❌ Kein Token erhalten"
    docker logs hotel-api --tail 50
    exit 1
fi


echo ""
echo "✅ TOKEN ERHALTEN"
echo "$TOKEN"


echo ""
echo "🧪 Dashboard API Test"


curl -i \
http://localhost:8080/api/dashboard/stats \
-H "Authorization: Bearer $TOKEN"


echo ""

echo "======================================"
echo "✅ JWT PIPELINE TEST COMPLETE"
echo "======================================"

