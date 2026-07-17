
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

