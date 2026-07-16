import {useEffect,useState} from "react";


export default function Dashboard(){

const [stats,setStats]=useState<any>(null);


useEffect(()=>{

const token=localStorage.getItem("token");


fetch("http://localhost:8080/api/dashboard/stats",
{
headers:{
Authorization:`Bearer ${token}`
}
})
.then(r=>r.json())
.then(setStats);


},[]);



if(!stats)
return <h1>Loading Dashboard...</h1>



return (

<div style={{padding:"40px"}}>

<h1>🏨 Hotel SaaS Dashboard</h1>

<h2>Booking Management Platform</h2>


<div style={{
display:"grid",
gridTemplateColumns:"repeat(5,1fr)",
gap:"20px",
marginTop:"40px"
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
