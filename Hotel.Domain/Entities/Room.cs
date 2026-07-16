namespace Hotel.Domain.Entities;

public class Room
{
    public Guid Id { get; set; }

    public Guid HotelId { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Type { get; set; } = string.Empty;

    public decimal PricePerNight { get; set; }

    public int Capacity { get; set; }

    public bool Available { get; set; }

    public Hotel? Hotel { get; set; }
}
