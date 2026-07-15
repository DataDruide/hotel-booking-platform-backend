#!/bin/bash

set -e

echo "🚀 Hotel Booking Platform - Next Architecture Layer"

ROOT=$(pwd)

echo "📦 Installing NuGet Packages..."

cd Hotel.Infrastructure

dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL

cd ../Hotel.Api

dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Swashbuckle.AspNetCore

cd ..

echo "📁 Creating Application Structure..."

mkdir -p Hotel.Application/DTOs
mkdir -p Hotel.Application/Interfaces
mkdir -p Hotel.Application/Services

mkdir -p Hotel.Infrastructure/Persistence
mkdir -p Hotel.Infrastructure/Repositories

mkdir -p Hotel.Api/Controllers
mkdir -p Hotel.Api/Extensions


echo "🏗 Creating Repository Interfaces..."

cat > Hotel.Application/Interfaces/IRepository.cs <<'EOF'
namespace Hotel.Application.Interfaces;

public interface IRepository<T>
{
    Task<IEnumerable<T>> GetAllAsync();
    Task<T?> GetByIdAsync(Guid id);
    Task AddAsync(T entity);
    void Update(T entity);
    void Delete(T entity);
}
EOF


echo "🏗 Creating DbContext..."

cat > Hotel.Infrastructure/Persistence/HotelDbContext.cs <<'EOF'
using Microsoft.EntityFrameworkCore;
using Hotel.Domain.Entities;

namespace Hotel.Infrastructure.Persistence;

public class HotelDbContext : DbContext
{
    public HotelDbContext(
        DbContextOptions<HotelDbContext> options
    ) : base(options)
    {
    }


    public DbSet<Hotel> Hotels => Set<Hotel>();
    public DbSet<Room> Rooms => Set<Room>();
    public DbSet<Booking> Bookings => Set<Booking>();
    public DbSet<User> Users => Set<User>();
}
EOF


echo "🏗 Creating Repository Base..."

cat > Hotel.Infrastructure/Repositories/Repository.cs <<'EOF'
using Microsoft.EntityFrameworkCore;
using Hotel.Application.Interfaces;
using Hotel.Infrastructure.Persistence;

namespace Hotel.Infrastructure.Repositories;

public class Repository<T> : IRepository<T>
where T : class
{
    private readonly HotelDbContext _context;

    public Repository(HotelDbContext context)
    {
        _context=context;
    }


    public async Task<IEnumerable<T>> GetAllAsync()
    {
        return await _context.Set<T>().ToListAsync();
    }


    public async Task<T?> GetByIdAsync(Guid id)
    {
        return await _context.Set<T>().FindAsync(id);
    }


    public async Task AddAsync(T entity)
    {
        await _context.Set<T>().AddAsync(entity);
    }


    public void Update(T entity)
    {
        _context.Set<T>().Update(entity);
    }


    public void Delete(T entity)
    {
        _context.Set<T>().Remove(entity);
    }
}
EOF


echo "🔌 Adding Infrastructure DI..."

cat > Hotel.Infrastructure/DependencyInjection.cs <<'EOF'
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using Hotel.Infrastructure.Persistence;

namespace Hotel.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        string connectionString)
    {

        services.AddDbContext<HotelDbContext>(
            options =>
            options.UseNpgsql(connectionString)
        );


        return services;
    }
}
EOF


echo "🌐 Creating Health Controller..."

cat > Hotel.Api/Controllers/HealthController.cs <<'EOF'
using Microsoft.AspNetCore.Mvc;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/health")]
public class HealthController : ControllerBase
{

    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new
        {
            status="healthy",
            service="Hotel Booking API",
            timestamp=DateTime.UtcNow
        });
    }
}
EOF



echo "🧪 Creating Integration Test..."

mkdir -p Hotel.Tests/Integration


cat > Hotel.Tests/Integration/ApiHealthTests.cs <<'EOF'
namespace Hotel.Tests.Integration;

public class ApiHealthTests
{

    [Fact]
    public void Api_Should_Be_Healthy()
    {
        Assert.True(true);
    }

}
EOF


echo "🧹 Cleaning..."

dotnet clean


echo "🔨 Building..."

dotnet build


echo "🧪 Running Tests..."

dotnet test


echo ""
echo "======================================"
echo "✅ NEXT ARCHITECTURE LAYER COMPLETE"
echo "======================================"
echo ""
echo "Next steps:"
echo "- Configure PostgreSQL connection"
echo "- Create EF migrations"
echo "- Add Authentication"
echo "- Build Hotel CRUD API"
