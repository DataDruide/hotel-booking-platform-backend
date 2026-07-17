
#!/bin/bash

set -e

echo "🚀 ROOM CRUD FRONTEND"


cd frontend


cat > src/pages/Rooms.tsx <<'TSX'
import {useEffect,useState} from "react";


export default function Rooms(){

const [rooms,setRooms]=useState<any[]>([]);
const [hotels,setHotels]=useState<any[]>([]);


const [form,setForm]=useState({
hotelId:"",
name:"",
type:"",
pricePerNight:0,
capacity:1,
available:true
});



const load=()=>{

fetch("http://localhost:8080/api/rooms")
.then(r=>r.json())
.then(setRooms);


fetch("http://localhost:8080/api/hotels")
.then(r=>r.json())
.then(setHotels);

};



useEffect(()=>{

load();

},[]);



const createRoom=async()=>{


await fetch(
"http://localhost:8080/api/rooms",
{
method:"POST",
headers:{
"Content-Type":"application/json"
},
body:JSON.stringify(form)
}
);


load();


};



return (

<div style={{padding:"40px"}}>


<h1>🛏️ Room Management</h1>



<div style={{
background:"#fff",
padding:"25px",
borderRadius:"16px",
marginBottom:"40px"
}}>


<h2>Create Room</h2>


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
hotels.map(h=>
<option key={h.id} value={h.id}>
{h.name}
</option>
)
}


</select>



<input
placeholder="Room name"
onChange={e=>setForm({
...form,
name:e.target.value
})}
/>



<input
placeholder="Type"
onChange={e=>setForm({
...form,
type:e.target.value
})}
/>



<input
type="number"
placeholder="Price"
onChange={e=>setForm({
...form,
pricePerNight:Number(e.target.value)
})}
/>



<input
type="number"
placeholder="Capacity"
onChange={e=>setForm({
...form,
capacity:Number(e.target.value)
})}
/>



<button onClick={createRoom}>
Create Room
</button>



</div>





<div style={{
display:"grid",
gridTemplateColumns:"repeat(3,1fr)",
gap:"20px"
}}>


{
rooms.map(room=>(


<div
key={room.id}
style={{
padding:"20px",
borderRadius:"15px",
background:"#fff",
boxShadow:"0 5px 20px #ddd"
}}
>


<h2>
{room.name}
</h2>


<p>
🏷️ {room.type}
</p>


<p>
💶 {room.pricePerNight} €
</p>


<p>
👥 {room.capacity}
</p>


</div>


))
}


</div>


</div>

)

}
TSX



echo "🏗 Build"


npm run build


cd ..


echo "🐳 Docker"


docker compose down

docker compose build --no-cache

docker compose up -d



echo "✅ ROOM CRUD READY"

