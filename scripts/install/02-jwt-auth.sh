#!/bin/bash

set -e

echo "======================================"
echo "🔐 JWT AUTHENTICATION UPGRADE"
echo "======================================"

API="Hotel.Api"

echo "Prüfe Projekt..."

if [ ! -d "$API" ]; then
    echo "❌ Hotel.Api nicht gefunden"
    exit 1
fi


echo ""
echo "📦 Prüfe JWT Package..."

cd $API

if ! grep -q "Microsoft.AspNetCore.Authentication.JwtBearer" *.csproj; then

dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer

fi

cd ..


echo ""
echo "📝 Erstelle Security Ordner..."

mkdir -p Hotel.Api/Security


echo ""
echo "🔑 Erstelle JwtService..."

cat > Hotel.Api/Security/JwtService.cs <<'CS'
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace Hotel.Api.Security;

public class JwtService
{

    private readonly IConfiguration _config;


    public JwtService(IConfiguration config)
    {
        _config=config;
    }


    public string GenerateToken(string email,string role)
    {

        var claims=new[]
        {
            new Claim(
                JwtRegisteredClaimNames.Email,
                email
            ),

            new Claim(
                ClaimTypes.Role,
                role
            )
        };


        var key=new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(
                _config["Jwt:Key"]!
            )
        );


        var credentials=
            new SigningCredentials(
                key,
                SecurityAlgorithms.HmacSha256
            );


        var token=new JwtSecurityToken(

            issuer:_config["Jwt:Issuer"],

            audience:_config["Jwt:Audience"],

            claims:claims,

            expires:DateTime.UtcNow.AddHours(8),

            signingCredentials:credentials
        );


        return new JwtSecurityTokenHandler()
            .WriteToken(token);

    }

}
CS


echo ""
echo "⚙️ JWT Settings prüfen..."

python3 <<'PY'
import json

p="Hotel.Api/appsettings.json"

try:
    data=json.load(open(p))
except:
    data={}


data["Jwt"]={
    "Key":"HOTEL_PLATFORM_SUPER_SECRET_KEY_CHANGE_ME_2026",
    "Issuer":"HotelPlatform",
    "Audience":"HotelFrontend"
}


open(p,"w").write(
    json.dumps(data,indent=4)
)

print("JWT config geschrieben")
PY


echo ""
echo "======================================"
echo "✅ JWT AUTH FILES CREATED"
echo "======================================"
