using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Hotel.Infrastructure.Persistence;
using Hotel.Application.DTOs.Dashboard;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/dashboard")]
public class DashboardController : ControllerBase
{

    private readonly HotelDbContext _db;


    public DashboardController(HotelDbContext db)
    {
        _db = db;
    }



    [HttpGet("stats")]
    [Authorize(Roles="Admin")]
    public IActionResult Stats()
    {

        var result = new DashboardStatsDto
        {
            Hotels = _db.Hotels.Count(),
            Rooms = _db.Rooms.Count(),
            Bookings = _db.Bookings.Count(),

            Customers = _db.Users
                .Count(x => x.Role == "Customer"),


            Revenue = 0
        };


        return Ok(result);

    }

}
