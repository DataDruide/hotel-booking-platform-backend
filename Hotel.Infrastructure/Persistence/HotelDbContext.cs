using Hotel.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using HotelEntity = Hotel.Domain.Entities.Hotel;

namespace Hotel.Infrastructure.Persistence;

public class HotelDbContext : DbContext
{
    public HotelDbContext(
        DbContextOptions<HotelDbContext> options
    ) : base(options)
    {
    }


    public DbSet<Hotel.Domain.Entities.Hotel> Hotels { get; set; }

    public DbSet<Room> Rooms { get; set; }

    public DbSet<Booking> Bookings { get; set; }

public DbSet<ApplicationUser> Users { get; set; }


}
