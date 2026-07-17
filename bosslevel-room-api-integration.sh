
#!/bin/bash

echo "🚀 ROOM MANAGEMENT API INTEGRATION"
echo "================================="


echo "🔧 Backend: RoomsController verbessern"

cat > Hotel.Api/Controllers/RoomsController.cs <<'CS'

using Microsoft.AspNetCore.Mvc;
using Hotel.Domain.Entities;
using Hotel.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/rooms")]
public class RoomsController : ControllerBase
{

    private readonly HotelDbContext _db;


    public RoomsController(
        HotelDbContext db
    )
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



    [HttpGet("hotel/{hotelId}")]
    public async Task<IActionResult> GetHotelRooms(Guid hotelId)
    {

        var rooms = await _db.Rooms
            .Where(x=>x.HotelId == hotelId)
            .ToListAsync();


        return Ok(rooms);

    }



    [HttpPost]
    public async Task<IActionResult> CreateRoom(Room room)
    {

        room.Id = Guid.NewGuid();

        _db.Rooms.Add(room);

        await _db.SaveChangesAsync();


        return Created(
            $"/api/rooms/{room.Id}",
            room
        );

    }



    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteRoom(Guid id)
    {

        var room = await _db.Rooms.FindAsync(id);


        if(room == null)
            return NotFound();


        _db.Rooms.Remove(room);

        await _db.SaveChangesAsync();


        return NoContent();

    }

}

CS



echo "🎨 Frontend Room API Service"


mkdir -p frontend/src/services


cat > frontend/src/services/api.ts <<'TS'

import axios from "axios";


const api = axios.create({

baseURL:"http://localhost:8080/api"

});


export default api;

TS



echo "🛏️ Updating Rooms Page"


cat > frontend/src/pages/Rooms.tsx <<'TSX'

import {useEffect,useState} from "react";
import api from "../services/api";


export default function Rooms(){

const [hotels,setHotels]=useState<any[]>([]);
const [rooms,setRooms]=useState<any[]>([]);


const [form,setForm]=useState({

hotelId:"",
name:"",
type:"",
pricePerNight:0,
capacity:1

});



useEffect(()=>{

api.get("/hotels")
.then(r=>setHotels(r.data));


api.get("/rooms")
.then(r=>setRooms(r.data));


},[]);



async function createRoom(){

await api.post("/rooms",form);


const res = await api.get("/rooms");

setRooms(res.data);


}



return (

<div>


<h1>🛏️ Room Management</h1>


<select

onChange={e=>setForm({
...form,
hotelId:e.target.value
})}

>

<option>
Select Hotel
</option>


{
hotels.map(h=>(

<option key={h.id} value={h.id}>
{h.name}
</option>

))
}


</select>



<input
placeholder="Room name"
onChange={e=>setForm({...form,name:e.target.value})}
/>


<input
placeholder="Type"
onChange={e=>setForm({...form,type:e.target.value})}
/>


<input
placeholder="Price"
type="number"
onChange={e=>setForm({...form,pricePerNight:Number(e.target.value)})}
/>


<input
placeholder="Capacity"
type="number"
onChange={e=>setForm({...form,capacity:Number(e.target.value)})}
/>



<button onClick={createRoom}>
Create Room
</button>



<h2>Existing Rooms</h2>


{
rooms.map(r=>(

<div key={r.id}>

🛏️ {r.name}
-
{r.type}
-
{r.pricePerNight}€

</div>

))
}



</div>

)

}

TSX



echo "🏗️ Build Frontend"

cd frontend

npm run build

cd ..



echo "🐳 Docker rebuild"

docker compose down

docker compose build --no-cache

docker compose up -d



echo ""
echo "🧪 TEST API"

sleep 5

curl -s http://localhost:8080/api/rooms | python3 -m json.tool



echo ""
echo "✅ ROOM API INTEGRATION COMPLETE"


