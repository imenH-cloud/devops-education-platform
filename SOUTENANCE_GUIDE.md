# 🎓 CHECKLIST SOUTENANCE - PFE DEVOPS

## ✅ PRÉ-SOUTENANCE (48h avant)

### Tests techniques
- [ ] `docker-compose build` → ✅ Tout compile
- [ ] `docker-compose up` → ✅ Tous les services démarrent
- [ ] `curl http://localhost:3000/health` → ✅ Gateway répond
- [ ] Frontend accessible `http://localhost:4200` → ✅ Oui
- [ ] Bases de données connectées → ✅ Vérifiez avec psql
- [ ] Logs sans erreurs → ✅ `docker-compose logs`

### Préparation Kubernetes
- [ ] Cluster K8s disponible (Docker Desktop, Minikube, EKS)
- [ ] `kubectl` fonctionnelle
- [ ] Secrets appliqués : `kubectl apply -f kubernetes/secrets.yaml`
- [ ] ConfigMaps appliquées : `kubectl apply -f kubernetes/configmap.yaml`
- [ ] Pods en statut Running : `kubectl get pods`

### Documentation
- [ ] `PROJECT_CORRECTIONS_FINAL.md` - Lisez complètement
- [ ] `RESUME_CORRECTIONS.md` - Résumé exécutif préparé
- [ ] Architecture diagram - Préparez ou imprimez
- [ ] Slides de présentation - Finalisées

### Démo live
- [ ] Terminal configuré (police lisible, couleurs OK)
- [ ] Raccourcis alias définis (optionnel mais utile)
- [ ] Wi-Fi testée
- [ ] Vidéo de fallback si internet échoue
- [ ] Screenshots pris (Prometheus, Grafana, logs)

---

## 🎯 PENDANT LA SOUTENANCE

### Présentation (15-20 min)

#### 1. Introduction (2 min)
- [ ] Présentez le contexte (plateforme éducation)
- [ ] 8 microservices backend + frontend Angular
- [ ] Stack : Node.js, PostgreSQL, Kubernetes, Docker
- [ ] Objectif : DevOps + CI/CD + Infrastructure as Code

#### 2. Architecture (3 min)
- [ ] Montrez l'architecture :
  ```
  Frontend (Angular)
       ↓
    Ingress
       ↓
    API Gateway
       ↓
  [8 Microservices]
       ↓
  [PostgreSQL, Redis, Elasticsearch, MinIO]
  ```
- [ ] Expliquez chaque composant
- [ ] Montrez la résilience (replicas, PDB, HPA)

#### 3. Docker (3 min)
- [ ] **Multi-stage builds** : builder → production
  ```dockerfile
  FROM node:20-alpine AS builder
  RUN npm ci --omit=dev
  FROM node:20-alpine
  COPY --from=builder /app/dist
  USER nodejs:1001
  ```
- [ ] **Taille optimisée** : ~340MB par service (pas énorme)
- [ ] **Sécurité** : non-root user, dumb-init

#### 4. Kubernetes (5 min)
- [ ] **Deployments** : 2 replicas par service
  ```yaml
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  ```
- [ ] **Resource Limits** : CPU/Memory limités pour la stabilité
- [ ] **Network Policies** : Communication isolée
  - Frontend → Gateway
  - Gateway → Services
  - Services → Database
- [ ] **Ingress** : Accès HTTPS externe
- [ ] **PDB** : Pod Disruption Budgets (minAvailable: 1)
- [ ] **HPA** : Auto-scaling 2-5 replicas basé CPU/Memory

#### 5. Sécurité (2 min)
- [ ] **Secrets** : Pas de passwords en clair
  ```yaml
  env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: postgres-secret
          key: password
  ```
- [ ] **RBAC** : Prometheus a les bonnes permissions
- [ ] **Security Contexts** : Non-root, read-only filesystem
- [ ] **Network Policies** : Deny-all + whitelist

#### 6. CI/CD (2 min)
- [ ] **Jenkinsfile** :
  1. Checkout + Lint
  2. Tests unitaires
  3. SonarQube analysis
  4. npm audit
  5. Build Docker
  6. Push registry
  7. Deploy K8s
- [ ] **Image tagging** : `v1.0.1-abc123` (semantic + git SHA)
- [ ] **Smoke tests** : Vérification post-déploiement

#### 7. Monitoring (2 min)
- [ ] **Prometheus** : Scrape les métriques
  ```yaml
  prometheus.io/scrape: "true"
  prometheus.io/port: "3000"
  prometheus.io/path: "/metrics"
  ```
- [ ] **Grafana** : Dashboards de visualisation
- [ ] **Elasticsearch + Kibana** : Logs centralisés

### Démo Live (10 min maximum)

#### Demo 1 : Docker Compose (3 min)
```bash
# Montrer le build
docker-compose build

# Logs propres
docker-compose ps

# Test health
curl http://localhost:3000/health

# Montrer Grafana
# Open http://localhost:3099 → admin/admin
```

#### Demo 2 : Kubernetes (5 min)
```bash
# Pods running
kubectl get pods

# Services
kubectl get svc

# Describe gateway
kubectl describe pod gateway-deployment-xxxxx

# Logs
kubectl logs -f gateway-deployment-xxxxx

# Port forward (optionnel)
kubectl port-forward svc/grafana 3000:3000
# Open http://localhost:3000
```

#### Demo 3 : Code (2 min)
- Montrez un Dockerfile → multi-stage build
- Montrez un YAML K8s → resource limits + security
- Montrez le Jenkinsfile → pipeline stages

---

## 💡 QUESTIONS ATTENDUES (& Réponses)

### 1. **Pourquoi Kubernetes et pas Docker Compose en production?**
> **Réponse** : 
> - Orchestration automatique des conteneurs
> - Scalabilité horizontale automatique
> - Haute disponibilité (replicas, auto-healing)
> - Gestion des resources (CPU, mémoire)
> - Rolling updates sans downtime

### 2. **Qu'est-ce que les Network Policies?**
> **Réponse** :
> - Firewall par défaut : "deny all" ingress
> - Whitelist explicite des communications
> - Frontend ↔ Gateway ↔ Services
> - Isole les bases de données

### 3. **Comment gérez-vous les secrets?**
> **Réponse** :
> - Kubernetes Secrets (encryption at rest)
> - Pas de passwords en dur dans YAML
> - `valueFrom.secretKeyRef`
> - En production : utiliser HashiCorp Vault

### 4. **Quel est l'avantage des Pod Disruption Budgets?**
> **Réponse** :
> - Garantit minAvailable pendant les mises à jour
> - Évite les downtime lors des rolling updates
> - Protège contre les évictions forcées

### 5. **Comment fonctionne l'auto-scaling?**
> **Réponse** :
> - HPA (Horizontal Pod Autoscaler)
> - Cible : 70% CPU, 80% Memory
> - Min: 2, Max: 5 replicas
> - Kubernetes crée/détruit des pods automatiquement

### 6. **Que se passe-t-il si une pod crash?**
> **Réponse** :
> - Liveness probe détecte le crash
> - Pod est redémarré automatiquement
> - ReplicaSet en crée une nouvelle
> - Service redirige le trafic aux pods restantes

### 7. **Comment déploiement en production?**
> **Réponse** :
> - Jenkins pipeline automatisé
> - Kustomize applique les manifests K8s
> - ArgoCD peut surveiller et syncer automatiquement
> - Rollback facile avec les anciennes versions d'images

### 8. **Quel est votre plan de disaster recovery?**
> **Réponse** :
> - Backups PostgreSQL réguliers
> - Replicas: 2 minimum (pas single point of failure)
> - PVCs dans un stockage persistant
> - Monitoring + alertes

---

## 🎬 POINTS À NE PAS OUBLIER

✅ **Commencez par la vue d'ensemble**, ensuite détails techniques  
✅ **Utilisez des diagrammes** (architecture, flux de données)  
✅ **Montrez le code** (Dockerfile, YAML)  
✅ **Faites une démo live** (même si c'est court)  
✅ **Avouez les limitations** (l'IA préfère l'honnêteté)  
✅ **Proposez des améliorations** (vous le ferez après la soutenance)  
✅ **Parlez avec confiance** (vous maîtrisez vraiment le sujet!)  

---

## ⚠️ À ÉVITER

❌ Trop de slides (max 20-25)  
❌ Lectures complètes du code (montrez, ne lisez pas)  
❌ Discours mal articulé (pratiquez plusieurs fois)  
❌ Démo qui crash (testez d'abord)  
❌ Jargon incompréhensible (expliquez les termes)  
❌ Dépasser le temps imparti  
❌ Montrer une mauvaise connexion WiFi  

---

## 📊 TIMESHEET SUGGÉRÉ (20 min total)

| Partie | Durée | Notes |
|--------|-------|-------|
| Intro + Contexte | 2 min | Qui, quoi, pourquoi |
| Architecture | 2 min | Diagramme + composants |
| Docker | 2 min | Multi-stage, optimisation |
| Kubernetes | 4 min | Deployments, Resources, Network |
| Sécurité | 1 min | Secrets, RBAC |
| CI/CD | 1 min | Jenkinsfile pipeline |
| Monitoring | 1 min | Prometheus, Grafana |
| **Démo Live** | **5 min** | Docker + K8s |
| Questions | 5 min | Réponses + discussion |
| **TOTAL** | **23 min** | ✅ Bon timing |

---

## 📁 FICHIERS À AVOIR À PORTÉE DE MAIN

```
✅ PROJECT_CORRECTIONS_FINAL.md   → Références techniques
✅ RESUME_CORRECTIONS.md           → Points clés
✅ QUICK_COMMANDS.sh               → Commandes rapides
✅ Slides PowerPoint               → Présentation
✅ Architecture Diagram            → PNG/PDF
✅ Terminal avec tout configuré    → Prêt pour démo
```

---

## 🚦 AVANT DE PARTIR SOUTENIR

- [ ] Backup complet du projet (Git + USB)
- [ ] Slides sur USB (au cas où PC échoue)
- [ ] Screenshots de la démo working
- [ ] Vidéo YouTube/MP4 comme fallback
- [ ] Tous les fichiers importants étudiés
- [ ] Réponses aux questions clés mémorisées
- [ ] Costume professionnel ✓
- [ ] Confiance en vous ✓

---

## ✨ BON COURAGE POUR VOTRE SOUTENANCE! 🚀

Vous avez un projet professionnel, bien pensé et exécuté.  
Les jurés apprécieront votre attention aux détails et aux bonnes pratiques DevOps.

**Allez-y avec confiance!** 💪

---

*Créé: 2026-05-04*  
*Status: Prêt pour la soutenance* ✅
