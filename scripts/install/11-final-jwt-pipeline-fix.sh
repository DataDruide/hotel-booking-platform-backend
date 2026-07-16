#!/bin/bash

set -e

echo "======================================"
echo "🚀 FINAL JWT PIPELINE REPAIR"
echo "======================================"

FILE="Hotel.Api/Program.cs"

python3 <<'PY'
from pathlib import Path

p = Path("Hotel.Api/Program.cs")
text = p.read_text()

# Imports ergänzen
imports = """
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Hotel.Infrastructure.Persistence;
"""

if "using Microsoft.AspNetCore.Authentication.JwtBearer;" not in text:
    text = imports + "\n" + text


# AddControllers sicherstellen
if "builder.Services.AddControllers();" not in text:
    text = text.replace(
        "var builder = WebApplication.CreateBuilder(args);",
        """var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();"""
    )


# DbContext sicherstellen
if "AddDbContext<HotelDbContext>" not in text:
    insert = """

builder.Services.AddDbContext<HotelDbContext>(options =>
{
    options.UseNpgsql(
        builder.Configuration.GetConnectionString("DefaultConnection")
    );
});
"""
    text = text.replace(
        "var app = builder.Build();",
        insert + "\nvar app = builder.Build();"
    )


# JWT Middleware
if "AddJwtBearer" not in text:
    jwt = """

builder.Services
.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,

        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],

        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(
                builder.Configuration["Jwt:Key"]!
            )
        )
    };
});
"""
    text = text.replace(
        "var app = builder.Build();",
        jwt + "\nvar app = builder.Build();"
    )


# Middleware Reihenfolge reparieren
if "app.UseAuthentication();" not in text:
    text = text.replace(
        "app.MapControllers();",
        """
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
"""
    )


p.write_text(text)

print("✅ Program.cs final repaired")

PY


echo ""
echo "🔎 CHECK"
grep -n "AddControllers\|AddDbContext\|AddJwtBearer\|UseAuthentication\|UseAuthorization" Hotel.Api/Program.cs


echo ""
echo "======================================"
echo "✅ JWT PIPELINE READY"
echo "======================================"

