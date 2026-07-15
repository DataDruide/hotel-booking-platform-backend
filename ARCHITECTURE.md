# Software Architecture

## Hotel Booking Platform Backend

Professional backend system built with Clean Architecture principles.

## Architecture Layers

### Hotel.Domain

Core business layer.

Responsibilities:

- Entities
- Business rules
- Domain models


### Hotel.Application

Application logic layer.

Responsibilities:

- DTOs
- Services
- Use Cases
- Validation


### Hotel.Infrastructure

Infrastructure layer.

Responsibilities:

- Entity Framework Core
- Database access
- Persistence
- External integrations


### Hotel.Api

Presentation layer.

Responsibilities:

- REST API
- Controllers
- Authentication
- Authorization


## Engineering Principles

Implemented:

- Clean Architecture
- SOLID Principles
- Dependency Injection
- REST API Design
- Separation of Concerns


## Security Architecture

Implemented:

- JWT Authentication
- BCrypt Password Hashing
- Role based authorization


## Database

Technology:

- Entity Framework Core
- PostgreSQL compatible architecture


## Testing

Included:

- Automated build verification
- Unit test project


## Future Scaling

Possible extensions:

- Redis caching
- Refresh Tokens
- Kubernetes deployment
- CI/CD pipelines
- Microservice extraction

