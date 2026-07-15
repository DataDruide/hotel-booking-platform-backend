using HotelEntity = Hotel.Domain.Entities.Hotel;
using Microsoft.AspNetCore.Mvc;
using Hotel.Infrastructure.Persistence;

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
    public IActionResult Get()
    {
        return Ok(_db.Hotels.ToList());
    }

    [HttpPost]
    public async Task<IActionResult> Create(HotelEntity hotel)
    {
        hotel.Id = Guid.NewGuid();

        await _db.Hotels.AddAsync(hotel);
        await _db.SaveChangesAsync();

        return Ok(hotel);
    }
}
