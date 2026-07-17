import {
  BrowserRouter,
  Routes,
  Route
} from "react-router-dom";

import Login from "../pages/Login";
import Register from "../pages/Register";
import Dashboard from "../pages/Dashboard";
import Rooms from "../pages/Rooms";
import Hotels from "../pages/Hotels";


export default function AppRoutes(){

return (

<BrowserRouter>

<Routes>

<Route path="/" element={<Dashboard/>}/>

<Route path="/hotels" element={<Hotels/>}/>

<Route path="/rooms" element={<Rooms/>}/>
<Route path="/rooms" element={<Rooms/>}/>

<Route path="/login" element={<Login/>}/>

<Route path="/register" element={<Register/>}/>

</Routes>

</BrowserRouter>

)

}
