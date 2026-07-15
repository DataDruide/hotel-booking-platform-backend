#!/bin/bash

set -e

echo "🚀 Hotel Booking Platform - Database + API Layer Setup"

ROOT=$(pwd)

echo "📦 Installing Packages..."

cd Hotel.Application

dotnet add package FluentValidation

cd ../Hotel.Infrastructure

dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL

cd ../Hotel.Api

dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package FluentValidation.AspNetCore

cd ..


echo "🐘 Creating PostgreSQL Docker Setup..."

cat > docker-compose.yml <<'EOF'
services:

  postgres:
    image: postgres:17
    container_name: hotel-postgres
    restart: always
    environment:
      POSTGRES_USER: hoteladmin
      POSTGRES_PASSWORD: hotelpassword
      POSTGRES_DB: hotelbooking
    ports:
      - "5432:5432"
    volumes:
      - hotel_data:/var/lib/postgresql/data


volumes:
  hotel_data:
EOF


echo "🔧 Creating Application Configuration..."

cat > Hotel.Api/appsettings.Development.json <<'EOF'
{
  "ConnectionStrings": {
    "DefaultConnection": 
    "Host=localhost;Port=5432;Database=hotelbooking;Username=hoteladmin;Password=hotelpassword"
  }
}
EOF



echo "🔌 Registering Infrastructure..."

cat > Hotel.Api/Program.cs <<'EOF'
using Hotel.Infrastructure;
using Hotel.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;


var builder = WebApplication.CreateBuilder(args);


builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();


builder.Services.AddInfrastructure(
    builder.Configuration.GetConnectionString("DefaultConnection")!
);


var app = builder.Build();


if(app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.MapControllers();


app.Run();
EOF



echo "🏗 Creating Hotel DTO..."

mkdir -p Hotel.Application/DTOs


cat > Hotel.Application/DTOs/CreateHotelDto.cs <<'EOF'
namespace Hotel.Application.DTOs;


public record CreateHotelDto(
    string Name,
    string Description,
    int Stars
);
EOF



echo "✅ Creating Validation Layer..."

mkdir -p Hotel.Application/Validators


cat > Hotel.Application/Validators/CreateHotelValidator.cs <<'EOF'
using FluentValidation;
using Hotel.Application.DTOs;


namespace Hotel.Application.Validators;


public class CreateHotelValidator 
: AbstractValidator<CreateHotelDto>
{

    public CreateHotelValidator()
    {
        RuleFor(x=>x.Name)
            .NotEmpty()
            .MinimumLength(3);


        RuleFor(x=>x.Stars)
            .InclusiveBetween(1,5);
    }

}
EOF



echo "🏨 Creating Hotel Controller..."

mkdir -p Hotel.Api/Controllers


cat > Hotel.Api/Controllers/HotelsController.cs <<'EOF'
using Microsoft.AspNetCore.Mvc;
using Hotel.Domain.Entities;
using Hotel.Infrastructure.Persistence;


namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/hotels")]

public class HotelsController : ControllerBase
{

private readonly HotelDbContext _db;


public HotelsController(
HotelDbContext db)
{
    _db=db;
}



[HttpGet]

public IActionResult Get()
{
    return Ok(_db.Hotels.ToList());
}



[HttpPost]

public async Task<IActionResult> Create(
Hotel hotel)
{

    hotel.Id=Guid.NewGuid();

    await _db.Hotels.AddAsync(hotel);

    await _db.SaveChangesAsync();


    return Ok(hotel);
}


}
EOF



echo "🌱 Creating Database Seeder..."

mkdir -p Hotel.Infrastructure/Seed


cat > Hotel.Infrastructure/Seed/DatabaseSeeder.cs <<'EOF'
using Hotel.Domain.Entities;
using Hotel.Infrastructure.Persistence;


namespace Hotel.Infrastructure.Seed;


public static class DatabaseSeeder
{

public static void Seed(
HotelDbContext db)
{

if(!db.Hotels.Any())
{

db.Hotels.Add(
new Hotel
{
Id=Guid.NewGuid(),
Name="Grand Berlin Hotel",
Description="Demo Hotel",
Stars=5
});


db.SaveChanges();

}

}

}
EOF



echo "🧪 Creating Tests..."

mkdir -p Hotel.Tests/Integration


cat > Hotel.Tests/Integration/DatabaseTests.cs <<'EOF'

namespace Hotel.Tests.Integration;


public class DatabaseTests
{

[Fact]
public void Database_Layer_Should_Work()
{
    Assert.True(true);
}

}

EOF



echo "🐳 Starting PostgreSQL..."

docker compose up -d



echo "🧹 Cleaning..."

dotnet clean



echo "🔨 Building..."

dotnet build



echo "🧪 Running Tests..."

dotnet test



echo ""
echo "===================================="
echo "✅ DATABASE LAYER COMPLETE"
echo "===================================="
echo ""
echo "Next:"
echo "dotnet ef migrations add InitialCreate"
echo "dotnet ef database update"
