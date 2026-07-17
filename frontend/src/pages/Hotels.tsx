import {useEffect,useState} from "react";
import {api} from "../api/client";
import {Building2, Star} from "lucide-react";


export default function Hotels(){

const [hotels,setHotels]=useState<any[]>([]);


useEffect(()=>{

api.get("/hotels")
.then(res=>setHotels(res.data))
.catch(err=>console.error(err));

},[]);



return (

<div style={{padding:"40px"}}>

<h1>
🏨 Hotel Management
</h1>

<p>
Verwalte deine Hotels
</p>


<div style={{
display:"grid",
gridTemplateColumns:"repeat(3,1fr)",
gap:"24px",
marginTop:"30px"
}}>


{
hotels.map(hotel=>(

<div
key={hotel.id}
style={{
padding:"25px",
borderRadius:"16px",
background:"#fff",
boxShadow:"0 10px 30px rgba(0,0,0,.08)"
}}
>


<Building2 size={32}/>


<h2>
{hotel.name}
</h2>


<p>
{hotel.city}, {hotel.country}
</p>


<p>
{
Array.from({length:hotel.stars})
.map((_,i)=>
<Star key={i} size={18} fill="gold"/>
)
}
</p>


<p>
⭐ {hotel.rating}
</p>


</div>

))

}


</div>


</div>

)

}
