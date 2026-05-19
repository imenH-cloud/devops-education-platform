# 🌟 Horizons TSA - DevOps Education Platform

**Platform for managing specialized education activities with modern DevOps practices**

---

## 🎯 Project Overview

Horizons TSA is a comprehensive web platform built with modern DevOps architecture:

- **Frontend:** Angular 20
- **Backend:** 9 NestJS Microservices + API Gateway
- **Database:** PostgreSQL
- **Orchestration:** Kubernetes
- **DevOps:** Docker + ArgoCD (GitOps) + Jenkins CI/CD
- **Monitoring:** Prometheus + Grafana
- **Logging:** Elasticsearch + Kibana
- **Cache:** Redis
- **Project Management:** Jira SCRUM

---

## ✨ Features

### Activity Management ✅
- List all activities
- Add new activity with form validation
- Real-time list refresh
- Backend API integration

### Teacher Management ✅
- List all teachers
- Add new teacher with form validation
- Real-time list refresh
- API integration

### User System ✅
- Authentication & Authorization
- User profile menu
- Role-based access
- Logout functionality

### Supporting Modules ✅
- Student management
- Parent management
- Classroom management
- User management

---

## 🏗️ Architecture

```
┌──────────────────────┐
│   Angular Frontend   │
│  (Port 31927)        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   API Gateway        │
│  (Port 31000)        │
└─┬─────────┬─────────┬┘
  │         │         │
  ▼         ▼         ▼
┌────┐  ┌────┐  ┌────┐
│Act.│  │Tea.│  │Oth.│
│Svc│  │Svc │  │Svc │
└─┬──┘  └─┬──┘  └─┬──┘
  │       │       │
  └───────┼───────┘
          ▼
    ┌──────────────┐
    │ PostgreSQL   │
    │  Database    │
    └──────────────┘
```

---

## 🐳 Docker Images

**All images available on Docker Hub:** `eline2016`

```
✅ eline2016/horizons-frontend:v1
✅ eline2016/devopspfe-activity-service:v1
✅ eline2016/devopspfe-teacher-service:v1
✅ eline2016/devopspfe-gateway-backend:v1
✅ eline2016/devopspfe-auth-service:v1
✅ eline2016/devopspfe-user-service:v1
✅ eline2016/devopspfe-parent-service:v1
✅ eline2016/devopspfe-student-service:v1
✅ eline2016/devopspfe-classroom-service:v1
```

---

## 📂 Project Structure

```
.
├── frontend/                 # Angular application
│   ├── app/                 # Source code
│   ├── Dockerfile.prod      # Production build
│   └── nginx.conf           # Web server config
│
├── backend/                 # NestJS microservices
│   ├── activity/            # Activity service
│   ├── teacher/             # Teacher service
│   ├── gateway/             # API Gateway
│   ├── auth/                # Auth service
│   ├── user/                # User service
│   ├── parent/              # Parent service
│   ├── student/             # Student service
│   └── classroom/           # Classroom service
│
├── argocd/                  # ArgoCD configuration
│   ├── projects/            # AppProject definitions
│   ├── applications/        # Application manifests
│   └── configs/             # Configuration files
│
├── kubernetes/              # K8s manifests (optional)
│
├── Jenkinsfile              # CI/CD pipeline
└── README.md                # This file
```

---

## 🚀 Quick Start

### Prerequisites
```bash
# Docker Desktop (includes Kubernetes)
# Kubernetes cluster running
# kubectl configured
```

### Access Points
```
Frontend:   http://localhost:31927
Gateway:    http://localhost:31000
Grafana:    http://localhost:30500
Prometheus: http://localhost:30090
```

### Login Credentials
```
Username: admin@school.com
Password: admin12345
```

---

## 🔄 Deployment

### Via ArgoCD (GitOps)
```bash
# Apply AppProject
kubectl apply -f argocd/projects/education-app-project.yaml

# Apply Applications
kubectl apply -f argocd/applications/01-frontend.yaml
kubectl apply -f argocd/applications/02-all-services.yaml

# Verify
kubectl get applications -n argocd
```

### Via Kubernetes
```bash
kubectl apply -f kubernetes/
kubectl get pods -n education
```

### Via Jenkins CI/CD
```bash
# Trigger Jenkins pipeline
# Builds, tests, and deploys automatically
```

---

## 📊 Kubernetes Namespaces

```
✅ education    - Main application (10 pods)
✅ argocd      - GitOps deployment
✅ monitoring  - Prometheus + Grafana
✅ cache       - Redis
✅ logging     - Elasticsearch + Kibana
✅ jenkins     - CI/CD pipeline
```

---

## 🛠️ DevOps Stack

| Component | Purpose | Status |
|-----------|---------|--------|
| Docker | Containerization | ✅ |
| Kubernetes | Orchestration | ✅ |
| ArgoCD | GitOps | ✅ |
| Jenkins | CI/CD | ✅ |
| Prometheus | Metrics | ✅ |
| Grafana | Visualization | ✅ |
| Elasticsearch | Logs | ✅ |
| Kibana | Log UI | ✅ |
| Redis | Cache | ✅ |
| Jira | Project Mgmt | ✅ |

---

## 📚 Documentation

- **[KUBERNETES_NAMESPACES.md](KUBERNETES_NAMESPACES.md)** - All namespaces overview
- **[argocd/README_ARGOCD.md](argocd/README_ARGOCD.md)** - ArgoCD setup
- **[argocd/DEPLOYMENT_GUIDE.md](argocd/DEPLOYMENT_GUIDE.md)** - Deployment guide
- **[PROJECT_COMPLETION_SUMMARY.md](PROJECT_COMPLETION_SUMMARY.md)** - Final summary

---

## 🔗 Related Repositories

- **GitOps Config:** https://github.com/imenH-cloud/devops-education-platform-gitops
- **Docker Hub:** https://hub.docker.com/u/eline2016
- **Jira Board:** https://imen-hamada.atlassian.net/jira/software/projects/SCRUM/summary

---

## 📋 Useful Commands

```bash
# Check all pods
kubectl get pods -n education

# View logs
kubectl logs -n education deployment/frontend-app-deployment

# Port forward
kubectl port-forward svc/frontend-app 8080:3000 -n education

# Describe pod
kubectl describe pod <pod-name> -n education

# Check services
kubectl get svc -n education

# Verify deployment
kubectl rollout status deployment/frontend-app-deployment -n education
```

---

## 🎓 For Defense/Soutenance

✅ All services functional  
✅ Frontend responsive & working  
✅ Real-time CRUD operations  
✅ User profile menu implemented  
✅ Docker images pushed  
✅ ArgoCD configured  
✅ Monitoring operational  
✅ Documentation complete  

---

## 🤝 Team

**Student:** IMEN HAMADA  
**Project:** Horizons TSA - DevOps Education Platform  
**Date:** 2026-05-19  

---

## 📞 Support

For issues or questions:
1. Check logs: `kubectl logs -n education <pod>`
2. Check events: `kubectl get events -n education`
3. Review documentation in `/argocd/` folder
4. Check Jira board: https://imen-hamada.atlassian.net/

---

**Status:** ✅ Production Ready  
**Last Updated:** 2026-05-19

---

## 📖 License

Educational Project - Horizons TSA
