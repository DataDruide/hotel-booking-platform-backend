using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Hotel.Infrastructure.Persistence;
using HotelEntity = Hotel.Domain.Entities.Hotel;

namespace Hotel.Api.Controllers;

[ApiController]
[Route("api/hotels")]
public class HotelsController : ControllerBase
{
    private readonly HotelDbContext _db;

    public HotelsController(HotelDbContext db)
    {
        _db = db;
    }


    [HttpGet]
    public async Task<IActionResult> GetHotels()
    {
        var hotels = await _db.Hotels
            .Include(x => x.Rooms)
            .ToListAsync();

        return Ok(hotels);
    }


    [HttpGet("{id}")]
    public async Task<IActionResult> GetHotel(Guid id)
    {
        var hotel = await _db.Hotels
            .Include(x => x.Rooms)
            .FirstOrDefaultAsync(x => x.Id == id);

        if (hotel == null)
            return NotFound();

        return Ok(hotel);
    }


    [HttpPost]
    public async Task<IActionResult> CreateHotel(HotelEntity hotel)
    {
        hotel.Id = Guid.NewGuid();

        _db.Hotels.Add(hotel);

        await _db.SaveChangesAsync();

        return Created(
            $"/api/hotels/{hotel.Id}",
            hotel
        );
    }


    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateHotel(
        Guid id,
        HotelEntity updatedHotel)
    {
        var hotel = await _db.Hotels
            .FirstOrDefaultAsync(x => x.Id == id);

        if (hotel == null)
            return NotFound();


        hotel.Name = updatedHotel.Name;
        hotel.Description = updatedHotel.Description;
        hotel.Address = updatedHotel.Address;
        hotel.City = updatedHotel.City;
        hotel.Country = updatedHotel.Country;
        hotel.Rating = updatedHotel.Rating;
        hotel.Stars = updatedHotel.Stars;


        await _db.SaveChangesAsync();

        return Ok(hotel);
    }


    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteHotel(Guid id)
    {
        var hotel = await _db.Hotels
            .FirstOrDefaultAsync(x => x.Id == id);

        if (hotel == null)
            return NotFound();


        _db.Hotels.Remove(hotel);

        await _db.SaveChangesAsync();

        return NoContent();
    }
}
