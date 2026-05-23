# 🚀 QUICK START - Git + ArgoCD Setup (Step by Step)

## ⏱️ Time Required: 30-45 minutes

---

## STEP 1: Organize Your Git (5 minutes)

### What to Keep Where

**Source Code Repository (push to GitHub):**
```
devops-education-platform/
├── backend/
├── frontend/
├── docker-compose.yml
├── Jenkinsfile
├── Dockerfile*
└── .gitignore (use: .gitignore-source-repo)
```

**Don't push to source repo:**
```
❌ kubernetes/ (too large, keep locally)
❌ node_modules/
❌ dist/
❌ .env files
```

### Action:
```bash
# In your source code repo
# Add .gitignore content from: .gitignore-source-repo
# Then push
git add .
git commit -m "Clean up - exclude kubernetes and build artifacts"
git push origin main
```

---

## STEP 2: Create GitOps Repository (5 minutes)

### On GitHub:
```
1. Create new repository
   Name: devops-education-platform-gitops
   Description: Kubernetes manifests and ArgoCD configuration
   Public (recommended) or Private
   Initialize with README
```

### On Your Computer:
```bash
# Clone new repo
git clone https://github.com/imenH-cloud/devops-education-platform-gitops.git
cd devops-education-platform-gitops

# Create structure
mkdir -p kubernetes/{base,overlays/{development,staging,production}}
mkdir -p argocd
mkdir -p helm

# Create initial files
echo "# GitOps Repository for HORIZONS TSA" > README.md

git add .
git commit -m "Initial structure"
git push origin main
```

---

## STEP 3: Copy Kubernetes Manifests (5 minutes)

### Copy from your local to GitOps repo:
```bash
# Navigate to GitOps repo
cd devops-education-platform-gitops

# Copy manifests (from your dev machine)
# Copy from: D:\project\devopsPFE\kubernetes\backend\*
# To: kubernetes/base/

# Or manually recreate:
mkdir -p kubernetes/base/{auth-service,user-service,activity-service,...}

# Each service folder should contain:
# - deployment.yaml
# - service.yaml
```

### Commit:
```bash
git add kubernetes/
git commit -m "Add Kubernetes manifests"
git push origin main
```

---

## STEP 4: Setup Kustomization (3 minutes)

### Add kustomization.yaml:
```bash
# In: kubernetes/base/kustomization.yaml
# Copy content from: GIT_ARGOCD_SETUP_PLAN.md (kustomization.yaml section)

git add kubernetes/base/kustomization.yaml
git commit -m "Add Kustomization configuration"
git push origin main
```

---

## STEP 5: Install ArgoCD (10 minutes)

### Create namespace:
```bash
kubectl create namespace argocd
```

### Install ArgoCD:
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Wait for ArgoCD to be ready:
```bash
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
```

### Get admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# Copy this password
```

### Port forward to access UI:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Access: https://localhost:8080
# Username: admin
# Password: (from above)
```

---

## STEP 6: Connect GitHub to ArgoCD (5 minutes)

### Create GitHub Personal Access Token:

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Scopes:
   - ☑ repo (all)
   - ☑ admin:repo_hook
4. Generate and copy token

### Add Repository in ArgoCD:

**Option A: Via UI**
1. ArgoCD UI → Settings → Repositories
2. Click "Connect Repo"
3. URL: `https://github.com/imenH-cloud/devops-education-platform-gitops.git`
4. Username: `imenH-cloud`
5. Password: `<your_token>`
6. Click "Connect"

**Option B: Via Kubectl**
```bash
kubectl apply -f kubernetes/argocd/applications.yaml
```

---

## STEP 7: Create ArgoCD Application (3 minutes)

### Apply the Application manifest:
```bash
# File: kubernetes/argocd/applications.yaml
# Already prepared in the project

kubectl apply -f kubernetes/argocd/applications.yaml -n argocd
```

### Verify:
```bash
kubectl get application -n argocd
# Should show: horizons-tsa
```

---

## STEP 8: Verify Synchronization (5 minutes)

### Check ArgoCD UI:
1. Go to https://localhost:8080
2. Click on "horizons-tsa" application
3. Should show: "Synced" and "Healthy"

### Via kubectl:
```bash
# Check ArgoCD Application status
kubectl get application horizons-tsa -n argocd -o wide

# Check pods in education namespace
kubectl get pods -n education

# Should see all services running
```

---

## ✅ TESTING THE WORKFLOW

### Test 1: Make a change in GitOps repo
```bash
# In GitOps repo
cd devops-education-platform-gitops

# Edit any manifest
# Example: Change replica count in a deployment
nano kubernetes/base/activity-service/deployment.yaml
# Change replicas: 1 → replicas: 2

git add .
git commit -m "Increase activity-service replicas"
git push origin main

# ArgoCD should automatically:
# 1. Detect the change
# 2. Sync the manifest
# 3. Scale up the deployment

# Verify:
kubectl get pods -n education | grep activity
# Should see 2 pods now
```

### Test 2: Check ArgoCD dashboard
```bash
# After the change
# Go to https://localhost:8080
# Should see the status update automatically
# No manual intervention needed
```

---

## 🔄 WORKFLOW (Going Forward)

### When Code Changes:
```
1. Developer commits to: devops-education-platform
2. Jenkins pipeline:
   - Builds Docker images
   - Pushes to Docker Hub (tag: <build_number>)
   - Updates GitOps repo with new image tag
   - Commits + Pushes to devops-education-platform-gitops
```

### When GitOps Changes:
```
1. GitHub webhook → ArgoCD
2. ArgoCD detects changes
3. ArgoCD automatically syncs
4. Kubernetes applies new manifests
5. No manual kubectl apply needed!
```

---

## 📋 QUICK REFERENCE

### Access ArgoCD:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# https://localhost:8080
# admin / <password>
```

### View status:
```bash
kubectl get application -n argocd
kubectl get pods -n education
```

### Manual sync (if needed):
```bash
argocd app sync horizons-tsa
# Or in UI: Click "Sync" button
```

### Check logs:
```bash
kubectl logs -n argocd deployment/argocd-application-controller
```

---

## 🎯 FINAL RESULT

✅ **Git is organized**
- Source code repo: Code only
- GitOps repo: Kubernetes manifests only

✅ **ArgoCD is running**
- Watches GitHub GitOps repo
- Auto-syncs on changes
- Git = source of truth

✅ **Workflow is automated**
- Jenkins builds code
- Updates GitOps repo
- ArgoCD deploys automatically
- No manual kubectl apply!

---

## ⚠️ COMMON ISSUES

### "Application not synced"
```bash
# Check logs
kubectl logs -n argocd deployment/argocd-application-controller

# Manual sync
argocd app sync horizons-tsa
```

### "GitHub connection failed"
```bash
# Verify token
# Check if repository secret exists
kubectl get secret horizons-tsa-repo -n argocd

# Delete and recreate
kubectl delete secret horizons-tsa-repo -n argocd
# Re-add via UI
```

### "Pods not updating"
```bash
# Check if images are being pulled
kubectl describe pod <pod_name> -n education

# Ensure image tags exist on Docker Hub
docker pull eline2016/devopspfe-activity-service:latest
```

---

**Ready? Start with STEP 1!** ✅
