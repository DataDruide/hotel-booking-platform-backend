using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using Hotel.Infrastructure.Persistence;

namespace Hotel.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        string connectionString)
    {

        services.AddDbContext<HotelDbContext>(
            options =>
            options.UseNpgsql(connectionString)
        );


        return services;
    }
}
