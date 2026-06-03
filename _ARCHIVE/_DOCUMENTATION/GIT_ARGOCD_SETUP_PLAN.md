# 📋 ORGANIZATION PLAN - Git + ArgoCD Setup

## 🎯 CURRENT STATE

❌ ArgoCD not installed  
❌ No GitOps workflow  
❌ Manual deployments  
❌ No Git structure for K8s manifests  

## ✅ WHAT WE'LL DO

### 1. Organize Git Repository Structure

```
devops-education-platform/  (current)
├── backend/
│   ├── activity/
│   ├── auth/
│   ├── user/
│   ├── ... (other services)
│   └── Dockerfiles
├── frontend/
├── kubernetes/              ← We'll keep this
│   ├── backend/
│   ├── frontend/
│   ├── database/
│   └── monitoring/
├── docker-compose.yml
└── Jenkinsfile

NEW STRUCTURE:
├── devops-education-platform/  (source code)
│   ├── backend/
│   ├── frontend/
│   ├── Dockerfile*
│   ├── docker-compose.yml
│   └── Jenkinsfile
│
└── devops-education-platform-gitops/  (NEW - Kubernetes only)
    ├── kubernetes/
    │   ├── base/                  (base manifests)
    │   │   ├── auth-service/
    │   │   ├── user-service/
    │   │   ├── activity-service/
    │   │   ├── ... (other services)
    │   │   ├── postgres/
    │   │   ├── redis/
    │   │   ├── elasticsearch/
    │   │   └── kustomization.yaml
    │   │
    │   ├── overlays/              (environment-specific)
    │   │   ├── development/
    │   │   ├── staging/
    │   │   └── production/
    │   │
    │   └── argocd/
    │       └── applications.yaml
    │
    ├── helm/                      (optional - for templating)
    ├── README.md
    └── DEPLOYMENT_GUIDE.md
```

## 📦 WHAT GOES WHERE

### Source Code Repo (devops-education-platform)
✅ Push:
- backend/ (source code)
- frontend/ (source code)
- Dockerfile (build config)
- docker-compose.yml
- Jenkinsfile
- .gitignore

❌ Don't push:
- kubernetes/ (keep locally for now)
- node_modules/
- dist/
- .env files
- secrets/

### GitOps Repo (devops-education-platform-gitops) - NEW
✅ Push:
- kubernetes/ (all manifests)
- helm/ (if using)
- argocd/ (configuration)
- README
- Deployment guides

❌ Don't push:
- Sensitive data
- Secrets (use SealedSecrets)

---

## 🚀 SETUP PLAN

### Step 1: Create GitOps Repository
```bash
# Create new repo on GitHub
# Name: devops-education-platform-gitops
# Description: Kubernetes manifests and ArgoCD configuration
```

### Step 2: Initialize GitOps Repo Structure
```bash
mkdir devops-education-platform-gitops
cd devops-education-platform-gitops

# Create directories
mkdir -p kubernetes/{base,overlays/{development,staging,production}}
mkdir -p helm
mkdir -p argocd

# Add initial files
echo "# GitOps Repository" > README.md
echo "# Deployment Guide" > DEPLOYMENT_GUIDE.md

# Git setup
git init
git add .
git commit -m "Initial commit - GitOps repository structure"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/devops-education-platform-gitops.git
git push -u origin main
```

### Step 3: Move Kubernetes Manifests
```bash
# Copy current K8s manifests to new repo
cp -r devops-education-platform/kubernetes/* \
   devops-education-platform-gitops/kubernetes/base/

# Reorganize by service
mkdir kubernetes/base/{auth-service,user-service,...}

# Push
cd devops-education-platform-gitops
git add .
git commit -m "Add Kubernetes manifests"
git push origin main
```

### Step 4: Install ArgoCD
```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Access: https://localhost:8080
```

### Step 5: Connect GitHub to ArgoCD
```bash
# Create personal access token on GitHub
# Settings → Developer settings → Personal access tokens
# Scopes: repo (full), admin:repo_hook

# Add GitHub repository to ArgoCD (via UI or CLI)
# Settings → Repositories → Connect using HTTPS
# URL: https://github.com/<USERNAME>/devops-education-platform-gitops.git
# Username: <your_github_username>
# Password: <personal_access_token>
```

### Step 6: Create ArgoCD Application
```yaml
# argocd/applications.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: horizons-tsa
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/<USERNAME>/devops-education-platform-gitops.git
    targetRevision: main
    path: kubernetes/base
  destination:
    server: https://kubernetes.default.svc
    namespace: education
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```

### Step 7: Deploy ArgoCD Application
```bash
kubectl apply -f argocd/applications.yaml
```

---

## 🔄 WORKFLOW (After Setup)

### When You Update Code (CI/CD):
```
1. Developer pushes to main repo
2. Jenkins builds & tests
3. Docker pushes to Docker Hub
4. Jenkins updates GitOps repo:
   - Changes image tag in Kubernetes manifests
   - Commits to devops-education-platform-gitops
   - Pushes to GitHub
```

### When GitOps Repo Changes:
```
1. GitHub webhook notifies ArgoCD
2. ArgoCD detects changes
3. ArgoCD automatically syncs
4. Kubernetes applies new manifests
5. Pods are updated
```

### Manual Deployment (if needed):
```bash
# Push to GitOps repo
git add .
git commit -m "Update service version"
git push origin main

# ArgoCD picks it up automatically
# Or manually sync in ArgoCD UI
```

---

## 📊 FOLDER STRUCTURE (Before Push)

### Keep Locally (Don't Push to Git):
```
devops-education-platform/
└── kubernetes/          ← Keep here, don't push to GitHub
    ├── backend/
    ├── frontend/
    ├── database/
    └── monitoring/
```

### Push to Source Code Repo:
```
devops-education-platform/  (push to GitHub)
├── backend/
├── frontend/
├── docker-compose.yml
├── Jenkinsfile
├── Dockerfile*
└── .gitignore
```

### Push to GitOps Repo (NEW):
```
devops-education-platform-gitops/  (push to GitHub)
├── kubernetes/
│   ├── base/
│   │   ├── auth-service/
│   │   ├── activity-service/
│   │   └── ... (all services)
│   └── overlays/
├── argocd/
│   └── applications.yaml
└── README.md
```

---

## ✅ CHECKLIST

- [ ] Create GitHub repository: `devops-education-platform-gitops`
- [ ] Clone locally
- [ ] Create folder structure
- [ ] Copy Kubernetes manifests from local
- [ ] Organize by service
- [ ] Create kustomization.yaml
- [ ] Push to GitHub
- [ ] Install ArgoCD in Kubernetes
- [ ] Connect GitHub to ArgoCD
- [ ] Create ArgoCD Application
- [ ] Test synchronization
- [ ] Verify pods update automatically

---

## 🎯 RESULT

✅ **Clean Git Repository Structure**
- Source code repo: Code only
- GitOps repo: K8s manifests only
- Clear separation of concerns

✅ **GitOps Workflow**
- ArgoCD watches GitHub
- Automatic syncing
- Git = source of truth
- Easy rollback (git revert)

✅ **CI/CD Integration**
- Jenkins builds code
- Pushes to Docker Hub
- Updates GitOps repo
- ArgoCD deploys automatically

✅ **Production Ready**
- Declarative infrastructure
- Version controlled
- Auditable changes
- Automated deployments
