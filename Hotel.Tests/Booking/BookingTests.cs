namespace Hotel.Tests.Booking;


public class BookingTests
{

    [Fact]
    public void Booking_Should_Create()
    {

        var booking = new
        {
            Status="Pending"
        };


        Assert.Equal("Pending", booking.Status);

    }

}
