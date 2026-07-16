import {
  LayoutDashboard,
  Building2,
  BedDouble,
  CalendarDays,
  Users,
  Settings
} from "lucide-react";

export default function Sidebar(){

return (
<aside className="sidebar">

<div className="logo">
🏨 HotelOS
</div>


<nav>

<a className="active">
<LayoutDashboard size={20}/>
Dashboard
</a>

<a>
<Building2 size={20}/>
Hotels
</a>

<a>
<BedDouble size={20}/>
Rooms
</a>

<a>
<CalendarDays size={20}/>
Bookings
</a>

<a>
<Users size={20}/>
Customers
</a>

<a>
<Settings size={20}/>
Settings
</a>

</nav>


</aside>
)

}
