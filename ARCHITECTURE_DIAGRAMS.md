# 🎨 ARCHITECTURE DIAGRAMS - GUIDE VISUEL

## Diagramme 1: Vue d'ensemble du système

```
┌─────────────────────────────────────────────────────────────────┐
│                           USERS                                 │
│                 (Browser / Mobile / API Client)                │
└────────────────────────────────┬────────────────────────────────┘
                                 │ HTTPS (TLS)
                                 ↓
        ┌────────────────────────────────────────────┐
        │   KUBERNETES CLUSTER (Production)         │
        │                                            │
        │  ┌──────────────────────────────────────┐ │
        │  │ Ingress Nginx (443)                  │ │
        │  │ api.example.com → Gateway            │ │
        │  │ app.example.com → Frontend           │ │
        │  └──────────────────────────────────────┘ │
        │                    ↓                       │
        │  ┌──────────────────────────────────────┐ │
        │  │ Frontend (2 replicas)                │ │
        │  │ - nginx (94.7MB)                    │ │
        │  │ - CPU: 100m | Memory: 128Mi         │ │
        │  └──────────────────────────────────────┘ │
        │                                            │
        │  ┌──────────────────────────────────────┐ │
        │  │ API Gateway (2 replicas)             │ │
        │  │ - Node.js/NestJS (345MB)            │ │
        │  │ - CPU: 250m | Memory: 256Mi         │ │
        │  └──────────────────────────────────────┘ │
        │                    ↓                       │
        │  ┌──────────────────────────────────────┐ │
        │  │ 8 Microservices (2 replicas each)   │ │
        │  │                                      │ │
        │  │ Auth      │ User     │ Activity │   │ │
        │  │ ─────────────────────────────────  │ │
        │  │ Classroom │ Parent   │ Student  │   │ │
        │  │ Teacher   │ (...)                 │ │
        │  │                                      │ │
        │  │ CPU: 250m | Memory: 256Mi (each)   │ │
        │  └──────────────────────────────────────┘ │
        │                    ↓                       │
        │  ┌──────────────────────────────────────┐ │
        │  │      Persistent Data Layer          │ │
        │  │                                      │ │
        │  │ PostgreSQL   Redis    Elasticsearch │ │
        │  │ (PVC 10Gi)  (Cache)   (Full-text)  │ │
        │  │                                      │ │
        │  │           MinIO                      │ │
        │  │        (Object Store)                │ │
        │  └──────────────────────────────────────┘ │
        │                                            │
        └────────────────────────────────────────────┘
                             │
         ┌───────────────────┼───────────────────┐
         ↓                   ↓                   ↓
    ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
    │ Prometheus  │   │ Grafana     │   │ Kibana      │
    │ (Metrics)   │   │ (Dashboard) │   │ (Logs)      │
    └─────────────┘   └─────────────┘   └─────────────┘
```

---

## Diagramme 2: Flux de requête HTTP

```
Client Browser
    ↓
HTTPS GET /api/users
    ↓
Ingress Nginx (TLS termination)
    ↓
Load Balancer (ClusterIP Service)
    ↓
Frontend Pod (if path = /)
    ↓ ou
API Gateway Pod (if path = /api)
    ↓
Service Discovery (Kubernetes DNS)
    ↓
User Service Pod (autolog user-service:3002)
    ↓
PostgreSQL Pod (via ClusterIP)
    ↓
PersistentVolume (Data storage)
    ↓
Response back through all layers
    ↓
Client Browser receives JSON/HTML
    ↓
Prometheus scrapes metrics (/metrics)
    ↓
Grafana visualizes dashboard
```

---

## Diagramme 3: Deployment avec Rolling Update

```
AVANT (Version v1.0.0):
┌─────────┐  ┌─────────┐
│ Pod 1   │  │ Pod 2   │
│ v1.0.0  │  │ v1.0.0  │
└─────────┘  └─────────┘
(Serving 100% traffic)

PENDANT (Deploy v1.0.1):
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Pod 1   │  │ Pod 3   │  │ Pod 2   │
│ v1.0.0  │  │ v1.0.1  │  │ v1.0.0  │
└─────────┘  (new)    └─────────┘
             └─────────┘

(2/3 old, 1/3 new - gradual transition)

PENDANT (Continue):
           ┌─────────┐  ┌─────────┐
           │ Pod 3   │  │ Pod 4   │
           │ v1.0.1  │  │ v1.0.1  │
           └─────────┘  (new)
                        └─────────┘

(2/3 new, 1/3 old)

APRÈS (Version v1.0.1):
┌─────────┐  ┌─────────┐
│ Pod 3   │  │ Pod 4   │
│ v1.0.1  │  │ v1.0.1  │
└─────────┘  └─────────┘
(Serving 100% traffic, ZERO DOWNTIME!)

Timeline: ~2 minutes (depends on image size + startup time)
```

---

## Diagramme 4: Network Policies (Sécurité Réseau)

```
AVANT (Pas de Network Policies):
┌────────────┐
│ Frontend   │  ← Peut parler à TOUT
├────────────┤
│ Gateway    │  ← Peut parler à TOUT (DANGEREUX!)
├────────────┤
│ User Svc   │  ← Peut parler à TOUT (TRÈS DANGEREUX!)
├────────────┤
│ Database   │  ← Accessible par TOUT (CRITIQUE!)
├────────────┤
│ Redis      │  ← Accessible par TOUT
└────────────┘

Result: Pod compromis → Accès à données sensibles


APRÈS (Avec Network Policies):
┌─────────────────────────────────────┐
│ Deny All Ingress (default policy)   │
└─────────────────────────────────────┘

PUIS: Whitelist des connexions


Frontend
   ↓ (allowed)
Gateway (Service)
   ↓ (allowed)
├─→ User Service (allowed)
├─→ Auth Service (allowed)
├─→ Activity Service (allowed)
└─→ Database (allowed)
      ↓ (allowed)
   PostgreSQL

Redis
   ↑ (allowed ONLY from backends)
   ├─ Gateway
   ├─ User Service
   ├─ Parent Service
   └─ ...

Prometheus
   ↑ (allowed to scrape all pods)
   └─ All services metrics

Result: Pod compromis → Isolation réseau → Dégâts limités
```

---

## Diagramme 5: Horizontal Pod Autoscaling (HPA)

```
Normal Load:
  Current: 2 replicas
  CPU: 35% (target: 70%)
  Memory: 40% (target: 80%)
  → No action (within target)

Traffic Spike:
  Current: 2 replicas
  CPU: 75% (target: 70%) ← EXCEED!
  Memory: 85% (target: 80%) ← EXCEED!
  → Triggers scale-up immediately

Auto-Scale UP:
  +1 → 3 replicas
  CPU drops to: (400m total / 3) = 133m average
  New CPU: 52% (target: 70%) ✅
  New Memory: 60% (target: 80%) ✅

Still High:
  CPU: 68% (approaching 70%)
  Memory: 78% (approaching 80%)
  → Add 1 more

  +1 → 4 replicas
  CPU: 40% ✅
  Memory: 45% ✅

Traffic Normalizes:
  CPU: 30%
  Memory: 35%
  → Wait 300s (grace period)
  -1 → 3 replicas

Back to Normal:
  Current: 2-3 replicas
  CPU: 35-40%
  Memory: 40-45%
  → Stable state

MAX LIMIT: 5 replicas
MIN LIMIT: 2 replicas
```

---

## Diagramme 6: CI/CD Pipeline Jenkins

```
Developer
   ↓ (git push)
GitHub/GitLab
   ↓ (webhook)
Jenkins Server
   ↓
┌─ STAGE 1: Checkout & Setup
│  ├─ git checkout
│  ├─ Extract commit SHA
│  └─ Set image tag: v1.0.1-abc123def
│
├─ STAGE 2: Lint & Quality (Parallel)
│  ├─ Backend lint (npm run lint)
│  ├─ Frontend lint (ng lint)
│  └─ Dockerfile scan (hadolint)
│
├─ STAGE 3: Unit Tests (Parallel)
│  ├─ Backend tests (npm run test:cov)
│  └─ Frontend tests (ng test)
│
├─ STAGE 4: SonarQube Analysis
│  └─ Code quality metrics
│
├─ STAGE 5: Security Scan
│  ├─ npm audit (vulnerable packages)
│  └─ Trivy scan (Docker image CVEs)
│
├─ STAGE 6: Build Docker Images (Parallel)
│  ├─ devopspfe-gateway:v1.0.1-abc123def
│  ├─ devopspfe-user:v1.0.1-abc123def
│  ├─ devopspfe-auth:v1.0.1-abc123def
│  └─ ... (all 9 images)
│
├─ STAGE 7: Security Scan Images
│  └─ Trivy scan all built images
│
├─ STAGE 8: Push to Registry
│  └─ docker push (if main branch)
│
├─ STAGE 9: Deploy to Kubernetes
│  ├─ kubectl create namespace
│  ├─ Apply kustomize manifests
│  └─ Rolling update with new image
│
├─ STAGE 10: Health Checks
│  ├─ Wait for pods ready
│  ├─ Smoke tests (curl /health)
│  └─ Verify endpoints responding
│
└─ End
   ↓
Slack Notification (success or failure)
   ↓
Monitoring Starts
   ↓
Prometheus scrapes metrics

Total Time: ~23 minutes
Success Rate: 95%+ (on main branch)
```

---

## Diagramme 7: Pod Lifecycle & Health Checks

```
Pod Scheduled
    ↓
Container Creation
    ↓
Image Pull (from registry)
    ↓
Container Starts
    ↓
readinessProbe (HTTP GET /health)
    ├─ Success → Pod ready (READY=1/1)
    │  ↓
    │  Service routes traffic to this pod
    │
    └─ Failure → Pod not ready (READY=0/1)
       ↓
       Service skips this pod


Running State
    ↓
livenessProbe (HTTP GET /health)
    ├─ Success → Continue serving
    │
    └─ Failure → Pod crash loop
       ↓
       kubelet restarts container
       ↓
       If RestartPolicy=Always:
       ├─ Restart attempt 1
       ├─ Restart attempt 2 (exponential backoff)
       └─ Restart attempt N
       
       If RestartPolicy=OnFailure:
       └─ Restart only on crash (not on exit 0)


Graceful Shutdown
    ↓
Termination Signal (SIGTERM)
    ├─ App has 30s to shut down
    │  └─ Close connections
    │  └─ Drain existing requests
    │
    └─ After 30s: Force kill (SIGKILL)
       ↓
Pod Terminated
   ↓
Replacement pod created (if replicas > 0)
```

---

## Diagramme 8: Storage Architecture

```
PersistentVolume (PV)
│
├─ Block Storage (EBS, GCE persistent disk)
│  └─ Database storage (PostgreSQL 10GB)
│
├─ NFS (Network File System)
│  └─ Shared logs, backups
│
└─ Object Storage (S3/MinIO)
   └─ User uploads, documents

   ↓

PersistentVolumeClaim (PVC)
│
├─ postgres-pvc (10Gi, ReadWriteOnce)
│  ├─ Mounted to PostgreSQL pod: /var/lib/postgresql/data
│  └─ Survives pod restart
│
└─ backup-pvc (50Gi, ReadWriteMany)
   └─ Mounted to backup job

   ↓

Pod Lifecycle
│
├─ Pod created
│  ├─ Volumes mounted
│  └─ Data accessible
│
├─ Pod running
│  ├─ Writing to /var/lib/postgresql/data
│  └─ Data persisted to PVC
│
├─ Pod crashes
│  ├─ New pod created
│  ├─ Same PVC mounted
│  └─ Data still there!
│
└─ Pod deleted
   ├─ Data remains in PVC
   └─ Can be claimed by new pod

Backup Strategy:
┌──────────────────────────┐
│ PostgreSQL Pod           │
│ /var/lib/postgresql/data │
└────────────┬─────────────┘
             ↓
        pg_dump
             ↓
      backup-job
             ↓
       S3 / Cloud Storage
             ↓
    Point-in-time recovery
    possible up to X days
```

---

## Diagramme 9: Logging Architecture

```
Application Logs
├─ Container stdout/stderr
│
├─ Docker Compose:
│  └─ docker logs <container>
│
└─ Kubernetes:
   ├─ kubectl logs <pod>
   ├─ kubectl logs -f <pod> (follow)
   └─ kubectl logs --all-containers=true <pod>

       ↓

Log Aggregation (ELK Stack)
│
├─ Filebeat / Logstash (collect)
│  └─ Reads logs from all containers
│  └─ Parses JSON format
│  └─ Adds metadata (pod name, namespace, etc.)
│
├─ Elasticsearch (store)
│  └─ Indexes all logs
│  └─ Full-text search
│  └─ Retention: 30 days
│
└─ Kibana (visualize)
   ├─ Search logs by keyword
   ├─ Filter by pod/service/level
   ├─ Create dashboards
   └─ Set up alerts

Query Examples:
│
├─ Find all errors:
│  └─ level:ERROR AND timestamp:[now-1h TO now]
│
├─ Find slowness:
│  └─ duration > 5000
│
└─ Find by service:
   └─ service:gateway AND level:INFO

Timeline:
T=0:  Application logs to stdout
T=100ms: Collected by Filebeat
T=200ms: Indexed by Elasticsearch
T=300ms: Available in Kibana
```

---

## Diagramme 10: Monitoring Stack

```
Applications (8 microservices + frontend + database)
│
├─ Expose /metrics endpoint
│  ├─ http://gateway:3000/metrics
│  ├─ http://user-service:3002/metrics
│  └─ ...
│
└─ Prometheus Annotations
   ```yaml
   prometheus.io/scrape: "true"
   prometheus.io/port: "3000"
   prometheus.io/path: "/metrics"
   ```

       ↓

Prometheus Server
│
├─ Scrape Configuration
│  └─ Every 15 seconds, fetch /metrics from all pods
│
├─ Time Series Database (TSDB)
│  ├─ Store metrics with timestamps
│  ├─ Query by metric name, labels
│  └─ Retention: 15 days
│
└─ Alert Rules
   ├─ PodCrashLooping: restart_rate > 0.1/min
   ├─ HighMemory: memory_usage > 80%
   └─ HighLatency: p95_latency > 5s

       ↓

Grafana
│
├─ Data Source: Prometheus
│
├─ Dashboards
│  ├─ System Health
│  │  ├─ CPU usage per node
│  │  ├─ Memory usage per node
│  │  ├─ Disk I/O
│  │  └─ Network traffic
│  │
│  ├─ Application Metrics
│  │  ├─ Request rate (req/sec)
│  │  ├─ Error rate (%)
│  │  ├─ Latency (p95, p99)
│  │  └─ Pod restarts
│  │
│  └─ Database Metrics
│     ├─ Connection pool usage
│     ├─ Query latency
│     ├─ Slow queries
│     └─ Replication lag
│
├─ Alerts
│  ├─ Send to Slack/PagerDuty
│  └─ On-call engineer notified
│
└─ Custom Panels
   └─ Business metrics (users registered, revenue, etc.)
```

---

## Comment utiliser ces diagrammes en soutenance

1. **Imprimez-les en A3** (affichage clair)
2. **Commentez chaque partie** pendant la présentation
3. **Pointez du doigt** les éléments clés
4. **Montrez les connections** entre composants
5. **Explicitez les flux** (requête HTTP, data, logs)
6. **Comparez avant/après** (sécurité, performance)

---

## Outils pour créer vos propres diagrammes

- **Draw.io** (https://draw.io) - Gratuit, simple
- **Lucidchart** - Professionnel mais payant
- **Miro** - Collaboration en temps réel
- **Excalidraw** - Style dessin libre

---

**Fin du guide des diagrammes** ✅
