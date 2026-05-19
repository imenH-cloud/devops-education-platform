# 📊 HORIZONS TSA - PRESENTATION RESUME

## Project: DevOps Education Platform

**Student:** IMEN HAMADA  
**Date:** 2026-05-19  
**Duration:** 5 minutes (+ Q&A)

---

## 🎯 OVERVIEW (30 seconds)

"Horizons TSA is a web platform for managing specialized education activities. It demonstrates modern DevOps practices through microservices architecture, Kubernetes orchestration, and GitOps deployment."

**Tech Stack:**
- Frontend: Angular 20
- Backend: 9 NestJS microservices
- Database: PostgreSQL
- Orchestration: Kubernetes
- Monitoring: Prometheus + Grafana
- DevOps: Docker + ArgoCD

---

## 🏗️ ARCHITECTURE (1 minute)

```
┌─────────────────────────────────────┐
│    Angular Frontend                 │
│    (Teacher & Activity CRUD)        │
└─────────────────┬───────────────────┘
                  │ HTTP/REST
                  ▼
┌─────────────────────────────────────┐
│    API Gateway (NestJS)             │
│    Routes to microservices          │
└──┬──────────────┬──────────────┬────┘
   │              │              │
   ▼              ▼              ▼
Activity      Teacher        Other
Service       Service        Services
(3003)        (3007)         (3001-3006)
   │              │              │
   └──────────────┴──────────────┘
                  │
                  ▼
         PostgreSQL Database
         (Normalized schema)
```

**Key Patterns:**
- Microservices decoupling
- Service discovery via Kubernetes DNS
- Database per module (shared Postgres for demo)
- API Gateway pattern for unified interface

---

## 🎓 LIVE DEMO (3 minutes)

### Demo 1: Activity Management (1.5 min)
1. Open http://localhost:31927
2. Login: admin@school.com / admin12345
3. Navigate to "Activités & Suivi"
4. Show existing activities list
5. Click "+ Ajouter"
6. Fill form (show red asterisks on required fields)
7. Submit → redirects to list
8. **Result:** New activity visible in table ✅

**What's Happening Behind Scenes:**
- Angular form submits to Gateway (port 31000)
- Gateway routes to Activity Service (port 3003)
- Service validates and persists to PostgreSQL
- Frontend auto-reloads and displays new entry

### Demo 2: Teacher Management (1.5 min)
1. Navigate to "Intervenants spécialisés"
2. Show existing teachers list
3. Click "+ Ajouter"
4. Fill form (use unique email)
5. Submit → redirects to list
6. **Result:** New teacher visible in table ✅

**Validation Features:**
- Email must be unique (no duplicates)
- All required fields validated
- User feedback with form errors

---

## 📈 MONITORING (30 seconds)

### Prometheus
- Scrapes metrics from all services
- Tracks: CPU, Memory, Pod restarts, Request latencies
- Access: http://localhost:30090

### Grafana
- Visualizes Prometheus metrics
- Pre-connected to Prometheus
- Access: http://localhost:30500

**Metrics Available:**
- Service uptime
- Response times
- Error rates
- Resource utilization

---

## 🚀 DEVOPS HIGHLIGHTS (30 seconds)

### Docker
- Multi-stage builds for optimization
- Images tagged for registry
- Ready for production deployment

### Kubernetes
- 10 pods running in `education` namespace
- Service discovery via DNS
- Health checks & resource limits
- Auto-restart on failure

### ArgoCD (GitOps)
- All configs in version control
- Declarative deployment model
- Automated sync capability (currently disabled for safety)
- Fully configured, ready to enable

---

## 📝 KEY ACCOMPLISHMENTS

✅ **Functionality**
- Full CRUD for Activities
- Full CRUD for Teachers
- Real-time list refresh on add
- Form validation with user feedback

✅ **Infrastructure**
- 10 microservices running
- Kubernetes cluster operational
- Service-to-service communication
- Database persistence

✅ **DevOps**
- Docker images built & tagged
- Kubernetes manifests structured
- ArgoCD configuration complete
- Monitoring integrated

✅ **Documentation**
- Deployment guides
- Architecture diagrams
- Quick reference commands
- Soutenance checklist

---

## 🎯 TECHNICAL DECISIONS

### Why Microservices?
- Modularity: Each service independent
- Scalability: Scale services individually
- Resilience: Service failure doesn't crash entire app

### Why Kubernetes?
- Orchestration: Auto-restart, scaling, updates
- Service discovery: Internal DNS
- Resource management: CPU/Memory limits
- Production-ready: Industry standard

### Why ArgoCD?
- GitOps: Infrastructure as code
- Declarative: Define desired state
- Automated: Continuous reconciliation
- Auditable: All changes in Git

---

## 🔧 PRODUCTION READINESS

**What's Ready:**
- ✅ All services running
- ✅ Database migrations complete
- ✅ Docker images built
- ✅ Kubernetes manifests structured
- ✅ Monitoring configured

**Next Steps for Production:**
1. Push images to Docker Hub
2. Create Ingress for external access
3. Enable persistent volumes for Postgres
4. Setup CI/CD pipeline (GitHub Actions)
5. Configure TLS certificates

---

## 💡 LESSONS LEARNED

1. **API Response Formats Matter**
   - Different services return different formats
   - Always map/transform responses

2. **Form Validation Critical**
   - Required fields clearly marked (red asterisks)
   - Prevent submission on errors
   - User-friendly error messages

3. **Service Communication**
   - API Gateway simplifies frontend integration
   - Service-to-service via internal DNS

4. **Database Constraints**
   - Nullable columns for optional fields
   - Unique constraints for data integrity

5. **Testing Before Demo**
   - Always verify all pods running
   - Test login and main flows
   - Have fallback commands ready

---

## ⏱️ TIMELINE

**Today's Session:**
- Fixed Activity/Teacher forms ✅
- Created list components ✅
- Fixed API routing ✅
- Tested complete flows ✅
- Created ArgoCD config ✅
- Documentation complete ✅

**Previous Work:**
- Backend microservices built (3007+)
- Kubernetes setup (1 week)
- Database design (3 days)
- Frontend development (2 weeks)

---

## 🎓 QUESTIONS LIKELY

**Q: Why separate services?**
A: Each service is independently deployable, scalable, and maintainable. Allows teams to work in parallel.

**Q: How does frontend find services?**
A: Through API Gateway on port 31000. Gateway internally routes to specific microservices.

**Q: What if a service fails?**
A: Kubernetes automatically restarts it. Pod is recreated within seconds.

**Q: How do you manage database schemas?**
A: TypeORM migrations run on startup. Ensures schema is always up-to-date.

**Q: Can you scale this to production?**
A: Yes! Add persistent volumes for Postgres, enable ArgoCD, setup CI/CD pipeline, configure Ingress.

---

## 📞 EMERGENCY COMMANDS

If something doesn't work during presentation:

```bash
# Check everything
kubectl get all -n education

# Restart all pods
kubectl rollout restart deployment --all -n education

# View frontend logs
kubectl logs -n education deployment/frontend-app-deployment

# Port forward if NodePort not working
kubectl port-forward svc/frontend-app 8080:3000 -n education
```

---

## 🎬 PRESENTATION TIMING

| Segment | Duration |
|---------|----------|
| Introduction | 30s |
| Architecture | 1 min |
| Demo Activity | 1.5 min |
| Demo Teacher | 1.5 min |
| Monitoring | 30s |
| Highlights | 30s |
| **Total** | **5 min** |

Q&A: Remaining time

---

## 🏆 FINAL MESSAGE

"This project demonstrates end-to-end DevOps practices:
- **Design:** Microservices architecture
- **Development:** Modern frameworks (Angular, NestJS)
- **Deployment:** Kubernetes orchestration
- **Operations:** GitOps with ArgoCD
- **Monitoring:** Prometheus + Grafana

The entire stack is containerized, orchestrated, monitored, and ready for production deployment."

---

**Good luck with your soutenance! 🍀**

**Remember:** The system is already running. Show it working, not just talking about it!
