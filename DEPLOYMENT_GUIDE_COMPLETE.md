# 🚀 Guide de Déploiement Complet - DevOps Education v2.1

## ✅ Prérequis Vérifiés

```
✅ kubectl: v1.34.1
✅ Cluster: Docker Desktop (Kubernetes running)
✅ Namespaces: argocd, education, kube-system...
✅ ArgoCD: Déjà installé (argocd namespace actif)
```

---

## 📋 Étapes de Déploiement

### Étape 1: Vérifier ArgoCD

```bash
# Vérifier si ArgoCD est en cours d'exécution
kubectl get pods -n argocd

# Vérifier le service ArgoCD
kubectl get svc -n argocd

# Obtenir le mot de passe ArgoCD
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Étape 2: Préparer le Repository Git

Vous avez besoin de:
- **Repository Git** contenant votre code (public ou private)
- **Git credentials** (si repository privé)
- **Chemin Helm** dans le repo: `helm/devops-education/`

Exemple de structure Git:
```
your-repo/
├── backend/
├── frontend/
├── helm/
│   └── devops-education/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-prod.yaml
│       └── templates/
└── docker-compose.yml
```

### Étape 3: Créer le Namespace

```bash
# Créer namespace prod
kubectl create namespace prod

# Vérifier
kubectl get ns | grep prod
```

### Étape 4: Créer l'Application ArgoCD

**Option A: Via CLI (Recommandé)**

```bash
# 1. Login to ArgoCD
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
argocd login localhost:31961 --insecure --username admin --password "$ARGOCD_PASSWORD"

# 2. Ajouter le repository Git
argocd repo add https://github.com/YOUR_USERNAME/YOUR_REPO \
  --username YOUR_GITHUB_USER \
  --password YOUR_GITHUB_TOKEN

# 3. Créer l'application
argocd app create devops-education \
  --repo https://github.com/YOUR_USERNAME/YOUR_REPO \
  --path helm/devops-education \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace prod \
  --auto-prune \
  --self-heal \
  --sync-policy automated

# 4. Attendre que l'app soit créée
kubectl wait --for=condition=processed \
  application/devops-education \
  -n argocd \
  --timeout=30s

# 5. Vérifier l'application
argocd app get devops-education
```

**Option B: Via Interface ArgoCD**

1. Ouvrir: `https://localhost:31961/`
2. Login: `admin` / `PASSWORD_FROM_ABOVE`
3. Cliquer **"+ NEW APP"**
4. Remplir:
   - **Application Name**: `devops-education`
   - **Project**: `default`
   - **Repository URL**: `https://github.com/YOUR_USERNAME/YOUR_REPO`
   - **Path**: `helm/devops-education`
   - **Destination Cluster**: `in-cluster`
   - **Destination Namespace**: `prod`
5. Cliquer **"Create"**

### Étape 5: Synchroniser l'Application

```bash
# Sync automatiquement
argocd app sync devops-education

# Ou via interface: ArgoCD UI → devops-education → SYNC button

# Attendre la sync
argocd app wait devops-education --sync
kubectl wait --for=condition=Synced \
  application/devops-education \
  -n argocd \
  --timeout=300s
```

### Étape 6: Vérifier le Déploiement

```bash
# Status de l'application
argocd app get devops-education

# Pods running
kubectl get pods -n prod

# Services
kubectl get svc -n prod

# Tous les objets
kubectl get all -n prod

# Events
kubectl get events -n prod --sort-by='.lastTimestamp'
```

---

## 🔍 Vérification Détaillée

### Vérifier les Pods

```bash
# Attendre que les pods soient prêts
kubectl wait --for=condition=Ready \
  pod -l app.kubernetes.io/instance=devops-education \
  -n prod \
  --timeout=600s

# Vérifier tous les pods
kubectl get pods -n prod -o wide

# Logs d'un pod
kubectl logs -n prod deployment/gateway-backend
```

### Vérifier les Services NodePort

```bash
# Lister les services
kubectl get svc -n prod

# Vérifier les ports
kubectl get svc -n prod -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.ports[0].nodePort}{"\n"}{end}'

# Test de connectivité
curl http://localhost:30000/health  # Gateway
curl http://localhost:31927/         # Frontend
```

### Vérifier les Volumes

```bash
# Vérifier les PVC
kubectl get pvc -n prod

# Vérifier les PV
kubectl get pv

# Détails
kubectl describe pvc -n prod
```

---

## 🧪 Tests Post-Déploiement

### Test 1: Frontend

```bash
# Vérifier que le frontend est accessible
curl -I http://localhost:31927/

# Ouvrir dans le navigateur
open http://localhost:31927/
```

### Test 2: API Gateway

```bash
# Health check
curl http://localhost:30000/health

# Via port-forward
kubectl port-forward svc/gateway 3000:3000 -n prod &
curl http://localhost:3000/api/docs
```

### Test 3: Database

```bash
# Vérifier PostgreSQL
kubectl port-forward svc/postgres 5432:5432 -n prod &
psql -h localhost -U postgres -d education -c "SELECT COUNT(*) FROM users;"
```

### Test 4: Monitoring

```bash
# Grafana
open http://localhost:30300
# Login: admin/admin

# Prometheus
open http://localhost:30090

# Kibana
open http://localhost:30601
```

---

## 🐛 Troubleshooting

### Si les Pods ne démarrent pas

```bash
# Vérifier les erreurs
kubectl describe pod <pod-name> -n prod

# Vérifier les images
kubectl get pods -n prod -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].image}{"\n"}{end}'

# Logs d'erreur
kubectl logs <pod-name> -n prod --tail=100
```

### Si ArgoCD montre "OutOfSync"

```bash
# Forcer la sync
argocd app sync devops-education --force

# Ou via interface: ArgoCD → devops-education → REFRESH & SYNC
```

### Si un service ne répond pas

```bash
# Vérifier le service
kubectl describe svc <service-name> -n prod

# Vérifier les endpoints
kubectl get endpoints -n prod

# Test de connectivité entre pods
kubectl run -it --rm debug --image=busybox --restart=Never -- \
  wget -O- http://gateway-backend:3000/health
```

### Si la base de données ne démarre pas

```bash
# Vérifier le PVC
kubectl get pvc -n prod

# Vérifier le PV
kubectl get pv

# Logs PostgreSQL
kubectl logs -n prod statefulset/postgres --tail=50

# Détails du pod
kubectl describe pod -n prod -l app=postgres
```

---

## 📊 Commandes Utiles

```bash
# Watch pods en temps réel
kubectl get pods -n prod -w

# Watch services
kubectl get svc -n prod -w

# Top CPU/Memory
kubectl top pods -n prod
kubectl top nodes

# Describe tout
kubectl describe all -n prod

# Get events
kubectl get events -n prod --sort-by='.lastTimestamp'

# Check resource status
kubectl get all -n prod --show-labels

# View logs streaming
kubectl logs -n prod deployment/gateway-backend -f
```

---

## ✅ Checklist Finale

- [ ] ArgoCD accessible: https://localhost:31961/
- [ ] Namespace prod créé
- [ ] Repository Git configuré
- [ ] Application ArgoCD créée
- [ ] Application synchronisée
- [ ] Tous les pods en Running
- [ ] Tous les services créés
- [ ] Frontend accessible: http://localhost:31927/
- [ ] API Gateway répond: http://localhost:30000/health
- [ ] Grafana accessible: http://localhost:30300
- [ ] Kibana accessible: http://localhost:30601
- [ ] PostgreSQL répond
- [ ] Tests passent

---

## 📝 Prochaines Étapes

1. **Configurer CI/CD** - Webhook Git → ArgoCD
2. **Ajouter monitoring** - Prometheus + Grafana dashboards
3. **Configurer logging** - Elasticsearch + Kibana
4. **Sécurité** - Network Policies + RBAC
5. **Backups** - PostgreSQL + volumes

---

**Status**: 🚀 **Prêt pour le déploiement**

Vous avez des questions ou besoin d'aide pour une étape spécifique?
