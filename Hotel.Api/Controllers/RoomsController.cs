using Microsoft.AspNetCore.Mvc;
using Hotel.Domain.Entities;
using Hotel.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

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
            .Include(x => x.Hotel)
            .Select(x => new
            {
                x.Id,
                x.HotelId,
                x.Name,
                x.Type,
                x.PricePerNight,
                x.Capacity,
                x.Available,

                Hotel = x.Hotel == null ? null : new
                {
                    x.Hotel.Id,
                    x.Hotel.Name,
                    x.Hotel.City,
                    x.Hotel.Country,
                    x.Hotel.Stars,
                    x.Hotel.Rating
                }
            })
            .ToListAsync();


        return Ok(rooms);
    }



    [HttpGet("hotel/{hotelId}")]
    public async Task<IActionResult> GetHotelRooms(Guid hotelId)
    {
        var rooms = await _db.Rooms
            .Where(x => x.HotelId == hotelId)
            .Select(x => new
            {
                x.Id,
                x.Name,
                x.Type,
                x.PricePerNight,
                x.Capacity,
                x.Available
            })
            .ToListAsync();


        return Ok(rooms);
    }



    [HttpPost]
    public async Task<IActionResult> CreateRoom(Room room)
    {
        room.Id = Guid.NewGuid();

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
