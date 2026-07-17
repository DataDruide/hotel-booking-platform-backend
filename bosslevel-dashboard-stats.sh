
#!/bin/bash

set -e

echo "🚀 DASHBOARD STATS MODULE + GIT DEPLOY"
echo "======================================"

echo ""
echo "📁 Creating Dashboard Controller"

mkdir -p Hotel.Api/Controllers


cat > Hotel.Api/Controllers/DashboardController.cs <<'CS'

using Microsoft.AspNetCore.Mvc;
using Hotel.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/dashboard")]
public class DashboardController : ControllerBase
{

    private readonly HotelDbContext _db;


    public DashboardController(HotelDbContext db)
    {
        _db=db;
    }


    [HttpGet("stats")]
    public async Task<IActionResult> Stats()
    {

        var hotels = await _db.Hotels.CountAsync();

        var rooms = await _db.Rooms.CountAsync();

        var available =
            await _db.Rooms.CountAsync(x => x.Available);


        var rating =
            await _db.Hotels
            .AverageAsync(x => (double?)x.Rating)
            ?? 0;


        return Ok(new
        {
            hotels,
            rooms,
            availableRooms = available,
            averageRating = Math.Round(rating,2)
        });

    }

}

CS


echo ""
echo "🏗 Frontend Build Check"

cd frontend

npm run build

cd ..


echo ""
echo "🐳 Docker Rebuild"

docker compose down

docker compose build --no-cache

docker compose up -d


echo ""
echo "⏳ Waiting for API"

sleep 8


echo ""
echo "🧪 Dashboard API Test"

curl -f http://localhost:8080/api/dashboard/stats \
| python3 -m json.tool


echo ""
echo "🐳 Container Status"

docker ps


echo ""
echo "📦 Git Status"

git status


echo ""
echo "➕ Adding Changes"

git add .


echo ""
echo "💾 Commit"

git commit -m "feat: add dashboard statistics endpoint"


echo ""
echo "🚀 Push"

git push


echo ""
echo "======================================"
echo "✅ DASHBOARD STATS COMPLETE + PUSHED"
echo "======================================"

