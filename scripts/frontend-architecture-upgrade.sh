#!/bin/bash

set -e

echo "🚀 FRONTEND ARCHITECTURE GOD MODE"
echo "================================="

if [ ! -d frontend ]; then
echo "❌ Frontend missing"
exit 1
fi


cd frontend


echo "📦 Installing frontend dependencies"

npm install axios react-router-dom zustand


echo "📁 Creating architecture"

mkdir -p src/api
mkdir -p src/store
mkdir -p src/pages
mkdir -p src/routes
mkdir -p src/components
mkdir -p src/types



cat > src/api/client.ts <<'EOF'
import axios from "axios";

export const api = axios.create({
 baseURL:"http://localhost:5096/api"
});


api.interceptors.request.use(config=>{

const token =
localStorage.getItem("token");

if(token){
config.headers.Authorization =
`Bearer ${token}`;
}

return config;

});
EOF



cat > src/store/auth.ts <<'EOF'
import {create} from "zustand";


interface AuthStore {

token:string|null;

login:(token:string)=>void;

logout:()=>void;

}



export const useAuth =
create<AuthStore>((set)=>({

token:
localStorage.getItem("token"),


login:(token)=>{

localStorage.setItem(
"token",
token
);

set({
token
});

},


logout:()=>{

localStorage.removeItem(
"token"
);

set({
token:null
});

}


}));
EOF



cat > src/pages/Login.tsx <<'EOF'
export default function Login(){

return (

<div>

<h1>
Hotel Booking Login
</h1>

<p>
JWT Authentication Ready
</p>

</div>

)

}
EOF



cat > src/pages/Register.tsx <<'EOF'
export default function Register(){

return (

<div>

<h1>
Create Account
</h1>

</div>

)

}
EOF



cat > src/pages/Dashboard.tsx <<'EOF'
export default function Dashboard(){

return (

<div>

<h1>
Hotel SaaS Dashboard
</h1>

<p>
Booking Management Platform
</p>

</div>

)

}
EOF



cat > src/routes/AppRoutes.tsx <<'EOF'
import {
BrowserRouter,
Routes,
Route
}
from "react-router-dom";

import Login from "../pages/Login";
import Register from "../pages/Register";
import Dashboard from "../pages/Dashboard";


export default function AppRoutes(){

return (

<BrowserRouter>

<Routes>

<Route path="/" element={<Dashboard/>}/>

<Route path="/login" element={<Login/>}/>

<Route path="/register" element={<Register/>}/>

</Routes>

</BrowserRouter>

)

}
EOF



echo "🔧 Updating App.tsx"


cat > src/App.tsx <<'EOF'
import AppRoutes from "./routes/AppRoutes";


function App(){

return <AppRoutes/>

}


export default App;
EOF



echo "🧪 Frontend build"

npm run build


cd ..


echo "🧪 Backend build"

dotnet build



mkdir -p scripts/reports


cat > scripts/reports/frontend-architecture.md <<EOF
# Frontend Architecture Upgrade

Created:

✅ React Router
✅ Axios API Client
✅ Zustand State Management
✅ Authentication Store
✅ Login Page
✅ Register Page
✅ Dashboard Page

Validation:

Frontend:
npm build ✅

Backend:
dotnet build ✅

EOF



echo ""
echo "================================"
echo "✅ FRONTEND ARCHITECTURE DONE"
echo "================================"

