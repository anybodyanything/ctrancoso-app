# ctrancoso-app

Projeto mínimo com:
- Client estático (HTML/CSS/JS)
- API Node.js (Express) com 2 rotas:
  - `GET /api/health` (sem DB)
  - `GET /api/db-time` (com Postgres)
- Postgres via Docker Compose
- 2 testes unitários (Jest + Supertest) para `/api/health` e `/api/db-Time`

## Requisitos
- Node.js 18+ (ou 20+)
- Docker / Docker Compose

## Subir a DB
```bash
docker compose up -d
Local development access (optional):

To allow your machine to access the database:

1. Find your public IP:
   https://whatismyip.com

2. Set it in terraform.tfvars:

local_ip = "YOUR_IP"

If not set, only Azure services (AKS, pipelines) can access the database.
```

## API
```bash
cd server
cp .env.example .env
npm install
npm run start
```

API em: http://localhost:3000

## Client
Serve estático (na raiz do projeto):
```bash
npx serve client
```

## Testes
```bash
cd server
npm test
```
