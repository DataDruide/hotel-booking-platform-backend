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
