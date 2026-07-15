using Hotel.Domain.Entities;
namespace Hotel.Domain.Entities;

public class Hotel
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    public string Address { get; set; } = string.Empty;

    public string City { get; set; } = string.Empty;

    public string Country { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;


    public ICollection<Room> Rooms { get; set; } = new List<Room>();

    public int Stars { get; set; }
}
