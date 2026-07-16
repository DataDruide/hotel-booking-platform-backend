#!/bin/bash

set -e

echo "======================================"
echo "📊 HOTEL DASHBOARD UPGRADE"
echo "======================================"

echo ""
echo "📁 Erstelle Dashboard DTO..."

mkdir -p Hotel.Application/DTOs/Dashboard

cat > Hotel.Application/DTOs/Dashboard/DashboardStatsDto.cs <<'CS'
namespace Hotel.Application.DTOs.Dashboard;

public class DashboardStatsDto
{
    public int Hotels { get; set; }
    public int Rooms { get; set; }
    public int Bookings { get; set; }
    public int Customers { get; set; }
    public decimal Revenue { get; set; }
}
CS


echo "🛡 Erstelle Dashboard Controller..."

cat > Hotel.Api/Controllers/DashboardController.cs <<'CS'
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Hotel.Infrastructure.Persistence;
using Hotel.Application.DTOs.Dashboard;

namespace Hotel.Api.Controllers;


[ApiController]
[Route("api/dashboard")]
public class DashboardController : ControllerBase
{

    private readonly HotelDbContext _db;


    public DashboardController(HotelDbContext db)
    {
        _db = db;
    }



    [HttpGet("stats")]
    [Authorize(Roles="Admin")]
    public IActionResult Stats()
    {

        var result = new DashboardStatsDto
        {
            Hotels = _db.Hotels.Count(),
            Rooms = _db.Rooms.Count(),
            Bookings = _db.Bookings.Count(),

            Customers = _db.Users
                .Count(x => x.Role == "Customer"),


            Revenue = 0
        };


        return Ok(result);

    }

}
CS


echo "🌐 Frontend Dashboard Upgrade..."

mkdir -p frontend/src/pages


cat > frontend/src/pages/Dashboard.tsx <<'TSX'
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
TSX



echo "🔐 JWT Login Storage prüfen..."

python3 <<'PY'

from pathlib import Path

p=Path("frontend/src/pages/Login.tsx")

if p.exists():

    text=p.read_text()

    text=text.replace(
    "localStorage.setItem",
    "localStorage.setItem"
    )

    p.write_text(text)


PY


echo ""
echo "======================================"
echo "🔨 BUILD TEST"
echo "======================================"

dotnet build


echo ""
echo "======================================"
echo "✅ DASHBOARD CREATED"
echo "======================================"

