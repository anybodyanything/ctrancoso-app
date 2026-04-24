# ctrancoso-app

DevOps challenge solution implementing a full cloud-native deployment on Azure.

Includes:
- Static frontend (HTML/CSS/JS served via Nginx)
- Node.js backend API
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
Get your <your-ingress-host> with:
```bash
kubectl get svc -n ingress-nginx
```
Copy ingress-nginx-controller EXTERNAL - IP.

### Endpoints

| Service   | URL |
|----------|-----|
| Frontend | http://<your-ingress-host>/ |
| Health   | http://<your-ingress-host>/api/health |
| DB Test  | http://<your-ingress-host>/api/db-time |
| Grafana  | http://<your-ingress-host>/grafana |

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

##CI Approval Flow (to be finished)
- terraform plan runs automatically
- terraform apply requires manual approval

#Application Deployment
##Step 1 — Build & Push Images

Workflow: Build and Push Images

Inputs:
```bash
env: dev | prod - mandatory
deploy_aks: true | false
````

Outputs:
```bash
<ACR>/backend:<commit-sha>
<ACR>/frontend:<commit-sha>
````

##Step 2 — Deploy to AKS
For automatic deployment after Build and Push
```bash
deploy_aks = true
````
For manual use the workflow Deploy App to AKS
```bash
env: dev | prod  - mandatory
image_tag: <tag> - mandatory
````

#Logs & Uptime
##Healthcheck
```bash
curl http://<your-ingress-host>/api/health
````

##Logs
Backend
```bash
kubectl logs -l app=backend
kubectl logs -f deployment/backend
````

Frontend
```bash
kubectl logs -l app=frontend
````

#Monitoring
- Prometheus for metrics
- Grafana for dashboards

##Access
```bash
http://<your-ingress-host>/grafana
````

Credentials
```bash
username: admin
password: defined via Terraform variable
````

#Environments

##Supported environments:
dev and prod

Each environment includes:

- Separate AKS cluster
- Separate ACR
- Separate PostgreSQL instance

#Configuration

##GitHub Secrets
- AZURE_CLIENT_ID
- AZURE_TENANT_ID
- AZURE_SUBSCRIPTION_ID

#GitHub Variables
ENV is replaced with target environment directly by the deploy pipelines
- ACR_NAME_{ENV}
- ACR_LOGIN_SERVER_{ENV}
- RESOURCE_GROUP_{ENV}
- AKS_CLUSTER_NAME_{ENV}

##Terraform Variables (example)
```bash
image_ref               = "<acr>/backend:dev"
frontend_image_ref      = "<acr>/frontend:dev"
grafana_admin_password  = "change-me"
````
⚠️ Do not store secrets in the remote repository.

#Notes
- Infrastructure is reproducible via Terraform
- Deployments are fast via Kubernetes
- CI/CD ensures code quality
- Monitoring provides observability