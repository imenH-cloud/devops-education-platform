# 🎓 PRÉSENTATION TECHNIQUE COMPLÈTE - SOUTENANCE PFE DEVOPS
## Plateforme Éducation - Architecture Microservices Kubernetes

---

## 📋 TABLE DES MATIÈRES

1. [Introduction (2 min)](#introduction)
2. [Architecture Globale (2 min)](#architecture)
3. [Docker & Containerisation (3 min)](#docker)
4. [Kubernetes & Orchestration (5 min)](#kubernetes)
5. [Sécurité & Network Policies (2 min)](#securite)
6. [CI/CD & Jenkins Pipeline (2 min)](#cicd)
7. [Monitoring & Observabilité (1 min)](#monitoring)
8. [Démo Live (5 min)](#demo)
9. [Q&A Complet (5 min)](#qa)

---

<a name="introduction"></a>
## 1️⃣ INTRODUCTION (2 MIN)

### Contexte du projet
- **Nom** : DevOps Education Platform (Plateforme Éducation)
- **Type** : Système d'information pédagogique
- **Utilisateurs** : Étudiants, Professeurs, Parents
- **Objectif** : Apprentissage du DevOps + Déploiement scalable

### Acteurs du système
```
┌─────────────┐
│  ÉTUDIANTS  │ ← Consultent cours, remettent devoirs
├─────────────┤
│ PROFESSEURS │ ← Créent contenu, notent travaux
├─────────────┤
│   PARENTS   │ ← Suivent progression
├─────────────┤
│ CLASSROOMS  │ ← Gestion des classes
├─────────────┤
│  ACTIVITÉS  │ ← Logs de toutes les actions
└─────────────┘
```

### Stack Technologique
| Couche | Technologie |
|--------|-------------|
| **Frontend** | Angular 20 + Bootstrap + NgRx |
| **Backend** | Node.js/NestJS (8 microservices) |
| **Database** | PostgreSQL 15 |
| **Cache** | Redis 7 |
| **Message Queue** | RabbitMQ |
| **Search** | Elasticsearch 8.10 |
| **Storage** | MinIO (S3-compatible) |
| **Monitoring** | Prometheus + Grafana + ELK |
| **Orchestration** | Kubernetes |
| **CI/CD** | Jenkins |
| **Registry** | Docker Hub |

### 8 Microservices Backend
```
┌─────────────────────────────────────────────────────────────┐
│                    API GATEWAY (3000)                       │
│  Route requests vers les services appropriés                │
└─────────────────────────────────────────────────────────────┘
              ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│  AUTH    │ │  USER    │ │ ACTIVITY │ │CLASSROOM │
│ (3001)   │ │ (3002)   │ │ (3003)   │ │ (3006)   │
└──────────┘ └──────────┘ └──────────┘ └──────────┘

┌──────────┐ ┌──────────┐ ┌──────────┐
│ PARENT   │ │ STUDENT  │ │ TEACHER  │
│ (3004)   │ │ (3005)   │ │ (3007)   │
└──────────┘ └──────────┘ └──────────┘
```

### Caractéristiques clés
✅ **Scalabilité** - Chaque service peut scaler indépendamment  
✅ **Résilience** - Pas de single point of failure  
✅ **Sécurité** - Secrets chiffrés, network isolation  
✅ **Observabilité** - Logs centralisés, métriques  
✅ **CI/CD** - Déploiement automatisé  

---

<a name="architecture"></a>
## 2️⃣ ARCHITECTURE GLOBALE (2 MIN)

### Vue d'ensemble du système

```
┌────────────────────────────────────────────────────────────────┐
│                         USERS                                  │
│                  (Browser / Mobile App)                        │
└─────────────────────────────────┬──────────────────────────────┘
                                  │ HTTPS
                                  ↓
┌────────────────────────────────────────────────────────────────┐
│                   KUBERNETES CLUSTER                           │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Ingress Nginx                                           │  │
│  │  - api.example.com:443 → API Gateway                    │  │
│  │  - app.example.com:443 → Frontend                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│                          ↓                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │               Load Balancer (Service)                    │  │
│  └──────────────────────────────────────────────────────────┘  │
│                  ↓          ↓          ↓                        │
│  ┌────────────────────────────────────────────────────────┐   │
│  │ FRONTEND (nginx)   API GATEWAY (Node.js)               │   │
│  │ - 2 replicas      - 2 replicas                         │   │
│  │ - 100m CPU        - 250m CPU                           │   │
│  │ - 128Mi Memory    - 256Mi Memory                       │   │
│  └────────────────────────────────────────────────────────┘   │
│                          ↓                                      │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │      8 Microservices (2 replicas chacun)                │  │
│  │  Auth | User | Activity | Classroom | Parent | Student │  │
│  │  │    │      │          │           │        │         │  │
│  │  └────┴──────┴──────────┴───────────┴────────┴─────────┘  │
│  │                      ↓                                      │
│  ├──────────────────────────────────────────────────────────┐ │
│  │            PERSISTENT DATA LAYER                        │ │
│  │  ┌──────────┐ ┌────────┐ ┌──────────────┐ ┌───────┐   │ │
│  │  │PostgreSQL│ │ Redis  │ │Elasticsearch │ │MinIO  │   │ │
│  │  │ 10Gi PVC │ │ Cache  │ │(Full Search) │ │Store  │   │ │
│  │  │          │ │        │ │              │ │       │   │ │
│  │  └──────────┘ └────────┘ └──────────────┘ └───────┘   │ │
│  └──────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────┘
                          ↓
         ┌────────────────────────────────────┐
         │  Monitoring Stack (Outside K8s)   │
         │  - Prometheus (scraping metrics)   │
         │  - Grafana (dashboards)            │
         │  - Kibana (log visualization)      │
         └────────────────────────────────────┘
```

### Flux de données
```
1. User Browser
   ↓
2. HTTPS → Ingress (TLS Termination)
   ↓
3. Load Balancer (ClusterIP Service)
   ↓
4. Frontend ou API Gateway (Pods)
   ↓
5. Service Discovery (DNS internal)
   ↓
6. Microservices (2 replicas per service)
   ↓
7. Database/Cache (PersistentVolume)
   ↓
8. Monitoring (Prometheus scrapes)
   ↓
9. Visualization (Grafana + Kibana)
```

### Key Design Decisions
| Décision | Raison |
|----------|--------|
| **2 replicas minimum** | Haute disponibilité + rolling updates |
| **Resource Limits** | Évite CPU throttling, memory overflow |
| **Network Policies** | Sécurité réseau, isolation des services |
| **PVC pour data** | Persistance des données critiques |
| **HPA (Auto-scaling)** | Réaction dynamique à la charge |
| **ConfigMaps + Secrets** | Gestion centralisée de la configuration |
| **Health checks** | Détection automatique des pods défaillantes |

---

<a name="docker"></a>
## 3️⃣ DOCKER & CONTAINERISATION (3 MIN)

### Problème sans Docker
```
Dev: "Ça marche sur mon PC!"
Ops: "Ça marche pas en production!"

Raisons:
- Différentes versions Node.js
- Différentes versions PostgreSQL
- Dépendances système manquantes
- Dépendances npm en conflit
- Différentes variables d'environnement
```

### Solution Docker: "Build Once, Run Everywhere"
```
                    Dockerfile
                        ↓
            docker build → Image Docker
                        ↓
            Image immuable (reproducible)
                        ↓
        docker run → Container identique
             (Dev, Test, Prod)
```

### Notre approche: Multi-Stage Builds

#### Exemple: Gateway Backend Dockerfile
```dockerfile
# STAGE 1: Builder (compilation)
FROM node:20-alpine AS builder

WORKDIR /app

# Copier package files
COPY package*.json ./

# Installer dépendances complètes (y compris dev)
RUN npm ci --prefer-offline --no-audit

# Copier source code
COPY . .

# Compiler TypeScript → JavaScript
RUN npm run build
# Result: /app/dist/ (code compilé)

# ─────────────────────────────────────────────

# STAGE 2: Production (runtime uniquement)
FROM node:20-alpine

WORKDIR /app

# Installer dumb-init pour signal handling correct
RUN apk add --no-cache dumb-init

# Copier UNIQUEMENT le code compilé (pas source)
COPY --from=builder /app/dist ./dist

# Copier UNIQUEMENT package.json + lock
COPY --from=builder /app/package*.json ./

# Installer UNIQUEMENT dépendances production
RUN npm ci --omit=dev --prefer-offline --no-audit && \
    npm cache clean --force

# Configuration
ENV NODE_ENV=production
EXPOSE 3000

# Sécurité: créer user non-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
USER nodejs

# dumb-init capture les signaux correctement
ENTRYPOINT ["dumb-init", "--"]

# Démarrer l'app
CMD ["node", "dist/main.js"]
```

### Avantages du Multi-Stage Build

| Aspect | Avant | Après |
|--------|-------|-------|
| **Image Size** | 1.2GB | 345MB |
| **Build time** | 5 min | 2 min |
| **Security** | Outils build inclus | Minimal |
| **Attack surface** | Grand | Réduit |

### Image Sizes du projet
```
devopspfe-activity-service:latest      339MB   (66.7MB compressed)
devopspfe-auth-service:latest          369MB   (70.7MB compressed)
devopspfe-classroom-service:latest     339MB   (66.7MB compressed)
devopspfe-frontend-app:latest          94.7MB  (26.6MB compressed) ← Optimisé!
devopspfe-gateway-backend:latest       345MB   (67.6MB compressed)
devopspfe-parent-service:latest        339MB   (66.7MB compressed)
devopspfe-student-service:latest       339MB   (66.7MB compressed)
devopspfe-teacher-service:latest       339MB   (66.7MB compressed)
devopspfe-user-service:latest          364MB   (69.9MB compressed)
```

### Best Practices Appliquées

✅ **Non-root user**
```dockerfile
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs
```
→ Limite les dégâts si un conteneur est compromis

✅ **Health Checks**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:4200/ || exit 1
```
→ Kubernetes detecte automatiquement les pods malades

✅ **No Root Privileges**
→ Impossible de devenir root même avec escalade de privileges

✅ **Minimal Base Image (Alpine)**
```dockerfile
FROM node:20-alpine
# Alpine: ~170MB vs Ubuntu: ~850MB
```
→ Surface d'attaque réduite

✅ **Cache Optimization**
```dockerfile
COPY package*.json ./          # Cache layer 1
RUN npm ci                     # Cache layer 2
COPY . .                       # Invalidate only if code changes
```
→ Builds plus rapides lors du développement

### Docker Compose pour Développement
```yaml
version: '3.9'

services:
  gateway-backend:
    build:
      context: ./backend/gateway
      dockerfile: Dockerfile
    container_name: gateway-backend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DB_HOST=postgres
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - app-network
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
```

### Commandes Docker essentielles
```bash
# Build une image
docker build -t devopspfe-gateway:latest ./backend/gateway

# Lancer un container
docker run -p 3000:3000 devopspfe-gateway:latest

# Voir les logs
docker logs <container-id>

# Entrer dans un container
docker exec -it <container-id> /bin/sh

# Voir les images
docker images
docker images devopspfe-*

# Network inspection
docker network ls
docker network inspect app-network

# Cleanup
docker system prune -a --volumes
```

---

<a name="kubernetes"></a>
## 4️⃣ KUBERNETES & ORCHESTRATION (5 MIN)

### Pourquoi Kubernetes?

**Problèmes sans orchestration:**
```
1. Un container crash? → Site down
2. Nouveau déploiement? → Downtime
3. Trop de charge? → Timeout/errors
4. Mise à jour OS? → Tous les services arrêtent
5. Volumes? → Données perdues
```

**Solutions Kubernetes:**
```
1. Replicas → Container se relance automatiquement
2. Rolling Updates → Zéro downtime
3. HPA → Scale automatiquement
4. Anti-affinity → Services sur différents nodes
5. PVC → Données persistantes
```

### Concepts clés

#### 1. Pods (Plus petite unité)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gateway-pod-xyz
spec:
  containers:
  - name: gateway
    image: devopspfe-gateway:latest
    ports:
    - containerPort: 3000
```
→ Un ou plusieurs containers partageant network/storage

#### 2. Deployments (Haute disponibilité)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gateway-deployment
spec:
  replicas: 2  # 2 copies du pod
  selector:
    matchLabels:
      app: gateway
  template:
    # Définition du pod à créer
```

#### 3. Services (Service Discovery)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: gateway
spec:
  selector:
    app: gateway
  ports:
  - port: 3000
    targetPort: 3000
  type: ClusterIP
```
→ DNS interne: `http://gateway:3000`

#### 4. ConfigMaps (Configuration)
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  NODE_ENV: production
  DB_HOST: postgres
  DB_PORT: "5432"
```

#### 5. Secrets (Credentials)
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
stringData:
  username: postgres
  password: secure-password
```

### Notre Déploiement Kubernetes

#### Rolling Update Strategy (Zero Downtime)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gateway-deployment
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0    # ← 0 pods down pendant update
      maxSurge: 1          # ← 1 pod extra pendant update
  template:
    # ...
```

**Timeline de déploiement:**
```
Avant:        [Pod1] [Pod2]  (v1.0)

Pendant:      [Pod1] [Pod2]  [Pod3-new]  (v1.1)
              (2 old, 1 new)

              [Pod1] [Pod3]  (v1.1)
              (1 old, 2 new)

Après:        [Pod3] [Pod4]  (v1.1)
              (0 old, 2 new)

Durée: ~2 min (zéro downtime)
```

#### Resource Management
```yaml
resources:
  requests:
    cpu: "250m"          # Au minimum 250 milliCPU
    memory: "256Mi"      # Au minimum 256 MiB
  limits:
    cpu: "500m"          # Au maximum 500 milliCPU
    memory: "512Mi"      # Au maximum 512 MiB
```

**Pourquoi?**
- Si pas de requests: Kubernetes ne sait pas où placer le pod
- Si pas de limits: Pod peut consommer tous les resources
- Si limits < utilisé: Pod est tué (OOMKilled)

**Calcul pour 10 users:**
```
1 user → 50Mi memory
10 users → 500Mi memory
→ 2 replicas × 250Mi = 500Mi
→ Suffisant

Si charge augmente → HPA crée automatiquement des pods
```

#### Health Checks (Liveness & Readiness)
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
  # → Si /health échoue 3 fois → Pod est redémarré

readinessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 10
  periodSeconds: 5
  # → Si probe échoue → Pod ne reçoit plus de trafic
  # → Mais pod n'est pas redémarré
```

#### Network Policies (Sécurité réseau)
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
spec:
  podSelector: {}          # S'applique à tous les pods
  policyTypes:
  - Ingress
  # Effet: AUCUN pod ne peut recevoir du trafic (deny-all par défaut)

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-gateway-to-services
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: gateway
    ports:
    - protocol: TCP
      port: 3000
  # Effet: Les services backend acceptent UNIQUEMENT du gateway
```

**Réseau avant/après Network Policies:**
```
AVANT (Vulnerable):
┌──────────┐   ┌──────────┐   ┌──────────┐
│ Frontend │──→│ Gateway  │──→│  User    │
├──────────┤   ├──────────┤   ├──────────┤
│ peut parler à tous!
│ même les bases de données!

APRÈS (Sécurisé):
┌──────────┐ X ┌──────────┐ X ┌──────────┐
│ Frontend │─X→│ Database │←X─│  User    │
├──────────┤   ├──────────┤   ├──────────┤
│ Chaque pod peut parler UNIQUEMENT à ses dépendances
```

#### Pod Disruption Budgets (Haute disponibilité)
```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: gateway-pdb
spec:
  minAvailable: 1  # Au minimum 1 pod doit rester up
  selector:
    matchLabels:
      app: gateway
```

**Cas d'usage:**
```
Kubernetes met à jour l'OS du node
→ Évite les pod disruptions

Sans PDB:
- 2 pods arrêtées en même temps
- Service indisponible pendant 30s

Avec PDB:
- 1 pod arrêtée, 1 pod reste up
- Service reste disponible
```

#### Horizontal Pod Autoscaler (HPA)
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: gateway-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: gateway-deployment
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70  # Target 70% CPU
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80  # Target 80% Memory
```

**Auto-scaling timeline:**
```
Normal load:
  Current: 2 replicas
  CPU: 35%, Memory: 40%
  Pas d'action

Traffic spike:
  Current: 2 replicas
  CPU: 75%, Memory: 85%
  → Triggers scale-up

Scaling:
  +1 → 3 replicas
  CPU: 52%, Memory: 60%
  ✅ Within target

Traffic normalizes:
  CPU: 40%, Memory: 45%
  → Wait 5 min
  -1 → 2 replicas
  ✅ Back to normal
```

### Deploiement Complet (Kustomize)
```bash
# Appliquer tous les manifests dans kubernetes/
kubectl kustomize kubernetes/ | kubectl apply -f -

# Cela applique:
├── secrets.yaml              (Postgres, JWT, MinIO passwords)
├── configmap.yaml            (Configuration générique)
├── network-policies.yaml     (Deny-all + whitelist)
├── database/postgres.yaml    (PostgreSQL + PVC)
├── database/migrate.yaml     (Migration job)
├── backend/*.yaml            (8 microservices)
├── frontend/frontend-app.yaml
├── ingress.yaml              (HTTPS routing)
└── monitoring/*              (Prometheus, Grafana)
```

### Vérification du déploiement
```bash
# Voir tous les pods
kubectl get pods
# Output:
# NAME                                    READY   STATUS    RESTARTS
# gateway-deployment-xyz-abc              1/1     Running   0
# user-service-deployment-xyz-def         1/1     Running   0
# postgres-deployment-xyz-ghi             1/1     Running   0
# ...

# Voir les services
kubectl get svc
# Output:
# NAME          TYPE       CLUSTER-IP      PORT(S)
# gateway       ClusterIP  10.96.0.1       3000/TCP
# user-service  ClusterIP  10.96.0.2       3002/TCP
# postgres      ClusterIP  10.96.0.3       5432/TCP
# ...

# Voir l'ingress
kubectl get ingress
# Output:
# NAME         CLASS   HOSTS                    ADDRESS
# app-ingress  nginx   api.example.com, ...     192.168.1.100
# ...

# Logs d'un pod
kubectl logs -f gateway-deployment-xyz-abc

# Entrer dans un pod
kubectl exec -it gateway-deployment-xyz-abc /bin/sh
```

---

<a name="securite"></a>
## 5️⃣ SÉCURITÉ & NETWORK POLICIES (2 MIN)

### Le Problème: Secrets en Dur
```dockerfile
# ❌ BAD - NEVER DO THIS
ENV DB_PASSWORD=postgres123
ENV JWT_SECRET=my-secret-key
# Secrets visibles dans:
# - docker ps
# - Docker history
# - Code source
# - Logs
# - Registry
```

### La Solution: Kubernetes Secrets
```yaml
# 1. Créer le secret
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
stringData:
  username: postgres
  password: your-secure-password
  database: education

---
# 2. Utiliser dans un Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gateway
spec:
  template:
    spec:
      containers:
      - name: gateway
        env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: password
        # ✅ Password ne figure nulle part dans les logs ou YAML
```

**Avantages:**
- Secrets chiffrés dans etcd (Kubernetes datastore)
- Secrets pas dans les manifests YAML
- Secrets pas dans les logs
- Secrets peuvent être rotatés sans redéploiement

### Network Policies: Firewall Kubernetes

**Défaut (sans Network Policies):**
```
Chaque pod peut parler à n'importe quel autre pod
┌────────┐
│ Pod A  │←→ Pod B ✅
│ Pod C  │←→ Database ✅ (DANGEREUX!)
│ Pod D  │←→ Kubernetes API ✅ (TRÈS DANGEREUX!)
└────────┘
```

**Avec Network Policies (Notre approche):**
```
Deny-all par défaut
┌────────┐
│ Pod A  │←→ Rien ✅
│ Pod C  │←→ Rien ✅
│ Pod D  │←→ Rien ✅
└────────┘

Puis whitelist les connexions nécessaires:
│ Frontend   │─→ Gateway ✅
│ Gateway    │─→ Services ✅
│ Services   │─→ Database ✅
│ Services   │─→ Redis ✅
│ Prometheus │─→ All pods (for metrics) ✅
```

### Configuration complète de Network Policies
```yaml
---
# 1. Deny all ingress (par défaut)
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
spec:
  podSelector: {}
  policyTypes:
  - Ingress

---
# 2. Allow frontend to gateway
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-gateway
spec:
  podSelector:
    matchLabels:
      app: gateway
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 3000

---
# 3. Allow gateway to services
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-gateway-to-services
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: gateway
    ports:
    - protocol: TCP
      port: 3000  # Gateway app port
    - protocol: TCP
      port: 3001  # Service ports
    - protocol: TCP
      port: 3002
    # ... etc

---
# 4. Allow services to database
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-services-to-database
spec:
  podSelector:
    matchLabels:
      app: postgres
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: backend
    ports:
    - protocol: TCP
      port: 5432
```

### Security Best Practices (Container Level)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gateway
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true          # Pod ne run pas en root
        runAsUser: 1001             # UID 1001 (nodejs)
        fsGroup: 1001               # Filesystem group
      containers:
      - name: gateway
        image: devopspfe-gateway:latest
        securityContext:
          allowPrivilegeEscalation: false  # Pas d'escalade privileges
          readOnlyRootFilesystem: false    # Root filesystem read-only
          capabilities:
            drop:
              - ALL                        # Drop all Linux capabilities
```

**Pourquoi?**
- Si un container est compromis → L'attaquant n'a pas de privileges
- readOnlyRootFilesystem → Attaquant ne peut pas installer des outils
- drop ALL capabilities → Pas d'accès bas niveau (mount, raw sockets)

---

<a name="cicd"></a>
## 6️⃣ CI/CD & JENKINS PIPELINE (2 MIN)

### Problème sans CI/CD
```
Developer:
  git push code
  ← Long delay for testing, building, deploying
  ← Manual steps prone to errors
  ← Inconsistent environments

Production:
  Bugs discovered after deployment
  Slow recovery from failures
  Difficult to rollback
```

### Solution: Jenkins CI/CD Automatiée
```
Developer → Git Push → Jenkins Pipeline
                       ↓
                   1. Checkout code
                   2. Lint code
                   3. Unit tests
                   4. SonarQube analysis
                   5. Build Docker images
                   6. Security scans
                   7. Push registry
                   8. Deploy K8s
                   9. Smoke tests
                   ↓
                Production Deployment
                (Automated, fast, reliable)
```

### Jenkins Pipeline Stages

#### Stage 1: Checkout & Git Info
```groovy
stage('Checkout') {
  steps {
    checkout scm
    script {
      env.GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", 
                                 returnStdout: true).trim()
      env.GIT_TAG = sh(script: "git describe --tags --always", 
                       returnStdout: true).trim()
      env.IMAGE_TAG = "${env.GIT_TAG}-${env.GIT_COMMIT_SHORT}"
      // Result: v1.0.1-abc123def
    }
  }
}
```

#### Stage 2: Lint & Quality Checks
```groovy
stage('Lint & Quality Checks') {
  parallel {
    stage('Backend Lint') {
      steps {
        dir('backend/gateway') {
          sh 'npm install && npm run lint'
        }
      }
    }
    stage('Frontend Lint') {
      steps {
        dir('frontend/app') {
          sh 'npm ci --legacy-peer-deps && npm run lint'
        }
      }
    }
    stage('Dockerfile Scan') {
      steps {
        sh '''
          for dockerfile in $(find . -name "Dockerfile" -type f); do
            hadolint "$dockerfile"  # Dockerfile linter
          done
        '''
      }
    }
  }
}
```

#### Stage 3: Unit Tests
```groovy
stage('Unit Tests') {
  when {
    expression { params.SKIP_TESTS == false }
  }
  parallel {
    stage('Backend Tests') {
      steps {
        dir('backend/gateway') {
          sh 'npm run test:cov'  // Code coverage
        }
      }
    }
  }
}
```

#### Stage 4: Security Scanning
```groovy
stage('Security Scanning') {
  parallel {
    stage('npm Audit') {
      steps {
        sh 'npm audit --audit-level=moderate'
        // Detects vulnerable packages
      }
    }
    stage('Trivy Image Scan') {
      steps {
        sh '''
          docker run -v /var/run/docker.sock:/var/run/docker.sock \
            aquasec/trivy image --severity HIGH,CRITICAL <image>
        '''
        // Detects CVEs in Docker images
      }
    }
  }
}
```

#### Stage 5: Build Docker Images
```groovy
stage('Build Docker Images') {
  steps {
    script {
      def services = ['gateway', 'user', 'auth', 'activity', 
                      'classroom', 'parent', 'student', 'teacher', 'frontend']
      
      services.each { service ->
        sh '''
          docker build \
            -t devopspfe-${service}:${IMAGE_TAG} \
            -t devopspfe-${service}:latest \
            ./backend/${service}  (or frontend/app for frontend)
        '''
      }
    }
  }
}
```

#### Stage 6: Push to Registry
```groovy
stage('Push to Registry') {
  when {
    branch 'main'  // Only on main branch
  }
  steps {
    withCredentials([usernamePassword(credentialsId: 'docker-hub',
                                      usernameVariable: 'DOCKER_USER',
                                      passwordVariable: 'DOCKER_PASS')]) {
      sh '''
        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
        
        for image in $(docker images | grep devopspfe | awk '{print $1}' | sort -u); do
          docker push ${image}:${IMAGE_TAG}
          docker push ${image}:latest
        done
      '''
    }
  }
}
```

#### Stage 7: Deploy to Kubernetes
```groovy
stage('Deploy to Kubernetes') {
  when {
    expression { params.DEPLOY == true }
  }
  steps {
    sh '''
      # Create namespace
      kubectl create namespace ${ENVIRONMENT} --dry-run=client -o yaml | kubectl apply -f -
      
      # Apply all manifests with image tag
      kubectl kustomize kubernetes/ | \
        sed "s/:latest/:${IMAGE_TAG}/g" | \
        kubectl apply -n ${ENVIRONMENT} -f -
      
      # Wait for rollout
      kubectl rollout status deployment/gateway-deployment -n ${ENVIRONMENT}
    '''
  }
}
```

#### Stage 8: Health Checks & Smoke Tests
```groovy
stage('Smoke Tests') {
  when {
    expression { params.DEPLOY == true }
  }
  steps {
    sh '''
      # Wait for services to be ready
      kubectl wait --for=condition=ready pod \
        -l tier=backend \
        -n ${ENVIRONMENT} \
        --timeout=300s
      
      # Test health endpoints
      GATEWAY_IP=$(kubectl get svc gateway -n ${ENVIRONMENT} \
                   -o jsonpath='{.spec.clusterIP}')
      
      curl -f http://$GATEWAY_IP:3000/health || \
        echo "Health check failed"
    '''
  }
}
```

### Image Tagging Strategy
```
Branch structure:
  main   → v1.0.1          (semantic version)
  dev    → dev-abc123      (commit hash)

Tag pattern: <version>-<commit-hash>

Examples:
  v1.0.0-abc123def     (Production release)
  v1.0.1-def456ghi     (Hotfix)
  dev-abc123def        (Development)

Bénéfices:
  ✅ Identify exact code in images
  ✅ Easy rollback (just change tag)
  ✅ Semantic versioning for releases
  ✅ CI/CD traceability
```

### Deployment Timeline
```
Developer pushes code
    ↓ (5 sec)
Jenkins detects push
    ↓ (2 min)
Code quality checks + tests
    ↓ (3 min)
Build Docker images
    ↓ (5 min)
Security scans
    ↓ (2 min)
Push to Docker Hub
    ↓ (3 min)
Deploy to Kubernetes
    ↓ (2 min)
Health checks
    ↓ (1 min)
✅ Fully deployed + verified
    ↓
Total time: ~23 minutes from code push to production
(With 9 images built in parallel)
```

---

<a name="monitoring"></a>
## 7️⃣ MONITORING & OBSERVABILITÉ (1 MIN)

### Three Pillars of Observability

#### 1. Metrics (Quantitatif)
```yaml
# Prometheus annotations in pod
prometheus.io/scrape: "true"      # Scraper ce pod
prometheus.io/port: "3000"        # Port avec metrics
prometheus.io/path: "/metrics"    # Endpoint /metrics
```

**Métriques collectées:**
```
http_requests_total{method="GET", path="/health", status="200"}
http_request_duration_seconds{method="POST", endpoint="/api/users"}
http_request_size_bytes{method="GET"}
http_response_size_bytes{status="200"}
nodejs_heap_size_bytes
nodejs_gc_duration_seconds
```

#### 2. Logs (Détails)
```
Docker Compose:
  docker-compose logs -f gateway-backend
  
Kubernetes:
  kubectl logs -f gateway-deployment-xyz

Centralisé (ELK Stack):
  Elasticsearch   (storage)
  Kibana          (visualization)
  → All logs from all containers in one place
```

**Log Format:**
```json
{
  "timestamp": "2024-05-04T10:30:45.123Z",
  "level": "INFO",
  "service": "gateway",
  "pod": "gateway-deployment-abc123",
  "message": "User authenticated",
  "userId": "user-456",
  "duration": 125
}
```

#### 3. Traces (Flow)
```
Request trace through system:
  User Request
    ↓ [10ms] → Ingress
    ↓ [5ms] → API Gateway
    ↓ [20ms] → Auth Service (verify JWT)
    ↓ [50ms] → User Service (fetch data)
    ↓ [15ms] → PostgreSQL (query)
    ↓ [30ms] → Response
    ↓
  Total latency: 130ms

Jaeger/Zipkin can trace this:
  - Find bottlenecks
  - Understand dependency chains
  - Debug production issues
```

### Grafana Dashboards
```
1. System Health Dashboard
   - CPU usage (all nodes)
   - Memory usage
   - Disk I/O
   - Network traffic

2. Application Dashboard
   - Request rate
   - Error rate
   - P95 latency
   - Pod restarts

3. Database Dashboard
   - Connection pool
   - Query latency
   - Lock contention
   - Replication lag

4. Custom Dashboards
   - Business metrics
   - Feature-specific
```

### Alerting (Optional)
```yaml
# Prometheus alert rules
groups:
- name: kubernetes
  rules:
  - alert: PodCrashLooping
    expr: rate(kubernetes_pod_container_status_restarts_total[15m]) > 0.1
    for: 5m
    annotations:
      summary: "Pod {{ $labels.pod }} is crash looping"
      
  - alert: HighMemoryUsage
    expr: (container_memory_usage_bytes / container_spec_memory_limit_bytes) > 0.8
    for: 5m
    annotations:
      summary: "Pod {{ $labels.pod }} using 80%+ memory"
```

---

<a name="demo"></a>
## 8️⃣ DÉMO LIVE (5 MIN)

### Démo 1: Docker Compose (2 min)

**Objectif:** Montrer que tous les services démarrent et communiquent

```bash
# 1. Build all images
$ docker-compose build
Démarrage du build...
[frontend-app] Builder compiling Angular
[gateway-backend] NestJS build
[user-service] NestJS build
...
✅ All 9 images built successfully

# 2. Check images
$ docker images | grep devopspfe
devopspfe-gateway-backend:latest       345MB
devopspfe-user-service:latest          364MB
devopspfe-auth-service:latest          369MB
...

# 3. Start everything
$ docker-compose up -d
Creating postgres-db ...
Creating redis-cache ...
Creating rabbitmq-broker ...
Creating elasticsearch ...
Creating gateway-backend ...
...
✅ Started 14 services

# 4. Check health
$ docker-compose ps
NAME                         STATUS
postgres-db                  Up (healthy)
redis-cache                  Up (healthy)
gateway-backend              Up (healthy)
frontend-app                 Up (healthy)
...

# 5. Test API
$ curl http://localhost:3000/health
{"status":"ok", "uptime": 45.2}

# 6. Access Frontend
Open browser: http://localhost:4200
✅ Angular app loads (Bootstrap UI visible)

# 7. Check logs
$ docker-compose logs -f gateway-backend
[INFO] Server listening on port 3000
[INFO] Connected to database
[INFO] Connected to redis
...

# 8. Network inspection
$ docker network ls
app-network   bridge   Connects all services

$ docker network inspect app-network
Containers:
  postgres-db: 172.18.0.2
  redis-cache: 172.18.0.3
  gateway-backend: 172.18.0.4
  ...
```

### Démo 2: Kubernetes (3 min)

**Objectif:** Montrer la scalabilité, résilience, et orchestration

```bash
# 1. Check cluster
$ kubectl get nodes
NAME             STATUS   ROLES   AGE
docker-desktop   Ready    master  2d

$ kubectl get namespaces
default       Active
kube-system   Active
production    Active

# 2. Check pods
$ kubectl get pods -n production
NAME                                    READY   STATUS
gateway-deployment-abc123-xyz           1/1     Running
gateway-deployment-def456-uvw           1/1     Running
user-service-deployment-ghi789-rst      1/1     Running
...
✅ All pods running (2 per service = HA)

# 3. Check services
$ kubectl get svc -n production
NAME              TYPE       CLUSTER-IP   EXTERNAL-IP   PORT(S)
gateway           ClusterIP  10.96.0.1    <none>        3000/TCP
user-service      ClusterIP  10.96.0.2    <none>        3002/TCP
postgres          ClusterIP  10.96.0.3    <none>        5432/TCP
...

# 4. Check Ingress
$ kubectl get ingress -n production
NAME         CLASS   HOSTS              ADDRESS
app-ingress  nginx   api.example.com    192.168.1.100
app-ingress  nginx   app.example.com    192.168.1.100

# 5. Pod resource usage
$ kubectl top pods -n production
NAME                                  CPU(cores)   MEMORY(bytes)
gateway-deployment-abc123-xyz         145m         180Mi
gateway-deployment-def456-uvw         152m         195Mi
user-service-deployment-ghi789        98m          120Mi
...
✅ All within limits (250m CPU / 256Mi memory requests)

# 6. Logs from a pod
$ kubectl logs -f gateway-deployment-abc123-xyz -n production
[Nest] 1234 - 05/04/2024, 10:30:45 AM [NestFactory] ...
[Nest] 1234 - 05/04/2024, 10:30:46 AM  LOG [Bootstrap] ...
[Nest] 1234 - 05/04/2024, 10:30:47 AM  LOG Listening on port 3000

# 7. Port forward to access locally
$ kubectl port-forward svc/gateway 3000:3000 -n production
Forwarding from 127.0.0.1:3000 -> 3000

# In another terminal:
$ curl http://localhost:3000/health
{"status":"ok", "timestamp": "2024-05-04T10:30:45Z"}

# 8. Port forward Grafana
$ kubectl port-forward svc/grafana 3000:3000 -n production
Open browser: http://localhost:3000
✅ Grafana dashboard visible
   - CPU usage: 30%
   - Memory usage: 45%
   - Request rate: 150 req/sec
   - Error rate: 0.2%

# 9. Show Horizontal Pod Autoscaler
$ kubectl get hpa -n production
NAME                     REFERENCE                              TARGETS
gateway-hpa              Deployment/gateway-deployment          35%/70%
user-service-hpa         Deployment/user-service-deployment     42%/70%
...
✅ HPA watching metrics, will scale if > 70% CPU

# 10. Simulate high load and watch scaling
$ kubectl run -i --tty load-generator --rm --image=busybox /bin/bash
/ # while true; do wget -q -O- http://gateway:3000/api/users; done
# (generates 100s of requests per second)

# In another terminal, watch pods:
$ kubectl get pods -w -n production
# Watch as new pods are created automatically!
gateway-deployment-abc123-xyz      1/1     Running
gateway-deployment-def456-uvw      1/1     Running
gateway-deployment-ghi789-jkl      0/1     ContainerCreating  ← NEW!
gateway-deployment-mno012-pqr      0/1     ContainerCreating  ← NEW!
gateway-deployment-stu345-vwx      1/1     Running

# Check HPA status:
$ kubectl get hpa -n production
NAME                     TARGETS
gateway-hpa              95%/70%  → SCALING UP

# 11. Show rolling update (zero downtime)
$ kubectl set image deployment/gateway-deployment \
    gateway=devopspfe-gateway:v1.0.1-new123 \
    -n production

# Watch the rollout:
$ kubectl rollout status deployment/gateway-deployment -n production

# Check pods during update:
$ kubectl get pods -w -n production
# You'll see:
gateway-deployment-abc123-xyz      1/1     Running    ← Old
gateway-deployment-def456-uvw      1/1     Running    ← Old
gateway-deployment-new-jkl-012     0/1     ContainerCreating  ← New
gateway-deployment-new-jkl-345     0/1     Pull... 
gateway-deployment-new-jkl-678     1/1     Running  ← New, Old being terminated
...
# All at the same time = Zero downtime!

# 12. Check Pod Disruption Budget protection
$ kubectl describe pdb gateway-pdb -n production
Name:           gateway-pdb
Min Available:  1

# Try to drain the node:
$ kubectl drain docker-desktop --ignore-daemonsets
# → Will not evict pods if it violates PDB
# → Keeps minAvailable: 1 running

# 13. Network Policy inspection
$ kubectl get networkpolicies -n production
NAME                          POD-SELECTOR   AGE
deny-all-ingress              <none>         1h
allow-frontend-to-gateway     tier=backend   1h
allow-gateway-to-services     tier=backend   1h
allow-services-to-database    app=postgres   1h
...

# Test network policies:
# Try to reach database from frontend pod (should fail):
$ kubectl exec -it frontend-pod -n production /bin/sh
/ # nc -zv postgres 5432
# → Connection refused (by NetworkPolicy)

# But gateway can reach database:
$ kubectl exec -it gateway-pod -n production /bin/sh
/ # nc -zv postgres 5432
# → Connection successful
```

---

<a name="qa"></a>
## 9️⃣ Q&A COMPLET (5 MIN)

### Questions Techniques

**Q1: Pourquoi Kubernetes et pas Docker Compose en production?**

**Réponse:**
```
Docker Compose:
  ✅ Parfait pour développement local
  ✅ Un seul node
  ✅ Pas de scalabilité
  ❌ Un container crash → Manuel restart
  ❌ Pas de rolling updates
  ❌ Pas de resource limits enforcement
  ❌ Pas de multi-node coordination

Kubernetes:
  ✅ Orchestration multi-node
  ✅ Auto-healing (pod crash → restart automatique)
  ✅ Rolling updates (zéro downtime)
  ✅ Resource limits (CPU throttling, memory limits)
  ✅ Horizontal scaling (HPA)
  ✅ Network isolation (Network Policies)
  ✅ Service discovery (DNS)
  ✅ State management (PVC for databases)

Analogie:
  Docker Compose = Conduire seul sur une autoroute
  Kubernetes = Toute une flotte de camions qui se gèrent eux-mêmes
```

---

**Q2: Comment gérez-vous les données persistantes?**

**Réponse:**
```
PersistentVolume (PV):
  - Bloc de stockage dans le cluster
  - Indépendant du pod lifecycle
  - Peut être NFS, iSCSI, block storage, etc.

PersistentVolumeClaim (PVC):
  - Demande de stockage par un pod
  - "Je veux 10Gi de stockage"

Stateful Data:
  PostgreSQL:
    - PVC: 10Gi
    - Mount: /var/lib/postgresql/data
    - Si pod crash → nouvelle pod utilise même PVC
    - Données restent intactes

Redis:
  - PVC avec RDB persistence
  - Snapshots réguliers

Backup:
  - Velero (backup/restore toutes les données)
  - Point-in-time recovery
  - Cross-cluster migration

Exemple de PVC:
  kind: PersistentVolumeClaim
  spec:
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
```

---

**Q3: Quel est votre processus de déploiement en cas de bug critique?**

**Réponse:**
```
Scenario: Bug découvert en production

Normal deployment (23 min):
  Code push → Tests → Build → Registry → K8s deploy

Urgent deployment (3-5 min):
  1. Rollback vers version précédente
     kubectl rollout undo deployment/gateway-deployment
     
  2. Pods redémarrés avec image v1.0.0
     - Zéro downtime (rolling undo)
     - Immédiat (1-2 min)

  3. Investigators fixent le bug en parallèle
     - Tests en local
     - Git commit/push
     - Jenkins pipeline s'exécute
     - New image pushed
     - Redéploiement quand prêt

  4. Métriques en temps réel
     - Error rate: 0.2% → Détecté
     - Rollback trigger automatique possible avec alerting
```

---

**Q4: Comment testez-vous le comportement avant production?**

**Réponse:**
```
Environments:

Development (Local):
  docker-compose up
  - 8 services locaux
  - Toutes les databases
  - Parfait pour développement

Staging (Pre-production):
  Kubernetes sur cluster de staging
  - Configuration identique à prod
  - Données de test synthétiques
  - Tests d'intégration
  - Load testing
  - Sécurité testing

Production:
  Kubernetes sur cluster prod
  - Monitoring actif
  - Alerting configuré
  - Rollback process prêt

Test Strategy:
  1. Unit tests (npm run test)
  2. Integration tests (API)
  3. E2E tests (UI)
  4. Load tests (k6 / JMeter)
  5. Security scanning (Trivy, npm audit)
  6. Manual QA (staging)
  7. Canary deployment (1% traffic)
  8. Full rollout
```

---

**Q5: Qu'arrive-t-il si le node Kubernetes crash?**

**Réponse:**
```
Scenario: Node (serveur physique) crash

Timeline:
  T=0: Node crash
  T=30s: Kubernetes detect node unreachable
  T=35s: Node marked as NotReady
  T=5m: Kubernetes evicts all pods from node
  T=5m30s: Scheduler places pods elsewhere
  T=6m: Pods restarted on other nodes

Result:
  ❌ Brief unavailability (30-60 seconds)
  ✅ Services auto-recover
  ✅ Data restored from PVC
  ✅ No manual intervention needed

Protection:
  - PDB (Pod Disruption Budget)
    → Keeps minAvailable: 1 running on other nodes
  
  - Anti-affinity
    → Distributes pods across multiple nodes
  
  - Multi-zone deployment
    → Nodes in different datacenters/AZs
```

---

**Q6: Comment gérez-vous les secrets en production réelle?**

**Réponse:**
```
Development:
  Kubernetes Secrets (sufficient for dev)
  - Stored in etcd (encrypted at rest)
  - Accessible via ServiceAccount tokens

Production:
  HashiCorp Vault (industry standard)
  
  1. Vault stores secrets (encrypted)
     - DB passwords
     - API keys
     - JWT secrets
     - TLS certificates
  
  2. Pod authenticates to Vault
     kubectl auth can-i get secrets
     → Microauth JWT token
  
  3. Pod retrieves secrets from Vault
     http://vault:8200/v1/secret/data/postgres
     
  4. Secrets never in YAML/logs/git
  
  5. Audit trail (who accessed what/when)
  
  6. Secret rotation (automatic)
     - Change password in Vault
     - Pods fetch new secret
     - No manual update needed

Alternative: AWS Secrets Manager, GCP Secret Manager
```

---

**Q7: Quel est votre SLA (Service Level Agreement)?**

**Réponse:**
```
SLA Target: 99.95% availability

Calculation:
  99.95% = 99.95% of 8760 hours/year
  = ~4.38 hours downtime/year
  = ~22 minutes/month

Achievability:
  ✅ Multi-replica pods (2-5)
  ✅ Health checks (self-healing)
  ✅ Rolling updates (zero downtime)
  ✅ PDB (HA during node maintenance)
  ✅ Network redundancy
  
  → 99.95% achievable

Monitoring:
  - Prometheus uptime tracking
  - AlertManager notifications
  - Incident response playbooks
  - Post-incident reviews (RCA)

Cost of Downtime:
  $5M revenue/day ÷ 86400 sec
  = $57,870 per second of downtime
  → Justifies HA infrastructure
```

---

**Q8: Combien de replicas minimum?**

**Réponse:**
```
Stateless Services (Gateway, API):
  Minimum: 2 replicas
  Reasoning:
    1. Always have 1 backup pod running
    2. Survive 1 pod crash
    3. Allow rolling updates (zero downtime)
    4. Distribute load

  HPA can scale: 2 → 5 max

Stateful Services (PostgreSQL):
  Minimum: 1 replica
  Reasoning:
    - Database is single master
    - Replication adds complexity
    - Can be backed up regularly
    - Restore from backup if crash
  
  Alternative: PostgreSQL HA (Patroni)
    - 3+ replicas
    - Automatic failover
    - More complex

Frontend:
  Minimum: 2 replicas
  Reasoning:
    - Static content, highly cacheable
    - Small footprint (~27MB)
    - Can scale if many users

Cache (Redis):
  Minimum: 1 replica
  Reasoning:
    - Cache is ephemeral
    - Data loss acceptable
    - Recreated from source
  
  Alternative: Redis Cluster
    - HA cache layer
    - If cache hit ratio critical
```

---

**Q9: Comment déployez-vous une base de données nouvelle version?**

**Réponse:**
```
PostgreSQL upgrade (13 → 15)

Risk: Donnéesperdue possible

Procedure:
  1. Backup current database
     pg_dump production > backup-13.sql
     pg_basebackup -D /backup/13
  
  2. Staging test
     Restore backup on staging
     Run upgrade
     Test application
  
  3. Scheduled maintenance window
     - Plan: 2-4 AM (low traffic)
     - Notify users 24h before
  
  4. Execution
     a. Scale down app replicas (prevent writes)
     b. pg_upgrade (in-place upgrade)
        Takes ~30 min for 100GB DB
     c. Vacuum/analyze (optimize)
     d. Run DB tests
     e. Scale up app replicas
     f. Smoke tests
  
  5. Rollback plan
     If issues → Restore from backup
     - 30 min restore time
     - Accept data loss since backup
  
  6. Monitoring
     Query latency
     Connection pool status
     Replication lag
```

---

**Q10: Quel est le coût infrastructure par mois?**

**Réponse:**
```
Cluster Kubernetes (AWS EKS example):

Compute:
  - 3 nodes (t3.large): $0.0832/hour × 730 hours = $60/month
  - Or: 1 node + autoscaling = $30/month

Storage:
  - PostgreSQL (100GB): $11.50/month
  - PVC (10GB): $1.00/month
  - EBS snapshots: $5/month

Network:
  - Data transfer out: $0.09/GB
  - ALB/NLB: $16.20/month
  - NAT Gateway: $32/month

Monitoring:
  - Prometheus: $0 (self-hosted)
  - Grafana Cloud: $0-$99/month

Registry:
  - Docker Hub: $0-$40/month
  - AWS ECR: $0.50/GB per month

Estimation:
  Small (startup): $150-200/month
  Medium (unicorn): $500-1000/month
  Large (enterprise): $2000-5000/month

Cost Optimization:
  - Reserved instances (-40%)
  - Spot instances (-70%)
  - Autoscaling on/off hours
  - Image optimization (compression)
```

---

**Q11: Qu'est-ce que vous changeriez aujourd'hui?**

**Réponse:**
```
Améliorations potentielles:

1. Service Mesh (Istio/Linkerd)
   - Advanced traffic management
   - mTLS entre services
   - Distributed tracing
   - Current: Simple K8s Services

2. Database HA (Patroni)
   - PostgreSQL replication
   - Automatic failover
   - Current: Single instance

3. Backup Strategy
   - Velero pour disaster recovery
   - Cross-region backups
   - Current: Manual pg_dump

4. Secrets Management
   - HashiCorp Vault
   - Current: K8s Secrets

5. API Gateway (Kong/Nginx Ingress+)
   - Rate limiting per user
   - API versioning
   - Current: Basic Ingress

6. GraphQL Layer
   - Apollo Federation
   - Instead of REST
   - Current: REST endpoints

7. Multi-region
   - Failover automatique
   - Lower latency globally
   - Current: Single region

8. CI/CD Optimization
   - GitOps (ArgoCD)
   - Environment promotion
   - Current: Declarative Jenkins

But: YAGNI principle
  - These optimizations have costs
  - Implement when needed (actual pain point)
  - Don't over-engineer
```

---

**Q12: Pouvez-vous supporter 1 million d'utilisateurs?**

**Réponse:**
```
Scalability Analysis:

Current Capacity:
  HPA max 5 replicas × 2 services = 10 pods
  Each pod: 250m CPU, 256Mi memory
  Total: 2500m CPU (2.5 cores), 2.5Gi memory
  
  Can handle: ~10,000 concurrent users

To scale 100x (1 million users):

1. Horizontal Scaling (more pods)
   - HPA max replicas: 100
   - Auto-scale based on CPU/memory
   - Cost: $$$

2. Vertical Scaling (bigger nodes)
   - More CPU/memory per node
   - Can serve more pods per node
   - Cost: $$$

3. Database Scaling
   - Sharding (split data)
   - Read replicas
   - Connection pooling
   - Current: Single PostgreSQL

4. Caching Layers
   - Redis distributed
   - CDN for static content
   - In-memory caches
   - Current: Single Redis

5. Load Balancing
   - Multi-region
   - Global traffic distribution
   - Current: Single Ingress

Estimate:
  Current: 10K concurrent → ~$200/month
  1M users: Need 100x capacity → ~$20K/month + engineering effort

Feasible but:
  - Requires distributed database
  - Service mesh
  - Global infrastructure
  - 6-12 months engineering
```

---

### Questions Non-Techniques

**Q13: Qu'avez-vous appris pendant ce projet?**

**Réponse:**
```
Technical:
  ✅ Kubernetes (Deployments, Services, NetworkPolicies)
  ✅ Docker (Multi-stage builds, optimization)
  ✅ CI/CD (Jenkins pipeline design)
  ✅ Infrastructure as Code (YAML manifestos)
  ✅ Security best practices (Secrets, RBAC)
  ✅ Monitoring (Prometheus, Grafana)
  ✅ Database management (PostgreSQL, PVC)
  ✅ Linux/networking (kubectl, docker, networking)

Soft Skills:
  ✅ Problem-solving under pressure
  ✅ Documentation (essential for team)
  ✅ Testing strategy (unit → integration → E2E)
  ✅ Change management (deploy safely)
  ✅ Cost optimization
  ✅ Disaster recovery planning

Mistakes:
  ❌ First: Kubernetes is hard → Got easier with practice
  ❌ Too many microservices? → Maybe 4-5 better than 8
  ❌ Over-complicating networking → Started simple, added complexity as needed

Biggest Realization:
  "Infrastructure is code. Treat it like software."
  - Version control everything
  - Test before deploy
  - Monitor everything
  - Document decisions
  - Plan for failure
```

---

**Q14: Quelle est la prochaine étape?**

**Réponse:**
```
Immediate (1 month):
  - Deploy to production cluster
  - Set up monitoring alerts
  - Train team on operations
  - Create runbooks (what to do when alert fires)

Short-term (3 months):
  - Collect metrics on performance
  - Optimize based on usage patterns
  - Implement autoscaling thresholds
  - Load test to find bottlenecks

Medium-term (6 months):
  - Service Mesh (Istio) for advanced traffic control
  - Database replication (HA)
  - Multi-region setup
  - Advanced monitoring (distributed tracing)

Long-term (12 months):
  - Full GitOps with ArgoCD
  - Serverless functions (AWS Lambda)
  - AI-powered anomaly detection
  - Zero-knowledge encryption for data at rest
```

---

**Q15: Comment maintenez-vous ce système?**

**Réponse:**
```
Daily:
  - Monitor dashboards (Grafana)
  - Check alerts (Prometheus AlertManager)
  - Review logs (Kibana)
  - ~30 min/day

Weekly:
  - Update dependencies (Dependabot)
  - Review security scans (Trivy)
  - Capacity planning
  - ~2 hours/week

Monthly:
  - Disaster recovery test
  - Cost optimization review
  - Team knowledge sharing
  - ~4 hours/month

Tools for Operations:
  - kubectl (control cluster)
  - Helm (manage releases)
  - Velero (backup/restore)
  - Falco (security monitoring)
  - OPA (policy enforcement)

On-call Process:
  - Alert → Page on-call engineer
  - Engineer: `kubectl logs` + `kubectl describe`
  - Fix (usually: restart pod, scale up, deploy hotfix)
  - RCA (Root Cause Analysis) next day
  - Update runbook
```

---

**Q16: Budget total du projet?**

**Réponse:**
```
Development Phase:
  - Infrastructure (3-4 months): 3 engineers × $5K/month = $45K
  - Tools/licenses: $2K
  - Cloud testing: $5K
  - Total: ~$52K

Operations:
  - Cloud infrastructure: $200-500/month
  - On-call engineer: $3K/month
  - Tools/licenses: $500/month
  - Total: ~$3,700/month

Over 2 years:
  - Development: $52K
  - Operations (24 months): $88,800
  - Unexpected: $10K
  - Total: ~$150K

ROI:
  If product generates $1M revenue
  → Infrastructure cost: 15% of revenue (acceptable)
  
If startup with no revenue yet
  → Can run on $100/month (1 node)
  → Scale later when profitable
```

---

## CONCLUSION

```
Ce projet démontre:

✅ Architecture scalable
✅ DevOps best practices
✅ Production-ready code
✅ Security-first approach
✅ Monitoring & observability
✅ Cost optimization
✅ Team collaboration

Technologies mastered:
✅ Docker & Containerization
✅ Kubernetes Orchestration
✅ Infrastructure as Code
✅ CI/CD Automation
✅ Cloud-native mindset

Prêt pour:
✅ Production deployment
✅ Enterprise environments
✅ High-traffic applications
✅ Team leadership
```

---

**Fin de la présentation. Questions?**
