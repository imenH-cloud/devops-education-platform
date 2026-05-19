# 🔧 Kubernetes Namespaces Configuration

## Overview

All Kubernetes namespaces for Horizons TSA project:

```
✅ education          - Main application (10 pods)
✅ argocd            - GitOps deployment
✅ monitoring        - Prometheus + Grafana
✅ cache             - Redis
✅ logging           - Elasticsearch + Kibana
✅ jenkins           - CI/CD pipeline
✅ message-queue     - Message broker
✅ filebeat          - Log shipping
✅ production        - Production deployments
```

---

## 📊 Namespace Details

### education (Main Application)
```
Pods:
- frontend-app-deployment
- activity-service-deployment
- teacher-service-deployment
- gateway-backend-deployment
- auth-service-deployment
- classroom-service-deployment
- parent-service-deployment
- student-service-deployment
- user-service-deployment
- postgres-deployment

Services: 10/10 running ✅
```

### argocd (GitOps)
```
Purpose: Automated deployment via GitOps
Apps: 9 microservices configured
Sync: Manual (safe for demo)
```

### monitoring (Observability)
```
- Prometheus: http://localhost:30090
- Grafana: http://localhost:30500
```

### cache (Redis)
```
- Redis: For caching and session management
```

### logging (ELK Stack)
```
- Elasticsearch: Search & analytics
- Kibana: Visualization
- Filebeat: Log shipping
```

---

## 🚀 Useful Commands

```bash
# List all namespaces
kubectl get namespaces

# Get pods in education namespace
kubectl get pods -n education

# Get resources by namespace
kubectl get all -n education
kubectl get all -n monitoring
kubectl get all -n cache

# View namespace usage
kubectl describe namespace education

# Port forward services
kubectl port-forward svc/prometheus -n monitoring 9090:9090
kubectl port-forward svc/grafana -n monitoring 3000:3000
kubectl port-forward svc/redis -n cache 6379:6379
kubectl port-forward svc/elasticsearch -n logging 9200:9200
kubectl port-forward svc/kibana -n logging 5601:5601
```

---

## 📈 Architecture

```
┌─────────────────────────────────────────┐
│        Kubernetes Cluster               │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ education (Main Apps)            │   │
│  │ - Frontend + 8 Services          │   │
│  │ - PostgreSQL                     │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ monitoring (Observability)       │   │
│  │ - Prometheus                     │   │
│  │ - Grafana                        │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ cache (Session & Cache)          │   │
│  │ - Redis                          │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ logging (Logs)                   │   │
│  │ - Elasticsearch                  │   │
│  │ - Kibana                         │   │
│  │ - Filebeat                       │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ argocd (GitOps)                  │   │
│  │ - ArgoCD Controller              │   │
│  │ - 9 Applications                 │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ jenkins (CI/CD)                  │   │
│  │ - Jenkins Master/Agents          │   │
│  └──────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

## 📝 Notes

- **education:** Production application namespace
- **monitoring:** Stack for observability and metrics
- **cache:** Redis for session/data caching
- **logging:** ELK stack for log aggregation
- **argocd:** GitOps declarative deployments
- **jenkins:** CI/CD pipeline automation
- **message-queue:** Message broker (RabbitMQ/Kafka)
- **production:** Additional production namespace (optional)

---

**Created:** 2026-05-19  
**Status:** All namespaces operational ✅
