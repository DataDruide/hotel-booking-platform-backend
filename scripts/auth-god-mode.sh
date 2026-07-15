#!/bin/bash

set -e

echo "🔥 HOTEL BOOKING AUTH GOD MODE UPGRADE"
echo "======================================"

ROOT=$(pwd)

echo "📁 Prüfe Projektstruktur..."

mkdir -p Hotel.Domain/Entities
mkdir -p Hotel.Application/DTOs/Auth
mkdir -p Hotel.Application/Interfaces
mkdir -p Hotel.Api/Controllers


echo "👤 Erstelle ApplicationUser..."

cat > Hotel.Domain/Entities/ApplicationUser.cs <<'EOF'
namespace Hotel.Domain.Entities;

public class ApplicationUser
{
    public Guid Id { get; set; }

    public string Email { get; set; } = string.Empty;

    public string PasswordHash { get; set; } = string.Empty;

    public string Role { get; set; } = "Customer";

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
EOF



echo "📝 Erstelle Auth DTOs..."


cat > Hotel.Application/DTOs/Auth/RegisterDto.cs <<'EOF'
namespace Hotel.Application.DTOs.Auth;

public class RegisterDto
{
    public string Email {get;set;} = "";
    public string Password {get;set;} = "";
}
EOF


cat > Hotel.Application/DTOs/Auth/LoginDto.cs <<'EOF'
namespace Hotel.Application.DTOs.Auth;

public class LoginDto
{
    public string Email {get;set;} = "";
    public string Password {get;set;} = "";
}
EOF



echo "🔐 Installiere BCrypt..."

dotnet add Hotel.Api package BCrypt.Net-Next



echo "🛠 Prüfe DbContext..."

DB=Hotel.Infrastructure/Persistence/HotelDbContext.cs


if ! grep -q "ApplicationUser" $DB
then

python3 <<'PY'

path="Hotel.Infrastructure/Persistence/HotelDbContext.cs"

text=open(path).read()

text=text.replace(
"public DbSet<Booking> Bookings { get; set; }",
"public DbSet<Booking> Bookings { get; set; }\n\npublic DbSet<ApplicationUser> Users { get; set; }"
)

if "using Hotel.Domain.Entities;" not in text:
    text="using Hotel.Domain.Entities;\n"+text


open(path,"w").write(text)

PY

fi



echo "🔑 Erstelle Auth Controller..."

cat > Hotel.Api/Controllers/AuthController.cs <<'EOF'
using Microsoft.AspNetCore.Mvc;
using Hotel.Infrastructure.Persistence;
using Hotel.Domain.Entities;
using Hotel.Application.DTOs.Auth;
using BCrypt.Net;


namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/auth")]

public class AuthController : ControllerBase
{

private readonly HotelDbContext _db;


public AuthController(HotelDbContext db)
{
    _db=db;
}



[HttpPost("register")]

public async Task<IActionResult> Register(RegisterDto dto)
{

var exists=_db.Users
.FirstOrDefault(x=>x.Email==dto.Email);


if(exists!=null)
return BadRequest("User exists");



var user=new ApplicationUser
{
Id=Guid.NewGuid(),
Email=dto.Email,
PasswordHash=BCrypt.HashPassword(dto.Password)
};


_db.Users.Add(user);

await _db.SaveChangesAsync();


return Ok(new
{
user.Id,
user.Email
});

}




[HttpPost("login")]

public IActionResult Login(LoginDto dto)
{

var user=_db.Users
.FirstOrDefault(x=>x.Email==dto.Email);


if(user==null)
return Unauthorized();


if(!BCrypt.Verify(dto.Password,user.PasswordHash))
return Unauthorized();



return Ok(new
{
message="Login successful",
user.Email,
user.Role
});

}

}
EOF



echo "🧹 Clean..."

dotnet clean



echo "📦 Restore..."

dotnet restore



echo "🏗 Build..."

dotnet build



echo "🗄 Migration..."

dotnet ef migrations add AddAuthentication \
--project Hotel.Infrastructure \
--startup-project Hotel.Api || echo "Migration already exists"



echo "⬆️ Database Update..."

dotnet ef database update \
--project Hotel.Infrastructure \
--startup-project Hotel.Api



echo ""
echo "🔥🔥🔥 AUTH GOD MODE COMPLETE 🔥🔥🔥"
echo ""
echo "Test:"
echo ""
echo "POST http://localhost:5096/api/auth/register"
echo ""
echo '{"email":"admin@test.com","password":"123456"}'
echo ""
