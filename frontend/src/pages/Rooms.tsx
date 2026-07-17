
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

