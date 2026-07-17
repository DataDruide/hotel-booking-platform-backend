
#!/bin/bash

set -e

echo "🔧 Fix Room Management Module"

echo "➡️ Update CreateRoomDto"


cat > Hotel.Application/DTOs/Room/CreateRoomDto.cs <<'CS'
namespace Hotel.Application.DTOs.Room;

public class CreateRoomDto
{
    public Guid HotelId { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Type { get; set; } = string.Empty;

    public decimal PricePerNight { get; set; }

    public int Capacity { get; set; }

    public bool Available { get; set; } = true;
}
CS



echo "➡️ Update RoomsController"


cat > Hotel.Api/Controllers/RoomsController.cs <<'CS'
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Hotel.Infrastructure.Persistence;
using Hotel.Domain.Entities;
using Hotel.Application.DTOs.Room;


namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/rooms")]
public class RoomsController : ControllerBase
{

    private readonly HotelDbContext _db;


    public RoomsController(HotelDbContext db)
    {
        _db = db;
    }



    [HttpGet]
    public async Task<IActionResult> GetRooms()
    {
        var rooms = await _db.Rooms
            .Include(x=>x.Hotel)
            .ToListAsync();

        return Ok(rooms);
    }



    [HttpPost]
    public async Task<IActionResult> CreateRoom(
        CreateRoomDto dto
    )
    {

        var room = new Room
        {
            Id = Guid.NewGuid(),

            HotelId = dto.HotelId,

            Name = dto.Name,

            Type = dto.Type,

            PricePerNight = dto.PricePerNight,

            Capacity = dto.Capacity,

            Available = dto.Available
        };


        _db.Rooms.Add(room);

        await _db.SaveChangesAsync();


        return Created(
            $"/api/rooms/{room.Id}",
            room
        );
    }



    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteRoom(Guid id)
    {

        var room = await _db.Rooms.FindAsync(id);


        if(room == null)
            return NotFound();


        _db.Rooms.Remove(room);

        await _db.SaveChangesAsync();


        return NoContent();
    }

}
CS



echo "🐳 Rebuild Docker"


docker compose down

docker compose build --no-cache

docker compose up -d


echo "⏳ Waiting API"

sleep 5


echo ""
echo "===== ROOM API TEST ====="


curl -s http://localhost:8080/api/rooms | python3 -m json.tool



echo ""

echo "✅ ROOM MODULE FIXED"

