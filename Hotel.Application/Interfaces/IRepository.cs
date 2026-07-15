using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
namespace Hotel.Application.Interfaces;

public interface IRepository<T>
{
    Task<IEnumerable<T>> GetAllAsync();
    Task<T?> GetByIdAsync(Guid id);
    Task AddAsync(T entity);
    void Update(T entity);
    void Delete(T entity);
}
