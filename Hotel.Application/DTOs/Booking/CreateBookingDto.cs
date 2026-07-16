namespace Hotel.Application.DTOs.Booking;

public class CreateBookingDto
{
    public Guid HotelId { get; set; }

    public Guid RoomId { get; set; }

    public DateTime CheckIn { get; set; }

    public DateTime CheckOut { get; set; }
}
