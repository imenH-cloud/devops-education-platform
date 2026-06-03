# 📸 GUIDE SCREENSHOTS POUR LA DÉFENSE

**Prendre les screenshots dans cet ordre:**

---

## 1️⃣ PODS & NAMESPACES (Infrastructure Status)

### Screenshot 1.1: All Pods Running
```powershell
kubectl get pods -A
```
**Pourquoi:** Montre les 15 composants opérationnels  
**Cible:** Jury verra 14+ pods en Running

---

### Screenshot 1.2: Education Namespace Detail
```powershell
kubectl get pods -n education -o wide
```
**Pourquoi:** Zoom sur les 10 microservices  
**Cible:** Montre 10/10 services running

---

### Screenshot 1.3: Services & NodePorts
```powershell
kubectl get svc -n education
```
**Pourquoi:** Montre la distribution des ports  
**Cible:** Juryfera le lien Gateway → Services

---

## 2️⃣ MONITORING STACK (Prometheus + Grafana)

### Screenshot 2.1: Prometheus UI
**URL:** http://localhost:9090  
**Actions:**
1. Cliquer sur "Graph"
2. Entrer requête: `up`
3. Afficher les résultats
**Pourquoi:** Montre les métriques collectées en temps réel

---

### Screenshot 2.2: Prometheus Targets
**URL:** http://localhost:9090/targets  
**Actions:**
1. Afficher la page "Targets"
2. Montrer tous les job actifs
**Pourquoi:** Montre que Prometheus scrape tous les services

---

### Screenshot 2.3: Grafana Login
**URL:** http://localhost:3001  
**Entrer:** admin / admin  
**Pourquoi:** Montrer l'accès sécurisé

---

### Screenshot 2.4: Grafana Dashboard
**Actions:**
1. Cliquer sur "Dashboards" → "Browse"
2. Sélectionner ou créer un dashboard
3. Afficher les metrics (CPU, Memory)
**Pourquoi:** Visualisation temps réel des métriques

---

## 3️⃣ LOGGING STACK (Elasticsearch + Kibana)

### Screenshot 3.1: Elasticsearch Cluster Health
**Terminal:**
```powershell
curl http://localhost:9200/_cluster/health | ConvertFrom-Json | Format-Table -AutoSize
```
**Pourquoi:** Montre status GREEN

---

### Screenshot 3.2: Elasticsearch Indices
**URL:** http://localhost:9200/_cat/indices  
**Pourquoi:** Montre 28+ indices de logs

---

### Screenshot 3.3: Kibana Login
**URL:** http://localhost:5601  
**Pourquoi:** Montrer l'accès à Kibana

---

### Screenshot 3.4: Kibana Dashboard
**Actions:**
1. Aller à Analytics
2. Faire une requête de logs
3. Montrer les résultats avec timestamp
**Pourquoi:** Logs searchables et filtrable

---

## 4️⃣ MESSAGE QUEUE & CACHE

### Screenshot 4.1: RabbitMQ Management
**URL:** http://localhost:15672  
**Credentials:** guest / guest  
**Afficher:**
- Connections
- Channels
- Queues
**Pourquoi:** Message broker fonctionnel

---

### Screenshot 4.2: Redis Status
**Terminal:**
```powershell
kubectl logs -n cache deployment/redis --tail=10
```
**Pourquoi:** Montre cache prêt et persistent

---

## 5️⃣ GITOPS (ArgoCD)

### Screenshot 5.1: ArgoCD Namespace
**Terminal:**
```powershell
kubectl get all -n argocd-new
```
**Pourquoi:** Montre ArgoCD déployé

---

### Screenshot 5.2: ArgoCD Application
**Terminal:**
```powershell
kubectl get application -n argocd-new
```
**Pourquoi:** Application education-platform enregistrée

---

### Screenshot 5.3: ArgoCD UI (Si prêt)
**URL:** http://localhost:8080  
**Pourquoi:** Show GitOps controller UI (si stable)

---

## 6️⃣ KUBERNETES DETAILS

### Screenshot 6.1: Deployments
```powershell
kubectl get deployments -A
```
**Pourquoi:** Montre tous les déploiements

---

### Screenshot 6.2: Rollout Status
```powershell
kubectl rollout status deployment -n education
```
**Pourquoi:** Tous les services stable

---

### Screenshot 6.3: Resource Usage
```powershell
kubectl top nodes
```
**Pourquoi:** Cluster usage normal

---

## 7️⃣ JENKINS & GIT

### Screenshot 7.1: Jenkinsfile
**Fichier:** D:\project\devopsPFE\Jenkinsfile  
**Pourquoi:** Montrer le pipeline CI/CD

---

### Screenshot 7.2: GitHub Repositories
**URLs:**
- Source: https://github.com/imenH-cloud/devops-education-platform
- GitOps: https://github.com/imenH-cloud/devopsPFE-main
**Pourquoi:** Deux repos (source + infrastructure)

---

### Screenshot 7.3: Docker Hub
**URL:** https://hub.docker.com/u/eline2016  
**Pourquoi:** Images poussées automatiquement

---

## 📋 CHECKLIST SCREENSHOTS

### Infrastructure (6 images)
- [ ] All pods status
- [ ] Education namespace detail
- [ ] Services & ports
- [ ] Deployments overview
- [ ] Resource usage
- [ ] Namespaces list

### Monitoring (4 images)
- [ ] Prometheus Graph
- [ ] Prometheus Targets
- [ ] Grafana Dashboard
- [ ] Prometheus Alerts

### Logging (3 images)
- [ ] Elasticsearch Health
- [ ] Kibana Search
- [ ] Log Results

### GitOps (3 images)
- [ ] ArgoCD namespace
- [ ] ArgoCD application
- [ ] Application status

### Code/Git (3 images)
- [ ] Jenkinsfile content
- [ ] GitHub repos
- [ ] Docker Hub images

**Total: ~19 images stratégiques**

---

## 🎬 ORDER DE PRÉSENTATION

### Slides Physiques avec Screenshots

**Slide 1: Architecture Overview**
- Diagramme texte des 5 stacks
- Screenshot: `kubectl get pods -A`

**Slide 2: Microservices**
- Screenshot: Services en education namespace
- Architecture: 10 services

**Slide 3: Monitoring**
- Screenshot: Prometheus metrics
- Screenshot: Grafana dashboard
- Explication: 3 piliers observabilité

**Slide 4: Logging**
- Screenshot: Elasticsearch green
- Screenshot: Kibana logs
- Explication: Searchable centralized logs

**Slide 5: Infrastructure**
- Screenshot: RabbitMQ management
- Screenshot: Redis operational
- Explication: Message queue + cache

**Slide 6: GitOps**
- Screenshot: ArgoCD application
- Explication: Git → Auto deploy

**Slide 7: CI/CD**
- Screenshot: Jenkinsfile
- Diagramme: GitHub → Jenkins → DockerHub → ArgoCD

**Slide 8: Security & HA**
- Liste des features
- Explication pod security context

**Slide 9: Results**
- Summary: 14/15 operational
- Confiance: 93%

---

## 🖼️ ORGANISATION DES IMAGES

```
Screenshots/
├── 01_Infrastructure/
│   ├── 01_all_pods.png
│   ├── 02_education_ns.png
│   ├── 03_services.png
│   └── 04_deployments.png
├── 02_Monitoring/
│   ├── 01_prometheus_metrics.png
│   ├── 02_prometheus_targets.png
│   ├── 03_grafana_dashboard.png
│   └── 04_grafana_datasource.png
├── 03_Logging/
│   ├── 01_es_health.png
│   ├── 02_kibana_search.png
│   └── 03_log_results.png
├── 04_GitOps/
│   ├── 01_argocd_namespace.png
│   ├── 02_argocd_app.png
│   └── 03_app_status.png
└── 05_Code/
    ├── 01_jenkinsfile.png
    ├── 02_github_repos.png
    └── 03_dockerhub.png
```

---

## ⏱️ TIMING POUR SCREENSHOTS

Total: ~10-15 minutes

1. Infrastructure (2 min)
2. Monitoring (3 min)
3. Logging (2 min)
4. GitOps (2 min)
5. Code/Git (2 min)
6. Arrangement (3 min)

---

## 🎯 CONSEILS

1. **Ouverture/Fermeture des terminaux:** Alt+Tab pour switcher rapidement
2. **Refresh automatique:** `watch -n 1 kubectl get pods` (auto-refresh)
3. **Zoom:** Augmenter la taille du texte si présentation écran petit
4. **Timing:** Avoir des screenshots d'avance (moins dépendre de la démo live)
5. **Backup:** Sauvegarder les images localement (pas de dépendance internet)

---

**Prête? Commençons à prendre les screenshots! 📸**
