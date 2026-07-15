#!/bin/bash

set -e

echo "🔥 HOTEL BOOKING PLATFORM GOD MODE UPGRADE"
echo "=========================================="

ROOT=$(pwd)

echo "📁 Projekt:"
echo $ROOT


echo ""
echo "🔐 JWT Security Struktur erstellen..."

mkdir -p Hotel.Api/Security


cat > Hotel.Api/Security/JwtSettings.cs <<'EOF'
namespace Hotel.Api.Security;

public class JwtSettings
{
    public string Secret { get; set; } = "";
    public int ExpirationMinutes { get; set; }
}
EOF



cat > Hotel.Api/Security/JwtService.cs <<'EOF'
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Hotel.Domain.Entities;
using Microsoft.IdentityModel.Tokens;

namespace Hotel.Api.Security;

public class JwtService
{
    private readonly IConfiguration _configuration;


    public JwtService(
        IConfiguration configuration
    )
    {
        _configuration = configuration;
    }


    public string GenerateToken(
        ApplicationUser user
    )
    {

        var claims = new[]
        {
            new Claim(
                JwtRegisteredClaimNames.Sub,
                user.Id.ToString()
            ),

            new Claim(
                JwtRegisteredClaimNames.Email,
                user.Email ?? ""
            ),

            new Claim(
                ClaimTypes.Role,
                user.Role ?? "Guest"
            )
        };


        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(
                _configuration["Jwt:Secret"]!
            )
        );


        var credentials =
            new SigningCredentials(
                key,
                SecurityAlgorithms.HmacSha256
            );


        var token =
            new JwtSecurityToken(
                claims: claims,
                expires:
                DateTime.UtcNow.AddMinutes(
                    int.Parse(
                        _configuration["Jwt:ExpirationMinutes"] ?? "60"
                    )
                ),
                signingCredentials:
                credentials
            );


        return new JwtSecurityTokenHandler()
            .WriteToken(token);

    }
}
EOF



echo "⚙️ Prüfe appsettings..."

python3 <<'PY'

import json

path="Hotel.Api/appsettings.json"

with open(path) as f:
    data=json.load(f)


data["Jwt"]={
    "Secret":
    "SUPER_SECRET_HOTEL_PLATFORM_KEY_2026_CHANGE_THIS",
    "ExpirationMinutes":60
}


with open(path,"w") as f:
    json.dump(
        data,
        f,
        indent=4
    )


print("✅ JWT config added")

PY



echo "🔧 Registriere JwtService..."


python3 <<'PY'

path="Hotel.Api/Program.cs"

text=open(path).read()


if "JwtService" not in text:

    text=text.replace(
    "var builder = WebApplication.CreateBuilder(args);",
    """
using Hotel.Api.Security;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<JwtService>();
"""
)


if "AddAuthentication" not in text:

    text=text.replace(
    "var app = builder.Build();",
"""
builder.Services
.AddAuthentication()
.AddJwtBearer();

builder.Services.AddAuthorization();


var app = builder.Build();
"""
)


if "UseAuthentication" not in text:

    text=text.replace(
    "app.UseAuthorization();",
"""
app.UseAuthentication();
app.UseAuthorization();
"""
)


open(path,"w").write(text)

print("✅ Program.cs patched")

PY



echo "📝 README erstellen..."


cat > README.md <<'EOF'
# 🏨 Hotel Booking Platform API

Modernes Hotel Booking Backend auf Basis einer Clean Architecture.

## 🚀 Projektbeschreibung

Die Hotel Booking Platform ist eine skalierbare REST API für:

- Hotels
- Zimmerverwaltung
- Buchungen
- Benutzerverwaltung
- Authentifizierung
- Rollenmanagement


## 🏗 Architektur

Das Projekt folgt einer Clean Architecture Struktur:


