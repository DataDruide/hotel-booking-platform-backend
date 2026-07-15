using Hotel.Domain.Entities;
using HotelEntity = Hotel.Domain.Entities.Hotel;
using Microsoft.EntityFrameworkCore;
using Hotel.Application.Interfaces;
using Hotel.Infrastructure.Persistence;

namespace Hotel.Infrastructure.Repositories;

public class Repository<T> : IRepository<T>
where T : class
{
    private readonly HotelDbContext _context;

    public Repository(HotelDbContext context)
    {
        _context=context;
    }


    public async Task<IEnumerable<T>> GetAllAsync()
    {
        return await _context.Set<T>().ToListAsync();
    }


    public async Task<T?> GetByIdAsync(Guid id)
    {
        return await _context.Set<T>().FindAsync(id);
    }


    public async Task AddAsync(T entity)
    {
        await _context.Set<T>().AddAsync(entity);
    }


    public void Update(T entity)
    {
        _context.Set<T>().Update(entity);
    }


    public void Delete(T entity)
    {
        _context.Set<T>().Remove(entity);
    }
}
