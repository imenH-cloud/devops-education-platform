# ArgoCD Configuration - Education Platform

## Structure

```
argocd/
├── projects/               # AppProject definitions
│   └── education-project.yaml
├── applications/           # Application definitions
│   ├── frontend-app.yaml
│   ├── activity-service.yaml
│   ├── teacher-service.yaml
│   └── gateway-backend.yaml
└── configs/               # ArgoCD config (future)
```

## Installation

### 1. Create ArgoCD Project
```bash
kubectl apply -f argocd/projects/education-project.yaml
```

### 2. Register Applications
```bash
kubectl apply -f argocd/applications/
```

### 3. Verify
```bash
argocd app list
argocd app get frontend-app
```

## Sync Policies

- **Automated**: Applications auto-sync on changes
- **Prune**: Removes resources not in Git
- **SelfHeal**: Replaces drifted resources

## Repository Structure Expected

```
GitHub:
├── frontend/kubernetes/          # Frontend manifests
├── backend/activity/kubernetes/  # Activity service manifests
├── backend/teacher/kubernetes/   # Teacher service manifests
└── backend/gateway/kubernetes/   # Gateway manifests
```

## Images on Docker Hub

```
imen2016/horizons-frontend:v1
imen2016/devopspfe-activity-service:v1
imen2016/devopspfe-teacher-service:v1
imen2016/devopspfe-gateway-backend:v1
```

## Disable/Enable AutoSync

```bash
# Disable
argocd app set frontend-app --sync-policy none

# Enable
argocd app set frontend-app --sync-policy automated --auto-prune --self-heal
```

## For Soutenance

- ArgoCD is disabled by default to prevent rollbacks
- Manual sync via: `argocd app sync frontend-app`
- All services deployed to namespace: `education`
- Monitoring in namespace: `monitoring`
