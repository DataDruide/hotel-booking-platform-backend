
#!/bin/bash

set -e

echo "🚀 HOTEL PLATFORM BOSSLEVEL - ROOM MANAGEMENT MODULE"
echo "==================================================="


echo "🏗️ Backend vorbereiten..."


mkdir -p Hotel.Application/DTOs/Room
mkdir -p Hotel.Api/Controllers


cat > Hotel.Application/DTOs/Room/CreateRoomDto.cs <<'CS'
namespace Hotel.Application.DTOs.Room;

public class CreateRoomDto
{
    public Guid HotelId { get; set; }

    public string Number { get; set; } = string.Empty;

    public string Category { get; set; } = string.Empty;

    public decimal PricePerNight { get; set; }

    public string Status { get; set; } = "Available";
}
CS



cat > Hotel.Api/Controllers/RoomsController.cs <<'CS'
using Microsoft.AspNetCore.Mvc;
using Hotel.Infrastructure.Persistence;
using Hotel.Domain.Entities;
using Hotel.Application.DTOs.Room;
using Microsoft.EntityFrameworkCore;


namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/rooms")]
public class RoomsController : ControllerBase
{

    private readonly HotelDbContext _db;


    public RoomsController(HotelDbContext db)
    {
        _db = db;
    }



    [HttpGet]
    public async Task<IActionResult> GetRooms()
    {
        var rooms = await _db.Rooms
            .Include(x=>x.Hotel)
            .ToListAsync();


        return Ok(rooms);
    }




    [HttpPost]
    public async Task<IActionResult> CreateRoom(
        CreateRoomDto dto
    )
    {

        var room = new Room
        {
            Id = Guid.NewGuid(),
            HotelId = dto.HotelId,
            Number = dto.Number,
            Category = dto.Category,
            PricePerNight = dto.PricePerNight,
            Status = dto.Status
        };


        _db.Rooms.Add(room);

        await _db.SaveChangesAsync();


        return Created(
            $"/api/rooms/{room.Id}",
            room
        );
    }


}
CS



echo "🎨 Frontend Rooms Page"



mkdir -p frontend/src/pages


cat > frontend/src/pages/Rooms.tsx <<'TSX'
import {useEffect,useState} from "react";


export default function Rooms(){

const [rooms,setRooms]=useState<any[]>([]);



useEffect(()=>{

fetch("http://localhost:8080/api/rooms")
.then(r=>r.json())
.then(setRooms);

},[]);



return (

<div style={{padding:"40px"}}>

<h1>
🛏️ Room Management
</h1>

<p>
Verwalte deine Hotelzimmer
</p>


<div
style={{
display:"grid",
gap:"20px"
}}
>

{
rooms.map(room=>(

<div
key={room.id}
style={{
padding:"20px",
border:"1px solid #ddd",
borderRadius:"12px"
}}
>

<h2>
Zimmer {room.number}
</h2>


<p>
{room.category}
</p>


<p>
💶 {room.pricePerNight} € / Nacht
</p>


<p>
Status:
{room.status}
</p>


</div>

))
}


</div>


</div>

)

}
TSX



echo "🔗 Route ergänzen"


python3 <<'PY'

from pathlib import Path

p=Path("frontend/src/routes/AppRoutes.tsx")

text=p.read_text()

if 'import Rooms' not in text:
    text=text.replace(
    'import Dashboard from "../pages/Dashboard";',
    'import Dashboard from "../pages/Dashboard";\nimport Rooms from "../pages/Rooms";'
    )


text=text.replace(
'<Route path="/hotels" element={<Hotels/>}/>',
'<Route path="/hotels" element={<Hotels/>}/>\n<Route path="/rooms" element={<Rooms/>}/>'
)


p.write_text(text)

PY



echo "🐳 Docker Build"



docker compose down

docker compose build --no-cache

docker compose up -d



echo "⏳ API warten"

sleep 5



echo ""
echo "===== HOTEL TEST ====="

curl -s http://localhost:8080/api/hotels | python3 -m json.tool


echo ""
echo "===== ROOM TEST ====="

curl -s http://localhost:8080/api/rooms | python3 -m json.tool



echo ""

echo "✅ ROOM MANAGEMENT MODULE COMPLETE"

