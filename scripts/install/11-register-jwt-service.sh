
#!/bin/bash

echo "======================================"
echo "🔐 REGISTER JWT SERVICE"
echo "======================================"

python3 <<'PY'

from pathlib import Path

path = Path("Hotel.Api/Program.cs")

text = path.read_text()


if "AddScoped<JwtService>" not in text:

    text = text.replace(
        "builder.Services.AddControllers();",
        """builder.Services.AddControllers();

builder.Services.AddScoped<JwtService>();"""
    )

    path.write_text(text)

    print("✅ JwtService registriert")

else:
    print("ℹ️ JwtService bereits registriert")

PY


echo ""
echo "Prüfe Registrierung:"
grep -n "JwtService" Hotel.Api/Program.cs


echo ""
echo "======================================"
echo "✅ JWT SERVICE READY"
echo "======================================"

