#!/bin/bash

set -e

echo "🏨 HOTEL MANAGEMENT MODULE GOD MODE"
echo "=================================="
echo "📁 Project: $(pwd)"

echo ""
echo "🔎 Checking project structure..."

if [ ! -d "Hotel.Domain" ]; then
  echo "❌ Hotel.Domain missing"
  exit 1
fi

if [ ! -d "Hotel.Api" ]; then
  echo "❌ Hotel.Api missing"
  exit 1
fi


echo ""
echo "🏨 Creating Hotel Management Domain"


cat > Hotel.Domain/Entities/Hotel.cs <<'EOF'
namespace Hotel.Domain.Entities;

public class Hotel
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    public string Address { get; set; } = string.Empty;

    public string City { get; set; } = string.Empty;

    public string Country { get; set; } = string.Empty;

    public decimal Rating { get; set; }

    public ICollection<Room> Rooms { get; set; } = new List<Room>();
}
EOF


cat > Hotel.Domain/Entities/Room.cs <<'EOF'
namespace Hotel.Domain.Entities;

public class Room
{
    public Guid Id { get; set; }

    public Guid HotelId { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Type { get; set; } = string.Empty;

    public decimal PricePerNight { get; set; }

    public int Capacity { get; set; }

    public bool Available { get; set; }

    public Hotel? Hotel { get; set; }
}
EOF


echo ""
echo "📦 Creating Application DTOs"


mkdir -p Hotel.Application/DTOs/Hotel


cat > Hotel.Application/DTOs/Hotel/CreateHotelDto.cs <<'EOF'
namespace Hotel.Application.DTOs.Hotel;

public class CreateHotelDto
{
    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    public string Address { get; set; } = string.Empty;

    public string City { get; set; } = string.Empty;

    public string Country { get; set; } = string.Empty;

    public decimal Rating { get; set; }
}
EOF


echo ""
echo "🌐 Creating Hotel API Controller"


cat > Hotel.Api/Controllers/HotelsController.cs <<'EOF'
using Microsoft.AspNetCore.Mvc;
using Hotel.Domain.Entities;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/hotels")]
public class HotelsController : ControllerBase
{

    private static readonly List<Hotel> Hotels = new();


    [HttpGet]
    public IActionResult GetHotels()
    {
        return Ok(Hotels);
    }


    [HttpGet("{id}")]
    public IActionResult GetHotel(Guid id)
    {
        var hotel = Hotels.FirstOrDefault(x => x.Id == id);

        if(hotel == null)
            return NotFound();


        return Ok(hotel);
    }


    [HttpPost]
    public IActionResult CreateHotel(Hotel hotel)
    {
        hotel.Id = Guid.NewGuid();

        Hotels.Add(hotel);

        return Created(
            $"/api/hotels/{hotel.Id}",
            hotel
        );
    }


    [HttpDelete("{id}")]
    public IActionResult DeleteHotel(Guid id)
    {
        var hotel = Hotels.FirstOrDefault(x=>x.Id==id);

        if(hotel == null)
            return NotFound();


        Hotels.Remove(hotel);

        return NoContent();
    }
}
EOF


echo ""
echo "⚛️ Creating Frontend Hotel Pages"


mkdir -p frontend/src/pages/hotels


cat > frontend/src/pages/hotels/Hotels.tsx <<'EOF'
export default function Hotels(){

return (

<div>

<h1>
Hotel Management
</h1>


<p>
Manage hotels and rooms.
</p>


</div>

)

}
EOF



echo ""
echo "📝 Creating Documentation"


cat > HOTEL_MANAGEMENT_MODULE.md <<'EOF'
# Hotel Management Module


## Features

Implemented:

- Hotel Entity
- Room Entity
- Hotel API
- Hotel DTO
- Frontend Hotel Page


## API


GET /api/hotels


GET /api/hotels/{id}


POST /api/hotels


DELETE /api/hotels/{id}


## Architecture


The module follows:

- Clean Architecture
- Domain Driven Design
- REST API principles


## Future

- Database persistence
- Image uploads
- Availability calendar
- Pricing engine

EOF



echo ""
echo "🧪 Backend validation"

dotnet build


echo ""
echo "🧪 Frontend validation"

cd frontend

npm run build

cd ..


mkdir -p scripts/reports


cat > scripts/reports/hotel-management-upgrade.md <<EOF
# Hotel Management Upgrade Report

Generated:
$(date)


Completed:

✅ Hotel Entity

✅ Room Entity

✅ Hotel API

✅ DTO Layer

✅ Frontend Hotel Page

✅ Documentation


Validation:

Backend build successful

Frontend build successful

Status:

Hotel Management foundation completed.
EOF



echo ""
echo "================================"
echo "✅ HOTEL MANAGEMENT COMPLETE"
echo "================================"
echo ""
echo "Created:"
echo "✔ Hotel Entity"
echo "✔ Room Entity"
echo "✔ Hotel API"
echo "✔ Frontend Hotel Page"
echo "✔ Documentation"
echo "✔ Validation Report"

