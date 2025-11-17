# Architecture Overview

## System Architecture

This e-commerce platform follows a microservices architecture deployed on AWS EKS.

### High-Level Architecture

Internet → CloudFront → ALB → API Gateway → Microservices → Databases

### Components

#### Frontend

- React 18 SPA
- Deployed on CloudFront + S3
- Material-UI for components

#### API Gateway

- Rate limiting
- Request routing
- Authentication middleware
- Health checks

#### Microservices

1. **User Service** (Port 3001)

   - User registration/login
   - Profile management
   - JWT authentication

2. **Product Service** (Port 3002)

   - Product catalog
   - Inventory management
   - Search & filtering

3. **Order Service** (Port 3003)
   - Order creation
   - Order tracking
   - Order history

#### Data Layer

- **PostgreSQL (RDS)**: Primary database
- **Redis (ElastiCache)**: Caching layer
- **S3**: Static assets

### Infrastructure

- **EKS**: Kubernetes cluster
- **VPC**: Network isolation
- **ALB**: Load balancing
- **Route53**: DNS management
- **CloudWatch**: Monitoring & logging

### Security

- Secrets Manager for credentials
- Network policies for pod communication
- IAM roles for service accounts
- Encrypted data at rest and in transit
