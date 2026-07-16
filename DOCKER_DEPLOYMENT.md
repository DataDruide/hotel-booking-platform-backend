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

