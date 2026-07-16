#!/bin/bash

set -e

echo "🐳 HOTEL BOOKING PLATFORM DOCKER PRODUCTION UPGRADE"
echo "================================================="

ROOT=$(pwd)

echo "📁 Project:"
echo $ROOT


echo "🔎 Checking frontend"

if [ ! -d frontend ]; then
 echo "❌ Frontend missing"
 exit 1
fi


echo "🐳 Creating Frontend Dockerfile"


cat > frontend/Dockerfile <<'EOF'
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json .

RUN npm install

COPY .

RUN npm run build


FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx","-g","daemon off;"]
EOF



echo "🐳 Creating Backend Dockerfile"


cat > Hotel.Api/Dockerfile <<'EOF'
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

COPY . .

RUN dotnet restore

RUN dotnet publish -c Release -o /app


FROM mcr.microsoft.com/dotnet/aspnet:10.0

WORKDIR /app

COPY --from=build /app .

EXPOSE 8080

ENTRYPOINT ["dotnet","Hotel.Api.dll"]
EOF



echo "⚙️ Creating Environment Template"


cat > .env.example <<'EOF'
POSTGRES_DB=hotelbooking

POSTGRES_USER=hoteladmin

POSTGRES_PASSWORD=password

JWT_SECRET=CHANGE_ME

API_PORT=8080

FRONTEND_PORT=3000
EOF



echo "🐘 Creating docker-compose"


cat > docker-compose.yml <<'EOF'
services:


 postgres:

  image: postgres:16

  container_name: hotel-postgres

  environment:

   POSTGRES_DB: hotelbooking

   POSTGRES_USER: hoteladmin

   POSTGRES_PASSWORD: password

  ports:

   - "5432:5432"

  volumes:

   - postgres_data:/var/lib/postgresql/data



 redis:

  image: redis:7

  container_name: hotel-redis

  ports:

   - "6379:6379"



 backend:

  build:

   context: ./Hotel.Api

  container_name: hotel-api

  ports:

   - "8080:8080"

  depends_on:

   - postgres

   - redis



 frontend:

  build:

   context: ./frontend

  container_name: hotel-frontend

  ports:

   - "3000:80"

  depends_on:

   - backend



volumes:

 postgres_data:
EOF



echo "📚 Creating deployment documentation"


cat > DOCKER_DEPLOYMENT.md <<'EOF'
# Docker Deployment


## Architecture


Frontend

React + Vite

↓

Backend

ASP.NET Core API

↓

Database

PostgreSQL


Cache:

Redis


## Start System


docker compose up --build



## Services


Frontend

http://localhost:3000


Backend

http://localhost:8080


PostgreSQL

localhost:5432


Redis

localhost:6379



## Production Improvements

- Kubernetes
- CI/CD
- Secrets Management
- Monitoring
- Cloud Deployment

EOF



echo "🧪 Validation"


docker compose config


cd frontend

npm run build

cd ..


dotnet build



mkdir -p scripts/reports


cat > scripts/reports/docker-upgrade.md <<EOF

# Docker Upgrade Report


Created:

✅ Frontend Dockerfile

✅ Backend Dockerfile

✅ PostgreSQL Service

✅ Redis Service

✅ Environment Template

✅ Deployment Documentation


Validation:

docker compose config ✅

npm build ✅

dotnet build ✅


EOF



echo ""
echo "================================"
echo "✅ DOCKER PRODUCTION UPGRADE COMPLETE"
echo "================================"

