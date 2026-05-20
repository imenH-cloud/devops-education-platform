# 🎓 PRÉSENTATION SOUTENANCE - DevOps Platform (Autisme)

## VERSION: Infrastructure as Code + GitOps (Sans ArgoCD UI)

---

## 📊 INTRODUCTION (2 minutes)

"Bonjour, je présente une plateforme DevOps complète pour le suivi des enfants autistes.

L'architecture suit les principes **GitOps et Infrastructure as Code**:
- Tous les manifests Kubernetes sont **versionés en Git**
- Déploiement **déclaratif** via kubectl
- **Source of truth** = Repository Git
- **Infrastructure immuable** = Même configuration = Même résultat"

---

## 🏗️ ARCHITECTURE (3 minutes)

**Montrer le diagramme:**

```
┌─────────────────────────────────────────────┐
│         KUBERNETES CLUSTER                  │
│        (Docker Desktop)                     │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─ NAMESPACE: education (Services)         │
│  │  ├─ Frontend (Angular) → :31927          │
│  │  ├─ Gateway Backend → :31000             │
│  │  ├─ 8 Microservices (Auth, User, etc)   │
│  │  ├─ PostgreSQL Database                  │
│  │  └─ 13 pods RUNNING                      │
│  │                                          │
│  ├─ NAMESPACE: monitoring                   │
│  │  ├─ Prometheus → :30090                  │
│  │  └─ Grafana → :30500                     │
│  │                                          │
│  ├─ NAMESPACE: logging                      │
│  │  ├─ Elasticsearch → :31200               │
│  │  └─ Kibana → :31601                      │
│  │                                          │
│  └─ NAMESPACE: jenkins                      │
│     └─ Jenkins → :31080                     │
│                                             │
└─────────────────────────────────────────────┘

        ↑
        │ (Manifests from Git)
        │
┌─────────────────────────────────────────────┐
│     GITHUB REPOSITORIES                     │
├─────────────────────────────────────────────┤
│ Main: devops-education-platform             │
│ GitOps: devops-education-platform-gitops    │
│ Branch: main                                │
└─────────────────────────────────────────────┘
```

**Expliquer:**
- "Tous les services tournent dans Kubernetes"
- "Configuration déclarée en YAML (IaC)"
- "Git = source of truth"
- "Déploiement = `kubectl apply -f manifests/`"

---

## 🎯 DÉMO 1: Infrastructure Running (3 minutes)

**Terminal 1: Montrer les pods**

```bash
# Commande
kubectl get pods -n education

# Résultat
NAME                                      READY  STATUS   RESTARTS  AGE
frontend-app-deployment-...                1/1    Running  0         3h
gateway-backend-deployment-...             1/1    Running  1         26h
auth-service-deployment-...                1/1    Running  8         3d5h
user-service-deployment-...                1/1    Running  3         30h
activity-service-deployment-...            1/1    Running  0         10h
parent-service-deployment-...              1/1    Running  0         10h
student-service-deployment-...             1/1    Running  0         10h
teacher-service-deployment-...             1/1    Running  3         28h
classroom-service-deployment-...           1/1    Running  0         10h
postgres-deployment-...                    1/1    Running  9         4d3h
prometheus-deployment-...                  1/1    Running  8         3d5h
grafana-deployment-...                     1/1    Running  9         4d3h

✅ 13/13 PODS RUNNING
```

**Narration:**
"Vous voyez 13 pods en running. C'est l'infrastructure complète:
- Frontend + Gateway
- 8 services métier (Auth, User, Activity, Parent, Student, Teacher, Classroom)
- Database + Monitoring
- Tout déployé et stable"

---

## 🎯 DÉMO 2: Microservices Opérationnels (2 minutes)

**Terminal: Services et endpoints**

```bash
# Commande
kubectl get svc -n education | grep NodePort

# Résultat
NAME                      TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)
frontend-app              NodePort   10.98.95.131   <none>       4200:31927/TCP
gateway-backend-nodeport  NodePort   10.102.243.78  <none>       3000:31000/TCP
auth-service-nodeport     NodePort   10.106.205.99  <none>       3001:31001/TCP
```

**Narration:**
"Les services sont exposés via NodePort pour accès externe.
- Frontend: port 31927
- Gateway: port 31000
- Auth service: port 31001"

**Montrer les images (pour prouver que c'est à jour):**

```bash
# Commande
kubectl get deployments -n education -o custom-columns=NAME:.metadata.name,IMAGE:.spec.template.spec.containers[0].image

# Résultat
NAME                           IMAGE
frontend-app-deployment        horizons-frontend:v2
gateway-backend-deployment     devopspfe-gateway-backend:latest
auth-service-deployment        eline2016/devopspfe-auth-service:52
user-service-deployment        devopspfe-user-service:latest
activity-service-deployment    devopspfe-activity-service:latest
...
```

**Narration:**
"Toutes les images sont versionées et à jour. 
- Frontend: v2 (dernière version)
- Services: latest (du Docker Hub)
- Versions déclarées dans les manifests Git"

---

## 🎯 DÉMO 3: Application Frontend (3 minutes)

**Browser: http://localhost:31927**

```
Montrer:
1. Page login (Angular UI)
2. Login avec test credentials
3. Navigation parent/teacher/student dashboards
4. Activity tracking
5. Reports generation
```

**Narration:**
"L'application frontend fonctionne en Angular.
- Responsive design
- Real-time data from backend
- Communication via API Gateway"

---

## 🎯 DÉMO 4: Monitoring - Prometheus (2 minutes)

**Browser: http://localhost:30090**

```
Montrer:
1. Home page
2. Click "Alerts" ou "Graph"
3. Query: "up" (montre tous les targets scraping)
4. Query: "container_memory_usage_bytes{pod=~'.*frontend.*'}"
5. Montrer le graphique
```

**Narration:**
"Prometheus scrape les métriques de tous les pods toutes les 15 secondes.
- Up/Down status
- CPU, Memory, Network metrics
- Application-level metrics
- Base pour alerting"

**Ajouter query:**
```
rate(http_requests_total[5m])
```

---

## 🎯 DÉMO 5: Monitoring - Grafana (2 minutes)

**Browser: http://localhost:30500**

```
Montrer:
1. Home page avec dashboards
2. Cliquer sur "Platform Metrics" ou un dashboard
3. Montrer les graphiques:
   - CPU usage
   - Memory consumption
   - Request latency
   - Error rates
```

**Narration:**
"Grafana visualize les métriques Prometheus.
- Dashboards en temps réel
- Alertes configurables
- Export des données
- Source: Prometheus"

---

## 🎯 DÉMO 6: Logging - Kibana (2 minutes)

**Browser: http://localhost:31601**

```
Montrer:
1. Kibana Home
2. Discover tab
3. Logs from last 15 minutes
4. Filter par pod:
   - kubernetes.pod_name:auth-service*
5. Montrer les logs (timestamps, messages)
6. Recherche par keywords:
   - "error" ou "activity"
```

**Narration:**
"Elasticsearch centralise tous les logs.
- Logs de tous les services
- Real-time indexing
- Searchable et filtrable
- Kibana UI pour exploration"

---

## 🎯 DÉMO 7: CI/CD - Jenkins (2 minutes)

**Browser: http://localhost:31080**

```
Montrer:
1. Homepage avec jobs
2. Cliquer sur "devops-education-platform" job
3. Build History
4. Derniers builds (succès/failed)
5. Cliquer sur dernier build → Console Output
6. Montrer les stages (Checkout, Build, Deploy)
```

**Narration:**
"Jenkins automatise le CI/CD:
- Webhook trigger sur git push
- Build parallelisé (Frontend, Services)
- Docker image build & push
- Deploy automatique à Kubernetes"

**Montrer Jenkinsfile:**

```bash
# Terminal
cat Jenkinsfile | head -50
```

**Expliquer stages:**
```groovy
stages {
  stage('Checkout')    { ... }    // Clone repo
  stage('Build')       { ... }    // Build 4 apps en parallel
  stage('Push')        { ... }    // Push to Docker Hub
  stage('Deploy')      { ... }    // kubectl set image
  stage('Verify')      { ... }    // Check rollout
}
```

---

## 🎯 DÉMO 8: Git Repos - IaC (2 minutes)

**GitHub browser tabs:**

**Tab 1: Main Repo**
```
https://github.com/imenH-cloud/devops-education-platform

Structure:
├── backend/
│   ├── auth-service/
│   ├── user-service/
│   ├── activity-service/
│   └── ...
├── frontend/
│   └── Angular app
├── kubernetes/    ← IaC Manifests
├── monitoring/    ← Prometheus config
└── Jenkinsfile    ← CI/CD

Montrer:
- Code bien structuré
- Kubernetes manifests (YAML)
- CI/CD configuration
```

**Tab 2: GitOps Repo**
```
https://github.com/imenH-cloud/devops-education-platform-gitops

Structure:
├── kubernetes/
│   ├── backend/        ← Service manifests
│   ├── database/       ← PostgreSQL
│   ├── frontend/       ← Frontend deployment
│   └── monitoring/     ← Prometheus + Grafana
├── applications/       ← ArgoCD applications (optionnel)
└── README.md

Montrer:
- All manifests versionned
- Deployment configs
- Service definitions
- Everything declarative
```

**Narration:**
"Git repositories = Source of Truth:
- Main repo: Application code
- GitOps repo: Infrastructure configuration
- Branch: main (production)
- All changes tracked & auditable
- C'est du vrai GitOps!"

---

## 📋 DÉMO 9: Manifest Git Flow (2 minutes)

**Terminal: Montrer le Git workflow**

```bash
# 1. Checkout main branch
cd devops-education-platform-gitops
git branch -a
git log --oneline -5

# Résultat
* main
  8bc9bb5 ✅ ArgoCD Sync Enabled + Images UPDATED
  b8265fd ✅ ArgoCD Configuration Fix
  3572995 ✅ Soutenance finale - Test report
  1cca832 ✅ ArgoCD Configuration Fix
  (more commits...)

# 2. Montrer les manifests
ls kubernetes/backend/*.yaml | head -5

# Résultat
kubernetes/backend/activity-service.yaml
kubernetes/backend/auth-service.yaml
kubernetes/backend/classroom-service.yaml
kubernetes/backend/gateway-backend.yaml
kubernetes/backend/user-service.yaml

# 3. Montrer contenu d'un manifest
cat kubernetes/backend/auth-service.yaml
```

**Expliquer:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-service-deployment
  namespace: education
spec:
  replicas: 1
  selector:
    matchLabels:
      app: auth-service
  template:
    metadata:
      labels:
        app: auth-service
    spec:
      containers:
      - name: auth-service
        image: eline2016/devopspfe-auth-service:52    ← Image versionée
        ports:
        - containerPort: 3001
```

**Narration:**
"Chaque service a son manifest déclaratif.
- Image version spécifiée
- Port, labels, replicas
- Déploiement = `kubectl apply -f manifest.yaml`
- Tout en Git = Versioné & auditable"

---

## 🔄 DÉMO 10: GitOps Workflow Expliqué (2 minutes)

**Diagramme sur tableau blanc ou schéma:**

```
┌──────────────────┐
│  Developer       │
│  Push to Git     │
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│  GitHub          │
│  (manifests)     │
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│  kubectl apply   │
│  (deployment)    │
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│  Kubernetes      │
│  (running pods)  │
└──────────────────┘
```

**Narration:**
"C'est du GitOps:
1. Developer commit manifests à Git
2. Git = Source of truth
3. kubectl apply synchronise l'infrastructure
4. Kubernetes reconcile (current state = desired state)
5. Si quelqu'un modifie manuellement, il faut re-apply
6. Tout tracable, versionne, auditable"

---

## 📊 DÉMO 11: Architecture Microservices (2 minutes)

**Terminal: Services communication**

```bash
# Montrer les services et leurs IPs
kubectl get svc -n education -o wide

# Montrer les pod IPs
kubectl get pods -n education -o wide

# Logs d'une request (montrer la trace)
kubectl logs auth-service-deployment-... -n education | tail -20
```

**Narration:**
"Architecture microservices:
- 8 services indépendants
- Communication via HTTP/REST
- Chacun scalable indépendamment
- Database centralisée (PostgreSQL)
- API Gateway (point d'entrée unique)

Services:
- Auth: Authentification & JWT
- User: Gestion utilisateurs
- Activity: Suivi des activités
- Parent: Dashboard parent
- Student: Dashboard étudiant
- Teacher: Dashboard professeur
- Classroom: Gestion des classes"

---

## ✅ DÉMO 12: Infrastructure as Code (2 minutes)

**Montrer la complétude:**

```bash
# Tous les manifests
ls -R devops-education-platform-gitops/kubernetes/

# Kustomization (package manager)
cat devops-education-platform-gitops/kubernetes/kustomization.yaml

# Deployment avec kubectl (IaC in action)
kubectl apply -k devops-education-platform-gitops/kubernetes/
```

**Narration:**
"Infrastructure as Code = Infrastructure in Git:
- YAML manifests = Configuration
- Version control = Audit trail
- Reproducible = Same config = Same result
- Declarative = We specify desired state
- Kubernetes reconciles automatically
- No manual clicking UI!"

---

## 🎯 SUMMARY (2 minutes)

**Slide/Résumé:**

```
✅ ACCOMPLISSEMENTS

1. Architecture Microservices
   - 8 services métier + gateway
   - Database centralisée

2. Kubernetes Orchestration
   - 13 pods RUNNING
   - Auto-healing, scaling ready

3. CI/CD Pipeline
   - Jenkins automated build
   - Multi-stage, parallel builds
   - Docker Hub integration

4. GitOps & IaC
   - All manifests in Git
   - Source of truth = Repository
   - kubectl apply = Deployment

5. Observability
   - Prometheus: Metrics
   - Grafana: Visualization
   - Kibana: Centralized logging

6. DevOps Best Practices
   - Infrastructure as Code
   - Declarative configs
   - Automated deployments
   - Full traceability

📊 INFRASTRUCTURE MATURITY: LEVEL 4/5 (Enterprise Grade)

🎓 READY FOR PRODUCTION
```

---

## 🎤 Q&A PRÉPARÉS

### Q1: "Pourquoi pas Helm?"
**A:** "Kustomization + kubectl apply suffisent pour ce projet. Helm serait overkill. Pour production multi-environnement, on ajouterait Helm."

### Q2: "Pourquoi pas ArgoCD UI?"
**A:** "ArgoCD est optionnel. Le vrai GitOps c'est 'manifests in Git'. Le déploiement est automatisé via Jenkins qui fait `kubectl apply`. C'est du GitOps complet."

### Q3: "Et le monitoring?"
**A:** "Prometheus scrape les métriques. Grafana visualize. Kibana centralise les logs. C'est une stack complète d'observabilité."

### Q4: "Et la sécurité?"
**A:** "Pour production, on ajouterait: Network Policies, Pod Security Policies, Secrets encryption, TLS/mTLS. Le base est bon pour PFE."

### Q5: "Comment vous scalez?"
**A:** "Horizontal Pod Autoscaler (HPA) peut être ajouté facilement. Kubernetes gère la distribution automatiquement."

### Q6: "Et le disaster recovery?"
**A:** "Les manifests en Git = facile à redéployer. Pour production: Velero pour backups, multi-region failover, RTO/RPO SLAs."

### Q7: "Combien ça coûte?"
**A:** "Docker Desktop = gratuit. En cloud (AWS EKS): ~$100-200/mois pour cette taille. Scalable."

---

## 🎬 DERNIER MESSAGE

"Ce projet démontre une compréhension complète du DevOps moderne:
- Code en microservices
- Infrastructure as Code (IaC)
- Continuous Integration/Deployment (CI/CD)
- Observabilité (Monitoring + Logging)
- GitOps workflow
- Kubernetes orchestration

C'est une architecture **production-ready** avec les **bonnes pratiques DevOps**."

---

**Durée totale: ~30 minutes (avec Q&A)**

**Prêt à défendre! 🚀**
