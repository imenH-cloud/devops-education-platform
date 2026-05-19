# 🎬 COMMANDES SOUTENANCE - Ready to Copy-Paste

Utilisez ce document pendant la soutenance pour démonstrations en direct.

---

## 📺 DEMO 1: Vérification Infrastructure

```bash
# === DEMO 1.1: Cluster Health ===
kubectl cluster-info
kubectl get nodes -o wide

# === DEMO 1.2: Namespaces ===
kubectl get namespaces

# === DEMO 1.3: Tous les pods (education namespace) ===
kubectl get pods -n education -o wide

# === DEMO 1.4: Voir les services exposés ===
kubectl get svc -n education | grep NodePort
kubectl get svc -n monitoring | grep NodePort
kubectl get svc -n argocd | grep NodePort

# === DEMO 1.5: Detailed pod info (choose one service) ===
kubectl describe pod <pod-name> -n education
kubectl logs <pod-name> -n education --tail=20
```

---

## 🌐 DEMO 2: Applications Web

### **2.1 Frontend Angular**
```
URL: http://localhost:31927
Credentials: (check your app)
Demo Flow:
  1. Show login page (Angular UI)
  2. Login with test user
  3. Navigate dashboards (parent/teacher/student views)
  4. Show activity tracking
  5. Show reports
```

### **2.2 API Gateway**
```bash
# Test API endpoints through Gateway
curl -X GET http://localhost:31000/api/health

# If available:
curl -X GET http://localhost:31000/api/users
curl -X POST http://localhost:31001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"teacher1","password":"pass123"}'
```

---

## 📊 DEMO 3: Monitoring (Prometheus)

```
URL: http://localhost:30090

In Prometheus UI:
1. Click "Graph" tab
2. Type query:
   - up (shows all scrape targets)
   - container_memory_usage_bytes (memory usage)
   - http_requests_total (API calls)
   - process_resident_memory_bytes (process memory)

3. Click "Execute" → See metrics as graphs

Commands:
```bash
# Query Prometheus API directly
curl 'http://localhost:30090/api/v1/query?query=up'

# List all scrape targets
curl 'http://localhost:30090/api/v1/targets'
```

---

## 📈 DEMO 4: Grafana Dashboards

```
URL: http://localhost:30500
Default login: admin / admin (or your credentials)

Dashboard walkthrough:
1. Homepage → See available dashboards
2. Open "Platform Metrics" or custom dashboard
3. Show:
   - CPU usage (all pods)
   - Memory consumption (per service)
   - Network I/O
   - Request latency
   - Error rates

Features to showcase:
- Time range picker (change 1h, 1d, 1w)
- Drill down on pod names
- Export metrics
```

### **Alternative: Manual Dashboard Creation**
```bash
# If dashboard not pre-made, create one:
1. Grafana UI → Dashboards → New Dashboard
2. Add Panel → Prometheus
3. Query: rate(http_requests_total[5m])
4. Title: "Request Rate"
5. Save dashboard
```

---

## 📝 DEMO 5: Logging (Kibana + Elasticsearch)

```
URL (Kibana): http://localhost:31601

Walkthrough:
1. Discover tab → See all logs from last 15 minutes
2. Search/Filter examples:
   - kubernetes.pod_name:auth-service*
   - log_level:ERROR
   - @timestamp:[now-1h TO now]
   - message:"Activity tracked"

3. Create saved search
4. Show: Log stream from specific service
```

### **Command Line (Elasticsearch)**
```bash
# Check if Elasticsearch is responding
curl -X GET 'http://localhost:31200/_cluster/health'

# Count logs in last hour
curl -X POST 'http://localhost:31200/_search' \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "range": {
        "@timestamp": {
          "gte": "now-1h",
          "lte": "now"
        }
      }
    }
  }' | jq '.hits.total'

# Top 10 services (by log volume)
curl -X POST 'http://localhost:31200/_search' \
  -H 'Content-Type: application/json' \
  -d '{
    "aggs": {
      "services": {
        "terms": {
          "field": "kubernetes.pod_name",
          "size": 10
        }
      }
    },
    "size": 0
  }' | jq '.'
```

---

## 🔄 DEMO 6: ArgoCD GitOps

```
URL: http://localhost:31960 (HTTPS)
or   http://localhost:31961 (HTTP - redirect to HTTPS)

Login:
- Username: admin
- Password: (get from secret)
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d

Dashboard:
1. Applications tab → See "education-platform"
2. Click application → See:
   - Sync status (Synced/OutOfSync)
   - Health status
   - Resources (pods, services)
   - Git source
   - Target cluster

3. Demo GitOps (if time):
   - Edit manifest in gitops repo
   - Commit to main branch
   - Watch ArgoCD auto-sync
```

### **Command Line**
```bash
# Get ArgoCD admin password
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d)
echo "ArgoCD Password: $ARGOCD_PASSWORD"

# View application status
kubectl get application -n argocd
kubectl describe application education-platform -n argocd

# Watch application sync in real-time
kubectl get application education-platform -n argocd -w
```

---

## 🚀 DEMO 7: Jenkins Pipeline

```
URL: http://localhost:31080

GUI Walkthrough:
1. Homepage → See "Pipeline" or "devops-education-platform"
2. Click job → Configure:
   - Parameters (DEPLOY_ENV, PUSH_DOCKER)
   - Source: Git repo
   - Jenkinsfile path
   
3. Build History → See previous builds
4. Build Logs → Click build number → See full logs

Optional: Trigger new build:
  - Click "Build with Parameters"
  - Select: DEPLOY_ENV = development
  - PUSH_DOCKER = false (don't push to registry)
  - Click "Build"
```

### **Jenkinsfile Sections to Explain**
```bash
# Show the actual Jenkinsfile
cat Jenkinsfile | less

# Or view in VS Code if you have it
code Jenkinsfile

# Key sections to highlight:
# 1. Parameters (lines 10-12)
# 2. Build stage with parallel (lines 30-80)
# 3. Deploy stage using kubectl set image (lines 100-120)
# 4. Post block cleanup (docker image prune)
```

---

## 🏗️ DEMO 8: Architecture Diagram

```bash
# Generate ASCII architecture:
# (Explain verbally while showing this)

┌─────────────────────────────────────────┐
│         DOCKER DESKTOP                  │
│       Kubernetes v1.34.1                │
├─────────────────────────────────────────┤
│                                         │
│  ┌─ education namespace (9d)            │
│  │  ├─ Frontend (Angular) → :31927     │
│  │  ├─ Gateway Backend → :31000        │
│  │  ├─ Auth Service → :31001           │
│  │  ├─ User Service (ClusterIP)        │
│  │  ├─ Activity Service (ClusterIP)    │
│  │  ├─ Student/Parent/Teacher (CIP)    │
│  │  ├─ Classroom Service (CIP)         │
│  │  └─ PostgreSQL Database (CIP)       │
│  │                                      │
│  ├─ monitoring namespace (14d)         │
│  │  ├─ Prometheus → :30090             │
│  │  └─ Grafana → :30500                │
│  │                                      │
│  ├─ cache namespace (14d)              │
│  │  └─ Redis → :31379                  │
│  │                                      │
│  ├─ logging namespace (14d)            │
│  │  ├─ Elasticsearch → :31200          │
│  │  └─ Kibana → :31601                 │
│  │                                      │
│  ├─ argocd namespace (15d)             │
│  │  ├─ ArgoCD UI → :31960/:31961       │
│  │  └─ Application: education-platform │
│  │                                      │
│  └─ jenkins namespace (14d)            │
│     └─ Jenkins → :31080                │
│                                         │
└─────────────────────────────────────────┘

CI/CD Flow:
  GitHub (source)
    ↓
  Webhook trigger
    ↓
  Jenkins Build (parallel)
    ├─ Build Frontend
    ├─ Build Activity Service
    ├─ Build Teacher Service
    └─ Build Gateway
    ↓
  Push Docker Hub (optional)
    ↓
  kubectl set image (deploy to K8s)
    ↓
  ArgoCD monitors GitOps repo
    ↓
  Auto-sync if any drift
```

---

## 🧪 DEMO 9: Service-to-Service Communication

```bash
# Exec into frontend pod and test backend call
POD_NAME=$(kubectl get pod -n education -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD_NAME -n education -- sh

# Inside pod, test gateway connectivity:
curl -X GET http://gateway-backend:3000/api/health

# Test auth service:
curl -X POST http://auth-service:3001/api/auth/token \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test"}'

# Test user service:
curl http://user-service:3002/api/users
```

---

## ⚙️ DEMO 10: Manual Deployment Test

```bash
# Show how to manually apply a manifest (without ArgoCD)
cat kubernetes/deployment-example.yaml

# Apply it
kubectl apply -f kubernetes/deployment-example.yaml

# Check status
kubectl rollout status deployment/example-deployment -n education

# Show kubectl set image (how Jenkins deploys)
kubectl set image deployment/frontend-app-deployment \
  -n education \
  frontend-app=eline2016/horizons-frontend:latest \
  --record

# Watch rollout in real-time
kubectl rollout status deployment/frontend-app-deployment -n education -w

# Describe deployment to show history
kubectl rollout history deployment/frontend-app-deployment -n education
```

---

## 🔍 DEMO 11: Troubleshooting (If Issues)

```bash
# === If pods not running ===
kubectl get pods -n education
kubectl describe pod <pod-name> -n education
kubectl logs <pod-name> -n education

# === If service not accessible ===
kubectl get svc -n education <service>
kubectl port-forward -n education svc/<service> 3000:3000
# Then test: curl localhost:3000

# === If database connection fails ===
kubectl logs -n education -l app=postgres --tail=50

# === Check network connectivity between pods ===
kubectl run -it --rm debug --image=alpine/tools --restart=Never -- sh
# Inside debug pod:
curl http://gateway-backend:3000
nslookup auth-service

# === Memory/CPU usage ===
kubectl top nodes
kubectl top pods -n education
```

---

## 📋 TIMELINE SOUTENANCE

**Durée recommandée**: 20-30 minutes

```
0:00-1:00   - Introduction + Architecture overview
1:00-3:00   - Demo 1: Infrastructure verification
3:00-5:00   - Demo 2: Frontend application
5:00-7:00   - Demo 3: API/Gateway
7:00-10:00  - Demo 4: Monitoring (Prometheus/Grafana)
10:00-12:00 - Demo 5: Logging (Kibana)
12:00-15:00 - Demo 6: ArgoCD GitOps
15:00-17:00 - Demo 7: Jenkins Pipeline (show Jenkinsfile)
17:00-20:00 - Q&A + Architecture discussion
20:00+      - Deep dive if questions on specific topics
```

---

## ⏱️ QUICK CHECK (Before Soutenance)

Run this 30 min before to ensure everything is up:

```bash
#!/bin/bash

echo "🔍 Pre-soutenance Health Check..."

# 1. Cluster
kubectl cluster-info > /dev/null && echo "✅ Kubernetes running" || echo "❌ K8s down"

# 2. Pods
RUNNING=$(kubectl get pods -n education --field-selector=status.phase=Running --no-headers | wc -l)
echo "✅ Pods running: $RUNNING/12 (need 12)"

# 3. Services
kubectl get svc -n education frontend-app -o jsonpath='{.status.loadBalancer}' > /dev/null && echo "✅ Frontend service OK"

# 4. External access test
curl -s http://localhost:31927 > /dev/null && echo "✅ Frontend accessible" || echo "⚠️ Frontend not responding"
curl -s http://localhost:30090 > /dev/null && echo "✅ Prometheus accessible" || echo "⚠️ Prometheus not responding"
curl -s http://localhost:30500 > /dev/null && echo "✅ Grafana accessible" || echo "⚠️ Grafana not responding"

# 5. ArgoCD
kubectl get application -n argocd | grep education-platform > /dev/null && echo "✅ ArgoCD App registered" || echo "⚠️ ArgoCD app missing"

echo "✅ Pre-soutenance check complete!"
```

---

## 🎓 KEY TALKING POINTS

```
When presenting:

1. "Nous avons 8 microservices + 1 gateway = 9 services totaux"
2. "Chaque service est indépendant, scalable séparément"
3. "PostgreSQL centralisée (single source of truth)"
4. "Kubernetes gère: health checks, restarts, scaling"
5. "Jenkins automatise: build, test, deploy"
6. "ArgoCD synchronise l'état actuel avec la déclaration Git"
7. "Prometheus collecte metrics, Grafana visualise"
8. "Elasticsearch/Kibana centralisent tous les logs"
9. "Namespaces isolent les responsabilités"
10. "Tout est version control = Infrastructure as Code"
```

---

## 📸 SCREENSHOTS À PRENDRE

For your report:

```bash
# 1. kubectl get all -n education
kubectl get all -n education > screenshot_1_pods.txt

# 2. Prometheus targets
# Screenshot from http://localhost:30090/targets

# 3. Grafana dashboard
# Screenshot from http://localhost:30500

# 4. ArgoCD app
# Screenshot from http://localhost:31960/applications/education-platform

# 5. Kibana logs
# Screenshot from http://localhost:31601

# 6. Jenkins job configuration
# Screenshot from http://localhost:31080/job/your-job/configure
```

---

**Good luck with your defense! 🚀**

Imen, votre projet est impressionnant - vous allez réussir! 

