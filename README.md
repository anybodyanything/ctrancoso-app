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

```

## API
```bash
cd server
cp .env .env
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
