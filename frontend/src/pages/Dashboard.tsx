import {useEffect,useState} from "react";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";
import StatCard from "../components/StatCard";

import {
Building2,
BedDouble,
CalendarDays,
Users,
Euro
} from "lucide-react";


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
.then(setStats)
.catch(console.error);


},[]);



if(!stats)
return (
<div className="loading">
Loading Dashboard...
</div>
)



return (

<div className="layout">

<Sidebar/>


<main className="content">

<Header/>


<div className="cards">


<StatCard
title="Hotels"
value={stats.hotels}
icon={<Building2/>}
/>


<StatCard
title="Rooms"
value={stats.rooms}
icon={<BedDouble/>}
/>


<StatCard
title="Bookings"
value={stats.bookings}
icon={<CalendarDays/>}
/>


<StatCard
title="Customers"
value={stats.customers}
icon={<Users/>}
/>


<StatCard
title="Revenue"
value={`${stats.revenue} €`}
icon={<Euro/>}
/>


</div>


<div className="empty">

<h2>No data yet 🚀</h2>

<p>
Start by creating your first hotel.
</p>

</div>


</main>

</div>

)

}
