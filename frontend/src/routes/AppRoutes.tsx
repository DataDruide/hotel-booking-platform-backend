import {
BrowserRouter,
Routes,
Route,
Navigate
}
from "react-router-dom";


import Login from "../pages/Login";
import Register from "../pages/Register";
import Dashboard from "../pages/Dashboard";


function ProtectedRoute({children}:any){

const token = localStorage.getItem("token");


if(!token){

return <Navigate to="/login"/>

}


return children;

}



export default function AppRoutes(){

return (

<BrowserRouter>

<Routes>


<Route 
path="/" 
element={<Navigate to="/login"/>}
/>



<Route 
path="/login" 
element={<Login/>}
/>



<Route 
path="/register" 
element={<Register/>}
/>



<Route 
path="/dashboard" 
element={
<ProtectedRoute>
<Dashboard/>
</ProtectedRoute>
}
/>


</Routes>

</BrowserRouter>

)

}
