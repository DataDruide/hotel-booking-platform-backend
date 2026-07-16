using Microsoft.AspNetCore.Mvc;
using Hotel.Infrastructure.Persistence;
using Hotel.Domain.Entities;
using Hotel.Application.DTOs.Auth;
using BCryptHasher = BCrypt.Net.BCrypt;


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
PasswordHash=BCryptHasher.HashPassword(dto.Password),
Role=dto.Role ?? "Customer",
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


if(!BCryptHasher.Verify(dto.Password,user.PasswordHash))
return Unauthorized();



return Ok(new
{
message="Login successful",
user.Email,
user.Role
});

}

}