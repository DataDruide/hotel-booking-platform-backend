using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
using Hotel.Infrastructure.Persistence;


namespace Hotel.Infrastructure.Seed;


public static class DatabaseSeeder
{

public static void Seed(
HotelDbContext db)
{

if(!db.Hotels.Any())
{

db.Hotels.Add(
new Hotel.Domain.Entities.Hotel
{
Id=Guid.NewGuid(),
Name="Grand Berlin Hotel",
Description="Demo Hotel",
Stars=5
});


db.SaveChanges();

}

}

}
