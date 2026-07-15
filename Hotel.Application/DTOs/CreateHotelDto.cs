using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
namespace Hotel.Application.DTOs;


public record CreateHotelDto(
    string Name,
    string Description,
    int Stars
);
