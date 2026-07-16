import {useEffect,useState} from "react";
import {api} from "../api/client";


export default function Dashboard(){

const [stats,setStats]=useState<any>(null);
const [error,setError]=useState("");


useEffect(()=>{


api.get("/dashboard/stats")
.then(res=>{
setStats(res.data);
})
.catch(err=>{
console.error(err);
setError("Dashboard konnte nicht geladen werden");
});


},[]);



if(error)
return <h1>{error}</h1>


if(!stats)
return <h1>Loading Dashboard...</h1>



return (

<div style={{padding:"40px"}}>

<h1>🏨 Hotel SaaS Dashboard</h1>


<div style={{
display:"grid",
gridTemplateColumns:"repeat(5,1fr)",
gap:"20px"
}}>

<Card title="Hotels" value={stats.hotels}/>
<Card title="Rooms" value={stats.rooms}/>
<Card title="Bookings" value={stats.bookings}/>
<Card title="Customers" value={stats.customers}/>
<Card title="Revenue" value={stats.revenue+" €"}/>


</div>

</div>

)

}



function Card({title,value}:any){

return (

<div style={{
padding:"25px",
border:"1px solid #ddd",
borderRadius:"12px"
}}>

<h3>{title}</h3>
<h1>{value}</h1>

</div>

)

}
