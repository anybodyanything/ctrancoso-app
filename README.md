# ctrancoso-app

DevOps challenge solution implementing a full cloud-native deployment on Azure.

Includes:
- Static frontend (HTML/CSS/JS served via Nginx)
- Node.js (Express) backend API
- PostgreSQL database (Azure)
- Kubernetes (AKS) deployment
- Terraform for infrastructure
- GitHub Actions CI/CD
- Prometheus + Grafana monitoring

---

# Architecture

## Overview

The application follows a simple cloud-native architecture:

- Frontend served via Nginx (Kubernetes)
- Backend API exposed under `/api`
- PostgreSQL hosted in Azure
- NGINX Ingress for routing
- Monitoring via Prometheus + Grafana

## Flow

```text
User (Browser)
        |
        v
NGINX Ingress (AKS)
   |         |
   |         |
   v         v
Frontend   Backend (/api)
              |
              v
        PostgreSQL (Azure)
```

---

# Endpoints
- http://<INGRESS_IP>/ Frontend
- http://<INGRESS_IP>/api/health Healthcheck
- http://<INGRESS_IP>/api/db-time DB test
- http://<INGRESS_IP>/grafana Monitoring- http://<INGRESS_IP>/ Frontend
- http://<INGRESS_IP>/api/health Healthcheck
- http://<INGRESS_IP>/api/db-time DB test
- http://<INGRESS_IP>/grafana Monitoring

---
# Local Development

## Requirements

- Node.js 18+
- Docker / Docker Compose

## Start Database

```bash
docker compose up -d
```
## Run Backend
```bash
cd server
npm install
npm start
```

API:
http://localhost:3000

##Run Frontend
```bash
cd client
npx serve client
```

##Tests
```bash
cd server
npm test
````
Requires new npm install in case you haven't done yet.

In CI/CD, the pipeline runs the tests, and if not passed, the build stops, and images are not pushed to ACR.

#Infrastructure (Terraform)
##Components
- AKS (Kubernetes cluster)
- ACR (Container Registry)
- PostgreSQL (Azure)
- Ingress Controller
- Monitoring (Prometheus + Grafana)

#Deploy infrastructure
```bash
cd .\terraform\envs\*
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
````