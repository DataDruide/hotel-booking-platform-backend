namespace Hotel.Application.DTOs.Room;

public class CreateRoomDto
{
    public Guid HotelId { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Type { get; set; } = string.Empty;

    public decimal PricePerNight { get; set; }

    public int Capacity { get; set; }

    public bool Available { get; set; } = true;
}
