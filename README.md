# HORIZONS TSA - DevOps Project

## 📁 Clean Project Structure

```
devopsPFE/
├── backend/                              # 8 NestJS Microservices
│   ├── activity/                         # Activity Service (Port 3003)
│   ├── auth/                             # Auth Service (Port 3001)
│   ├── classroom/                        # Classroom Service (Port 3006)
│   ├── gateway/                          # API Gateway (Port 3000)
│   ├── parent/                           # Parent Service (Port 3004)
│   ├── student/                          # Student Service (Port 3005)
│   ├── teacher/                          # Teacher Service (Port 3007)
│   └── user/                             # User Service (Port 3002)
│
├── frontend/app/                         # Angular 20 Frontend (Port 4200)
│   ├── src/                              # Source code
│   ├── Dockerfile                        # Multi-stage production build
│   └── nginx.conf                        # Nginx configuration
│
├── kubernetes/                           # Kubernetes Manifests (Production)
│   ├── backend/                          # 8 microservice deployments
│   ├── frontend/                         # Frontend deployment
│   ├── database/                         # PostgreSQL deployment
│   ├── monitoring/                       # Prometheus + Grafana
│   ├── logging-messaging/                # Elasticsearch + Kibana + RabbitMQ
│   ├── argocd/                           # GitOps application configs
│   ├── configmap.yaml                    # Application configuration
│   ├── rbac.yaml                         # Role-based access control
│   ├── network-policies.yaml             # Network security policies
│   └── kustomization.yaml                # Kustomize orchestration
│
├── docker-compose.yml                    # Local development (all services)
├── Jenkinsfile                           # CI/CD pipeline (Jenkins)
├── .env.example                          # Environment variables template
├── .env.production                       # Production environment
└── _ARCHIVE/                             # Old/unused files

```

## 🚀 Quick Start

### Development (Docker Compose)
```bash
docker-compose up -d

# Access:
# Frontend: http://localhost:4200
# API Gateway: http://localhost:3000
# Grafana: http://localhost:3099
# Kibana: http://localhost:5601
```

### Production (Kubernetes)
```bash
kubectl apply -f kubernetes/

# Verify
kubectl get pods -n education
kubectl get svc -n education
```

### CI/CD (Jenkins)
- Builds 8 backend images + frontend (parallel)
- Runs Trivy security scans
- Pushes to Docker Hub
- Updates GitOps manifests
- ArgoCD auto-deploys

## 📦 Tech Stack

**Backend**: NestJS + TypeORM + PostgreSQL + Redis + RabbitMQ  
**Frontend**: Angular 20 + Material + NgRx  
**Infrastructure**: Docker + Kubernetes + Prometheus + Grafana + Elasticsearch + Kibana  
**CI/CD**: Jenkins + Docker Hub + ArgoCD

## 📊 Services

- **8 NestJS microservices** (3000–3007)
- **1 Angular frontend** (4200)
- **PostgreSQL** database (5432)
- **Redis** cache (6379)
- **RabbitMQ** message broker (5672)
- **Elasticsearch** logging (9200)
- **Kibana** dashboards (5601)
- **Prometheus** metrics (9090)
- **Grafana** monitoring (3099)

## 🔧 Development

Each backend service structure:
```
backend/{service}/
├── src/               # TypeScript source
├── Dockerfile         # Container build
└── package.json       # Dependencies
```

Run a service locally:
```bash
cd backend/auth
npm install
npm start:dev
```

## 📚 Documentation

See `_ARCHIVE/` for academic reports and detailed guides (archived for cleanup).
