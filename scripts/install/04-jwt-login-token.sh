#!/bin/bash

set -e

echo "======================================"
echo "🔑 LOGIN TOKEN RESPONSE UPGRADE"
echo "======================================"


python3 <<'PY'

from pathlib import Path

p=Path("Hotel.Api/Controllers/AuthController.cs")

text=p.read_text()


if "JwtService" not in text:

    text=text.replace(
        "using Microsoft.AspNetCore.Mvc;",
        "using Microsoft.AspNetCore.Mvc;\nusing Hotel.Api.Security;"
    )


    text=text.replace(
        "public class AuthController : ControllerBase",
        """public class AuthController : ControllerBase
{
    private readonly JwtService _jwt;

    public AuthController(JwtService jwt)
    {
        _jwt = jwt;
    }
"""
    )


text=text.replace(
"""return Ok(new
{
message="Login successful",
user.Email,
user.Role
});""",
"""var token = _jwt.GenerateToken(
    user.Email,
    user.Role ?? "Customer"
);

return Ok(new
{
    message="Login successful",
    accessToken=token,
    user.Email,
    user.Role
});"""
)


p.write_text(text)

print("AuthController angepasst")

PY


echo ""
echo "======================================"
echo "✅ LOGIN TOKEN ENABLED"
echo "======================================"

