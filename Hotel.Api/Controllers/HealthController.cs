using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
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
