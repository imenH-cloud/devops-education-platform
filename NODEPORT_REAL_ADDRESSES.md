# 🌐 Configuration NodePort - Adresses Réelles

## ✅ Adresses Accessibles

### ArgoCD
```
https://localhost:31961/
```
**Credentials**: admin / (généré automatiquement)

```bash
# Récupérer le mot de passe ArgoCD
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Frontend (DevOps Education)
```
http://localhost:31927/
```

---

## 🔧 Mise à Jour Configuration

### 1. Mettre à jour les NodePorts

```bash
# Vérifier les services et NodePorts actuels
kubectl get svc -A -o wide | grep -E "argocd|frontend"

# Résultat attendu:
# argocd-server                31961  (ArgoCD)
# frontend-nodeport            31927  (Frontend)
```

### 2. Configurer ArgoCD pour DevOps Education

```bash
# Login ArgoCD
argocd login localhost:31961 --insecure

# Ajouter le repo Git
argocd repo add https://github.com/your-repo/devops-education \
  --username <github-user> \
  --password <github-token>

# Créer l'application
argocd app create devops-education \
  --repo https://github.com/your-repo/devops-education \
  --path helm/devops-education \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace prod \
  --values-literal-file helm/devops-education/values-prod.yaml

# Sync l'application
argocd app sync devops-education
```

### 3. Accéder aux Services

**ArgoCD Dashboard:**
```
https://localhost:31961/
```
- Username: admin
- Password: (voir commande ci-dessus)

**Frontend Application:**
```
http://localhost:31927/
```

**Backend API Gateway:**
```
http://localhost:3000/api/docs  (si port-forward)
```

---

## 📋 Tous les Services NodePort

```bash
# Lister tous les services NodePort
kubectl get svc -A | grep NodePort

# Format: <namespace> <name> <ports>
```

### Services Par Port

| Port | Service | URL |
|------|---------|-----|
| 31961 | ArgoCD | https://localhost:31961/ |
| 31927 | Frontend | http://localhost:31927/ |
| 30000 | Gateway | http://localhost:30000 |
| 30001 | Auth | http://localhost:30001 |
| 30002 | User | http://localhost:30002 |
| 30003 | Activity | http://localhost:30003 |
| 30004 | Parent | http://localhost:30004 |
| 30005 | Student | http://localhost:30005 |
| 30006 | Classroom | http://localhost:30006 |
| 30007 | Teacher | http://localhost:30007 |
| 30300 | Grafana | http://localhost:30300 |
| 30601 | Kibana | http://localhost:30601 |
| 30090 | Prometheus | http://localhost:30090 |
| 30900 | MinIO API | http://localhost:30900 |
| 30901 | MinIO Console | http://localhost:30901 |
| 30920 | Elasticsearch | http://localhost:30920 |
| 30432 | PostgreSQL | localhost:30432 |
| 30379 | Redis | localhost:30379 |
| 30672 | RabbitMQ | localhost:30672 |
| 30015 | RabbitMQ UI | http://localhost:30015 |

---

## 🎯 Déploiement avec ArgoCD

### Option 1: Via ArgoCD CLI

```bash
# 1. Créer namespace
kubectl create namespace prod

# 2. Login ArgoCD
argocd login localhost:31961 --insecure --username admin

# 3. Ajouter repo
argocd repo add https://github.com/your-repo/devops-education \
  --username <github-user> \
  --password <github-token>

# 4. Créer l'application
argocd app create devops-education \
  --repo https://github.com/your-repo/devops-education \
  --path helm/devops-education \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace prod

# 5. Sync
argocd app sync devops-education

# 6. Vérifier
argocd app get devops-education
```

### Option 2: Via ArgoCD UI

1. Ouvrir: `https://localhost:31961/`
2. Login avec admin / password
3. Cliquer "New App"
4. Configurer:
   - **Application Name**: devops-education
   - **Project**: default
   - **Repository URL**: https://github.com/your-repo/devops-education
   - **Path**: helm/devops-education
   - **Destination Cluster**: in-cluster
   - **Destination Namespace**: prod
5. Cliquer "Create"

### Option 3: Via Manifest YAML

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-education
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-repo/devops-education
    targetRevision: main
    path: helm/devops-education
    helm:
      values: |
        environment: production
  destination:
    server: https://kubernetes.default.svc
    namespace: prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```

---

## 🔍 Vérifier le Déploiement

```bash
# 1. Vérifier l'app ArgoCD
kubectl get application -n argocd
argocd app get devops-education

# 2. Vérifier les pods
kubectl get pods -n prod
kubectl get svc -n prod

# 3. Vérifier les logs
kubectl logs -n prod deployment/gateway-backend -f

# 4. Vérifier la santé
kubectl get po -n prod -o wide
kubectl describe pod <pod-name> -n prod
```

---

## 🚀 Accéder aux Applications

### Frontend
```
http://localhost:31927/
```
- Dashboard avec stats
- Dark mode toggle
- Notifications en temps réel

### API Documentation
```
# Via port-forward
kubectl port-forward svc/gateway 3000:3000 -n prod
http://localhost:3000/api/docs
```

### Monitoring
```
Grafana:      http://localhost:30300    (admin/admin)
Prometheus:   http://localhost:30090
Kibana:       http://localhost:30601
```

### Infrastructure
```
MinIO:        http://localhost:30901    (minioadmin/minioadmin)
RabbitMQ:     http://localhost:30015    (guest/guest)
Elasticsearch:http://localhost:30920
```

---

## 📊 Pipeline GitOps

```
Git Repo
   ↓
ArgoCD (https://localhost:31961/)
   ↓
Kubernetes Cluster
   ↓
Pods (kubectl get pods -n prod)
   ↓
Frontend (http://localhost:31927/)
   ↓
Users
```

---

## ✅ Checklist Déploiement

- [ ] ArgoCD accessible via https://localhost:31961/
- [ ] Credentials ArgoCD configurés
- [ ] Repo Git ajouté à ArgoCD
- [ ] Application créée dans ArgoCD
- [ ] Application synchronisée
- [ ] Pods en état Running
- [ ] Frontend accessible via http://localhost:31927/
- [ ] API Gateway répond (port-forward)
- [ ] Monitoring accessible (Grafana, Prometheus)
- [ ] Logs visibles (Kibana)

---

## 🔗 Liens Rapides

| Service | URL |
|---------|-----|
| ArgoCD | https://localhost:31961/ |
| Frontend | http://localhost:31927/ |
| Grafana | http://localhost:30300 |
| Kibana | http://localhost:30601 |
| Prometheus | http://localhost:30090 |
| MinIO | http://localhost:30901 |

---

## 📝 Notes

1. **Ports dynamiques**: Les NodePorts (31961, 31927, etc.) sont assignés dynamiquement
2. **HTTPS ArgoCD**: Self-signed certificate, accepter l'avertissement
3. **SSL/TLS**: En production, utiliser des certificats valides
4. **DNS**: En production, configurer DNS au lieu de localhost
5. **Firewall**: S'assurer que les ports sont ouverts

---

**Configuration**: ✅ Prête  
**ArgoCD**: ✅ Accessible  
**Frontend**: ✅ Accessible  
**Date**: 2024-01-15  
**Status**: Production Ready 🚀
