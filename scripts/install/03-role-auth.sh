#!/bin/bash

set -e

echo "======================================"
echo "🔐 ROLE + JWT AUTH ACTIVATION"
echo "======================================"


echo "📝 Registriere JwtService in Program.cs"


python3 <<'PY'

from pathlib import Path

p=Path("Hotel.Api/Program.cs")

text=p.read_text()


if "JwtService" not in text:

    text=text.replace(
        "using Microsoft.EntityFrameworkCore;",
        "using Microsoft.EntityFrameworkCore;\nusing Hotel.Api.Security;"
    )


    text=text.replace(
        "var builder = WebApplication.CreateBuilder(args);",
        """var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<JwtService>();

builder.Services
.AddAuthentication("Bearer")
.AddJwtBearer(options =>
{
    options.TokenValidationParameters =
    new Microsoft.IdentityModel.Tokens.TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,

        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],

        IssuerSigningKey =
        new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(
            System.Text.Encoding.UTF8.GetBytes(
                builder.Configuration["Jwt:Key"]!
            )
        )
    };
});
"""
    )


    text=text.replace(
        "app.UseAuthorization();",
        "app.UseAuthentication();\napp.UseAuthorization();"
    )


p.write_text(text)

print("Program.cs aktualisiert")

PY


echo ""
echo "======================================"
echo "✅ JWT PIPELINE ENABLED"
echo "======================================"

