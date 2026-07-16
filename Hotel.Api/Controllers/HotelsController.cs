using Microsoft.AspNetCore.Mvc;
using HotelEntity = Hotel.Domain.Entities.Hotel;
using Hotel.Domain.Entities;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/hotels")]
public class HotelsController : ControllerBase
{

    private static readonly List<HotelEntity> Hotels = new();


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
    public IActionResult CreateHotel(HotelEntity hotel)
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
