# 🎓 PRÉSENTATION SOUTENANCE - COMPLÈTE & DÉTAILLÉE

## INFRASTRUCTURE MONITORING & GITOPS

---

## 📊 PARTIE 1: PROMETHEUS & GRAFANA - MONITORING DÉTAILLÉ

### ✅ PROMETHEUS - Métriques Kubernetes

**URL:** http://localhost:30090

**Configuration:**
```
4 Scrape Jobs Actifs:
1. prometheus (self-monitoring)         ✅ UP
2. kubernetes-apiservers                 ← API Server metrics
3. kubelet                               ← Node & Container metrics  
4. kubernetes-cadvisor                   ← cAdvisor container metrics
5. kubernetes-pods                       ← Service monitoring
```

**Métriques collectées:**
- CPU usage (node-level)
- Memory utilization (containers)
- Network I/O
- Pod lifecycle metrics
- Container runtime metrics

**DÉMO À MONTRER:**
```bash
# Terminal
kubectl get pods -n monitoring
# Afficher: Prometheus pod RUNNING

# Browser
http://localhost:30090
Menu: Status → Targets
Montrer: 4 scrape jobs
Afficher: prometheus UP ✅

Menu: Status → Configuration
Montrer: YAML config complet avec 5 jobs
```

---

### ✅ GRAFANA - Visualisation & Dashboards

**URL:** http://localhost:30500

**Credentials:**
- Username: admin
- Password: admin

**Configuration:**
- DataSource: Prometheus (http://prometheus-clusterip:9090)
- Dashboards disponibles:
  - Node Exporter Full
  - Kubernetes Cluster Monitoring
  - Container Metrics

**DÉMO À MONTRER:**
```bash
# Browser
http://localhost:30500
Login: admin / admin

Home → Dashboards
Cliquer sur un dashboard disponible
Montrer:
  - CPU usage graphs
  - Memory utilization  
  - Network metrics
  - Pod metrics
  - Real-time data refresh

Important: Afficher l'affichage graphique!
  - X-axis: Temps
  - Y-axis: Valeurs (CPU %, Memory MB, etc.)
  - Lines: Multi-series (différents pods/nodes)
  - Légende avec colors
```

**EXPLICATION À DONNER:**
"Grafana consomme les métriques de Prometheus et crée des dashboards interactifs:
- Monitoring en temps-réel
- Alertes visuelles
- Historical data (30 jours de retention)
- Multi-metrics correlation"

---

## 🎯 PARTIE 2: ARGOCD - GITOPS DÉCLARATIF

### ✅ ARGOCD Installation

**URL:** http://localhost:32325

**Credentials:**
- Username: admin
- Password: ES8c-5uGjx5YjWIL

**Infrastructure:**
```
Namespace: gitops
Pods: 7 RUNNING
- argocd-server (UI)
- argocd-application-controller
- argocd-repo-server
- argocd-dex-server
- argocd-applicationset-controller
- argocd-notifications-controller
- argocd-redis
```

**DÉMO À MONTRER:**
```bash
# Terminal
kubectl get pods -n gitops
Afficher: 7 pods RUNNING

kubectl get svc -n gitops
Afficher: argocd-server-nodeport → port 32325

# Browser
http://localhost:32325
Login: admin / ES8c-5uGjx5YjWIL

ArgoCD UI Affichage:
  - Home: Applications view
  - Repositories: Git repos connectés
  - Settings: Configuration
  - Notifications: Sync status
```

---

## 📈 PARTIE 3: ARCHITECTURE GLOBALE

### Infrastructure Complète:

```
┌─────────────────────────────────────────────────┐
│            KUBERNETES CLUSTER                   │
│         (Docker Desktop Kubernetes)             │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─ NAMESPACE: education                        │
│  │  ├─ Frontend (Angular) - :31927             │
│  │  ├─ Gateway Backend - :31000                │
│  │  ├─ 8 Microservices (Auth, User, etc)       │
│  │  ├─ PostgreSQL Database                      │
│  │  └─ 11 pods RUNNING                         │
│  │                                              │
│  ├─ NAMESPACE: monitoring                       │
│  │  ├─ Prometheus → :30090                     │
│  │  ├─ Grafana → :30500                        │
│  │  └─ 2 pods RUNNING                          │
│  │                                              │
│  ├─ NAMESPACE: gitops                           │
│  │  ├─ ArgoCD Server → :32325                  │
│  │  ├─ ArgoCD Controllers                       │
│  │  └─ 7 pods RUNNING                          │
│  │                                              │
│  ├─ NAMESPACE: logging                          │
│  │  ├─ Elasticsearch                            │
│  │  ├─ Kibana → :31601                         │
│  │  └─ 2 pods RUNNING                          │
│  │                                              │
│  ├─ NAMESPACE: jenkins                          │
│  │  └─ Jenkins → :31080                        │
│  │                                              │
│  ├─ NAMESPACE: message-queue                    │
│  │  └─ RabbitMQ → :32672                       │
│  │                                              │
│  └─ NAMESPACE: cache                            │
│     └─ Redis                                    │
│                                                 │
└─────────────────────────────────────────────────┘

        ↑                           ↑
        │ (Kubernetes API)    (Git Webhooks)
        │                           │
┌───────┴────────────┐   ┌─────────┴────────┐
│  Prometheus        │   │  GitHub Repos    │
│  (Metrics)         │   │  (Infrastructure)│
└────────────────────┘   └──────────────────┘
        ↓
┌──────────────────────┐
│  Grafana Dashboards  │
│  (Visualization)     │
└──────────────────────┘
```

---

## 🎬 SCRIPT DE DÉMO COMPLET

### 1️⃣ MONTRER L'INFRASTRUCTURE (1 min)

```bash
# Terminal
kubectl get nodes
kubectl get namespaces
kubectl get pods --all-namespaces | grep -E "education|monitoring|gitops"

# Affichage
education: 11 pods RUNNING
monitoring: 2 pods RUNNING
gitops: 7 pods RUNNING
Total: 20+ pods
```

### 2️⃣ MONTRER PROMETHEUS (2 min)

**Browser:** http://localhost:30090

```
Status tab:
  Targets subtab → Afficher 4 scrape jobs
  Configuration subtab → Montrer le YAML config

Graph tab:
  Query: up (pour montrer tous les targets)
  Afficher: Time-series graph avec la métrique "up"
```

**Narration:**
"Prometheus scrape 4 sources:
- Son propre health (self-monitoring)
- Les API servers Kubernetes
- Les kubelet nodes (CPU, memory, network)
- Les cAdvisor container metrics

Cela donne une vue complète de la santé infrastructure."

### 3️⃣ MONTRER GRAFANA (3 min)

**Browser:** http://localhost:30500

```
Login: admin/admin

Home → Dashboards → Sélectionner un dashboard

Affichage Important:
  - Title: "Node Exporter Full" ou "Kubernetes Cluster"
  - Panels avec graphiques colorés
  - X-axis: Timestamp (dernières 24h)
  - Y-axis: Valeurs (CPU %, Memory MB)
  - Multiple metrics (lines de couleur différente)
  - Legend en bas (pod names, node names)

Interactions:
  - Hover over graph → voir les valeurs
  - Time range selector (top right)
  - Zoom/pan sur le graphique
```

**Narration:**
"Grafana consomme les métriques Prometheus et crée:
- Dashboards interactifs en temps-réel
- Visualisation des trends historiques
- Multi-metrics correlation
- Alerting basé sur les seuils

Par exemple ce dashboard affiche:
- CPU usage par pod/node
- Memory utilization
- Network I/O
- Container metrics

Tout mis à jour toutes les 15 secondes (scrape interval)."

### 4️⃣ MONTRER ARGOCD (2 min)

**Browser:** http://localhost:32325

```
Login: admin/ES8c-5uGjx5YjWIL

Affichage:
  - Home: Applications section
  - Repositories: GitHub repos connectés
  - Settings: Configuration

ArgoCD UI Elements:
  - Application cards (si créées)
  - Sync status
  - Health status
  - Deployment history
```

**Narration:**
"ArgoCD implémente GitOps déclaratif:
- Source of truth: Git repository
- Target: Kubernetes cluster
- Synchronisation automatique

Si l'infrastructure change en Git, ArgoCD le déploie automatiquement.
Si quelqu'un change manuellement le cluster, ArgoCD l'alerte (out of sync)."

### 5️⃣ MONTRER L'INFRASTRUCTURE APPLICATION (2 min)

**Terminal:**
```bash
kubectl get deployments -n education -o custom-columns=NAME:.metadata.name,IMAGE:.spec.template.spec.containers[0].image

# Affichage
NAME                           IMAGE
frontend-app-deployment        horizons-frontend:v2
gateway-backend-deployment     devopspfe-gateway-backend:latest
auth-service-deployment        eline2016/devopspfe-auth-service:52
...
```

**Browser:**
```
http://localhost:31927
Afficher: Frontend app running
Login, dashboards, data
```

---

## 💡 POINTS CLÉS À SOULIGNER

### Monitoring:
✅ **Prometheus** = Collecte de métriques infrastructure (CPU, memory, network)
✅ **Grafana** = Visualisation en temps-réel + dashboards
✅ **Retention** = 30 jours de données historiques
✅ **Alerting** = Rules basées sur les seuils

### GitOps:
✅ **ArgoCD** = Déploiement déclaratif depuis Git
✅ **Source of Truth** = GitHub repository = source unique
✅ **Automation** = Sync automatique cluster ↔ Git
✅ **Audit Trail** = Tout dans Git (qui a changé quoi)

### Infrastructure:
✅ **Microservices** = 9 services découplés
✅ **Database** = PostgreSQL scalable
✅ **Caching** = Redis performance
✅ **Message Queue** = RabbitMQ async
✅ **CI/CD** = Jenkins automated

---

## 📋 RÉPONSES AUX QUESTIONS COURANTES

**Q: "Prometheus ne scrape pas les applications?"**
A: "Nos services n'exposent pas l'endpoint /metrics. C'est normal pour un PFE. 
   Le monitoring infrastructure (CPU, memory, network) fonctionne correctement.
   Pour la production, on ajouterait les endpoints /metrics."

**Q: "Pourquoi ArgoCD dans un namespace séparé?"**
A: "ArgoCD est l'orchestrateur GitOps. Le séparer en namespace dédié:
   - Isolation des contrôles
   - Permissions granulaires
   - Facilite la gestion"

**Q: "Comment Grafana accède à Prometheus?"**
A: "DataSource configurée pointant sur prometheus-clusterip:9090
   Grafana poll les métriques toutes les 30s (par défaut)
   Les dashboards refresh toutes les 15s (configurable)"

**Q: "Soutenance: combien de temps sur monitoring?"**
A: "5-7 minutes max. Focus sur:
   - Prometheus: affichage de 4 scrape jobs (1 min)
   - Grafana: montrer 2-3 dashboards avec graphs (2 min)
   - ArgoCD: montrer UI + expliquer GitOps (2 min)
   - Application: montrer frontend running (1 min)"

---

## ✅ CHECKLIST JOUR J

**30 min avant:**
- [ ] Docker Desktop running
- [ ] kubectl cluster-info OK
- [ ] kubectl get pods -n education (11 pods)
- [ ] kubectl get pods -n monitoring (2 pods)
- [ ] kubectl get pods -n gitops (7 pods)
- [ ] Browser tabs ouverts (6 tabs min)

**Pendant la présentation:**
- [ ] Terminal: kubectl get pods → montrer 20+ pods
- [ ] Prometheus: Afficher Status → Targets (4 jobs)
- [ ] Grafana: Afficher 2-3 dashboards avec graphs
- [ ] ArgoCD: Login et montrer UI
- [ ] Frontend: Afficher l'app qui fonctionne
- [ ] GitHub: Montrer repos + commits

**Points forts à souligner:**
- [ ] Infrastructure complète (25+ pods)
- [ ] Monitoring production-ready
- [ ] GitOps declaratif
- [ ] CI/CD automated
- [ ] Microservices scalable

---

## 📚 RÉFÉRENCES

- Prometheus: http://localhost:30090
- Grafana: http://localhost:30500
- ArgoCD: http://localhost:32325
- Kibana: http://localhost:31601
- Jenkins: http://localhost:31080
- Frontend: http://localhost:31927

---

**Soutenance: 100% GO! 🚀**

Vous êtes préparé(e)!
