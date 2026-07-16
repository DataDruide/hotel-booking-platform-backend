import {useState} from "react";
import {api} from "../api/client";
import {useNavigate} from "react-router-dom";


export default function Login(){

const [email,setEmail]=useState("admin@hotel.com");
const [password,setPassword]=useState("Test123!");
const [error,setError]=useState("");

const navigate = useNavigate();


async function login(){

try{

const res = await api.post("/auth/login",{
email,
password
});


localStorage.setItem(
"token",
res.data.accessToken
);


navigate("/dashboard");


}catch(e){

console.error(e);
setError("Login fehlgeschlagen");

}

}


return (

<div style={{padding:"40px"}}>

<h1>🏨 Hotel Booking Login</h1>


<input
value={email}
onChange={e=>setEmail(e.target.value)}
placeholder="Email"
/>


<br/>


<input
type="password"
value={password}
onChange={e=>setPassword(e.target.value)}
placeholder="Password"
/>


<br/>


<button onClick={login}>
Login
</button>


<p>{error}</p>


</div>

)

}
