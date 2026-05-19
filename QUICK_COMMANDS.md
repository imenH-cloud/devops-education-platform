# 🚀 Quick Commands - DevOps Education v2.1 with ArgoCD

## 📌 Adresses Actuelles

```
ArgoCD Frontend:    https://localhost:31961/
Application Frontend: http://localhost:31927/
```

---

## 🔑 ArgoCD Essentials

### Login to ArgoCD
```bash
# CLI
argocd login localhost:31961 --insecure

# Get password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Manage Applications
```bash
# List apps
argocd app list

# Get app status
argocd app get devops-education

# Sync app
argocd app sync devops-education

# Delete app
argocd app delete devops-education --yes
```

### Watch Sync Progress
```bash
# Watch status
watch 'argocd app get devops-education'

# Wait for sync
argocd app wait devops-education --sync
```

---

## 🐳 Kubernetes Commands

### Check Deployment
```bash
# Pods status
kubectl get pods -n prod
kubectl get pods -n prod -o wide

# Services
kubectl get svc -n prod
kubectl get svc -A | grep NodePort

# Deployments
kubectl get deployments -n prod
kubectl get all -n prod
```

### View Logs
```bash
# Gateway logs
kubectl logs -n prod deployment/gateway-backend -f

# Specific pod
kubectl logs -n prod <pod-name>

# All pods in namespace
kubectl logs -n prod -l app=gateway --all-containers=true
```

### Port Forward
```bash
# API Gateway
kubectl port-forward svc/gateway 3000:3000 -n prod

# Database
kubectl port-forward svc/postgres 5432:5432 -n prod

# Redis
kubectl port-forward svc/redis 6379:6379 -n prod

# Multiple forwards
kubectl port-forward -n prod svc/gateway 3000:3000 svc/postgres 5432:5432
```

### Check Events
```bash
# Cluster events
kubectl get events -n prod --sort-by='.lastTimestamp'

# Pod events
kubectl describe pod <pod-name> -n prod
```

### Scale Services
```bash
# Scale deployment
kubectl scale deployment gateway-backend --replicas=3 -n prod

# Check replicas
kubectl get deployment -n prod
```

---

## 🧪 Testing

### Test API
```bash
# Health check
curl http://localhost:3000/health

# Get users (via port-forward)
curl http://localhost:3000/api/users

# With token
curl -H "Authorization: Bearer $TOKEN" http://localhost:3000/api/users
```

### Test Connectivity
```bash
# Database
psql -h localhost -U postgres -d education -c "SELECT 1"

# Redis
redis-cli -h localhost ping

# Elasticsearch
curl http://localhost:9200/_cluster/health | jq '.status'

# RabbitMQ
curl -u guest:guest http://localhost:15672/api/overview | jq '.object_totals.queues'
```

---

## 📊 Monitoring & Logging

### Grafana
```bash
# Access
http://localhost:30300

# Login
admin / admin

# Useful dashboards
- System Health
- API Performance
- Microservices Overview
```

### Kibana
```bash
# Access
http://localhost:30601

# Search logs
- Index: logs-*
- Search: {"query": {"match": {"level": "error"}}}
```

### Prometheus
```bash
# Access
http://localhost:30090

# Useful queries
- up{job="gateway"}
- http_requests_total
- http_request_duration_seconds
```

---

## 🔄 Continuous Deployment

### Auto-sync Setup
```bash
# Enable auto-sync
argocd app set devops-education --sync-policy automated

# Disable auto-sync
argocd app set devops-education --sync-policy manual

# Set sync options
argocd app set devops-education \
  --sync-option CreateNamespace=true \
  --sync-option PrunePropagationPolicy=foreground
```

### Manual Deployment
```bash
# Deploy directly with Helm
helm install devops-education ./helm/devops-education \
  --namespace prod \
  --values ./helm/devops-education/values-prod.yaml

# Update deployment
helm upgrade devops-education ./helm/devops-education \
  --namespace prod

# Uninstall
helm uninstall devops-education -n prod
```

---

## 🐛 Debugging

### Check Pod Status
```bash
# Pending pod
kubectl describe pod <pod-name> -n prod

# CrashLoopBackOff
kubectl logs -n prod <pod-name> --tail=50

# ImagePullBackOff
kubectl describe node
kubectl get events -n prod --sort-by='.lastTimestamp'
```

### Check Resources
```bash
# CPU and Memory
kubectl top nodes
kubectl top pods -n prod

# Resource requests
kubectl get pods -n prod -o custom-columns=NAME:.metadata.name,REQUESTS:.spec.containers[*].resources.requests
```

### Network Debugging
```bash
# DNS resolution
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
nslookup gateway-backend.prod.svc.cluster.local

# Connectivity test
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- \
  curl http://gateway-backend:3000/health
```

---

## 📝 Useful Aliases

Add to ~/.bashrc or ~/.zshrc:

```bash
# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias kctx='kubectl config current-context'

# ArgoCD
alias acd='argocd'
alias acdl='argocd app list'
alias acds='argocd app sync'
alias acdg='argocd app get'

# Helm
alias h='helm'
alias hi='helm install'
alias hu='helm upgrade'
alias hd='helm delete'
alias hl='helm list'
```

---

## 🚀 Common Workflows

### Deploy New Version
```bash
# 1. Update image in Helm values
# 2. Commit to Git
git add helm/devops-education/values-prod.yaml
git commit -m "Update image version"
git push

# 3. Sync ArgoCD (auto or manual)
argocd app sync devops-education --force

# 4. Check rollout
kubectl rollout status deployment/gateway-backend -n prod
```

### Troubleshoot Failed Deployment
```bash
# 1. Check pod status
kubectl get pods -n prod

# 2. Get pod logs
kubectl logs <pod-name> -n prod

# 3. Describe pod
kubectl describe pod <pod-name> -n prod

# 4. Check events
kubectl get events -n prod --sort-by='.lastTimestamp'

# 5. Check ArgoCD status
argocd app get devops-education
```

### Scale Application
```bash
# 1. Update Helm values
# values-prod.yaml: replicas: 3

# 2. Update deployment
helm upgrade devops-education ./helm/devops-education -n prod

# Or directly
kubectl scale deployment gateway-backend --replicas=3 -n prod

# 3. Verify
kubectl get deployment -n prod
```

### View Application Logs
```bash
# All services
kubectl logs -n prod -l app.kubernetes.io/instance=devops-education -f

# Specific service
kubectl logs -n prod deployment/gateway-backend -f

# Last 100 lines
kubectl logs -n prod deployment/gateway-backend --tail=100

# Export to file
kubectl logs -n prod deployment/gateway-backend > logs.txt
```

---

## 📋 Health Checks

```bash
# Full system health
echo "=== ArgoCD ===" && \
kubectl get pod -n argocd | grep -i running && \
echo "✅ ArgoCD Running"

echo "=== Application ===" && \
kubectl get pod -n prod | grep -i running && \
echo "✅ Application Running"

echo "=== Services ===" && \
kubectl get svc -n prod | grep -v NAME && \
echo "✅ Services Available"

echo "=== Frontend ===" && \
curl -s http://localhost:31927/ > /dev/null && \
echo "✅ Frontend Accessible"

echo "=== API Gateway ===" && \
curl -s http://localhost:3000/health > /dev/null && \
echo "✅ API Gateway Responding"
```

---

## 🔗 Quick Links

| Service | Access |
|---------|--------|
| ArgoCD | https://localhost:31961/ |
| Frontend | http://localhost:31927/ |
| API Docs | (via port-forward) http://localhost:3000/api/docs |
| Grafana | http://localhost:30300 |
| Kibana | http://localhost:30601 |
| Prometheus | http://localhost:30090 |

---

**Last Updated**: 2024-01-15  
**Status**: ✅ Ready to Use
