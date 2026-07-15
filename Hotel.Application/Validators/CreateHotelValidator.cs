using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
using FluentValidation;
using Hotel.Application.DTOs;


namespace Hotel.Application.Validators;


public class CreateHotelValidator 
: AbstractValidator<CreateHotelDto>
{

    public CreateHotelValidator()
    {
        RuleFor(x=>x.Name)
            .NotEmpty()
            .MinimumLength(3);


        RuleFor(x=>x.Stars)
            .InclusiveBetween(1,5);
    }

}
