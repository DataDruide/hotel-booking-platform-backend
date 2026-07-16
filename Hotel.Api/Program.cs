using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
using Hotel.Infrastructure;
using Hotel.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;



using Hotel.Api.Security;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<JwtService>();



builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();


builder.Services.AddInfrastructure(
    builder.Configuration.GetConnectionString("DefaultConnection")!
);



builder.Services
.AddAuthentication()
.AddJwtBearer();

builder.Services.AddAuthorization();


var app = builder.Build();


// Automatische EF Core Migration beim Start
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<HotelDbContext>();

    db.Database.Migrate();
}


app.UseSwagger();
app.UseSwaggerUI();


app.MapControllers();


app.Run();
