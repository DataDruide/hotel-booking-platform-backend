using Microsoft.AspNetCore.Mvc;
using Hotel.Application.DTOs.Booking;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/bookings")]
public class BookingsController : ControllerBase
{

    [HttpGet]
    public IActionResult GetBookings()
    {
        return Ok(new
        {
            message="Booking API ready"
        });
    }


    [HttpPost]
    public IActionResult CreateBooking(CreateBookingDto request)
    {

        return Ok(new
        {
            message="Booking created",
            booking=request
        });

    }


}
