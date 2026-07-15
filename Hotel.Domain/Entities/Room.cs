using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;

namespace Hotel.Domain.Entities;

public class Room
{
    public Guid Id { get; set; }


    public Guid HotelId { get; set; }

    public Hotel Hotel { get; set; } = null!;


    public string RoomNumber { get; set; } = string.Empty;


    public string Type { get; set; } = string.Empty;


    public decimal PricePerNight { get; set; }


    public int Capacity { get; set; }


    public bool IsAvailable { get; set; } = true;


    public ICollection<Booking> Bookings { get; set; } = new List<Booking>();
}
