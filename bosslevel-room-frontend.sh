
#!/bin/bash

set -e

echo "🚀 ROOM MANAGEMENT FRONTEND"

cd frontend


mkdir -p src/pages


echo "🎨 Creating Rooms Page"


cat > src/pages/Rooms.tsx <<'TSX'
import {useEffect,useState} from "react";


export default function Rooms(){

const [rooms,setRooms]=useState<any[]>([]);


useEffect(()=>{

fetch("http://localhost:8080/api/rooms")
.then(r=>r.json())
.then(setRooms)
.catch(console.error);

},[]);



return (

<div style={{
padding:"40px"
}}>


<h1>
🛏️ Room Management
</h1>


<p>
Manage your hotel rooms
</p>



<div style={{
display:"grid",
gridTemplateColumns:"repeat(3,1fr)",
gap:"24px",
marginTop:"40px"
}}>


{
rooms.map(room=>(

<div
key={room.id}
style={{
padding:"25px",
borderRadius:"16px",
background:"#ffffff",
boxShadow:"0 8px 25px rgba(0,0,0,.08)"
}}
>


<h2>
{room.name}
</h2>


<p>
🏨 {room.hotel?.name ?? "Hotel"}
</p>


<p>
🏷️ Type: {room.type}
</p>


<p>
👥 Capacity: {room.capacity}
</p>


<h3>
💶 {room.pricePerNight} € / night
</h3>


<div>

{
room.available ?

<span style={{
color:"green"
}}>
● Available
</span>

:

<span style={{
color:"red"
}}>
● Occupied
</span>
}

</div>


</div>


))

}


</div>


</div>


)

}
TSX



echo "🔗 Add Route"


python3 <<'PY'

from pathlib import Path

p=Path("src/routes/AppRoutes.tsx")

text=p.read_text()


if 'Rooms from "../pages/Rooms"' not in text:
    text=text.replace(
    'import Dashboard from "../pages/Dashboard";',
    'import Dashboard from "../pages/Dashboard";\nimport Rooms from "../pages/Rooms";'
    )


text=text.replace(
'<Route path="/hotels" element={<Hotels/>}/>',
'<Route path="/hotels" element={<Hotels/>}/>\n\n<Route path="/rooms" element={<Rooms/>}/>'
)


p.write_text(text)

print("Route added")

PY



echo "🏗️ Build frontend"

npm run build


cd ..


echo "🐳 Docker rebuild"


docker compose down

docker compose build --no-cache

docker compose up -d



echo "⏳ Waiting"

sleep 5


echo ""
echo "===== TEST ====="


curl -s http://localhost:8080/api/rooms | python3 -m json.tool


echo ""

echo "✅ ROOM FRONTEND COMPLETE"

