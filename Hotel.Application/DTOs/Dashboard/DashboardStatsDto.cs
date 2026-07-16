namespace Hotel.Application.DTOs.Dashboard;

public class DashboardStatsDto
{
    public int Hotels { get; set; }
    public int Rooms { get; set; }
    public int Bookings { get; set; }
    public int Customers { get; set; }
    public decimal Revenue { get; set; }
}
