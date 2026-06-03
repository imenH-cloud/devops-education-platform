# GitOps Migration Guide - ISSUE RESOLUTION

**Status:** 🔴 CRITICAL - ArgoCD Namespace Terminating  
**Action Required:** Before technical defense

---

## PROBLEM ANALYSIS

### Current State

```
ArgoCD Namespace: Terminating (stuck for 8 days)
ArgoCD Resources: No pods/services found
Application (education-platform): Shows as "Unknown" sync status but "Healthy"
```

### Root Causes

1. **Finalizers not cleaning up** - Stuck in termination
2. **CRDs with finalizers not deleted** - Applications/AppSets hanging
3. **PVC/PV not releasing** - Storage holding namespace open (if used)

---

## IMMEDIATE FIX (5 minutes)

### Step 1: Force Delete Namespace

```powershell
# Check what's preventing deletion
kubectl get all -n argocd
kubectl api-resources --namespaced=true | grep argocd

# Force namespace deletion
kubectl delete namespace argocd --grace-period=0 --force

# Verify deletion
kubectl get namespace argocd
```

### Step 2: Clean Up Stray Resources

```powershell
# Remove any finalizers on applications
kubectl patch application.argoproj.io -p '{"metadata":{"finalizers":[]}}' --all -n argocd

# Remove any stuck resources
kubectl delete applicationset.argoproj.io --all -n argocd
```

### Step 3: Reinstall ArgoCD

```powershell
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for deployment
Start-Sleep -Seconds 30
kubectl get pods -n argocd

# Port forward for access
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

**Access:** https://localhost:8080  
**Default credentials:** admin / (check with `kubectl get secret`)

### Step 4: Recreate Application

```bash
kubectl apply -f D:\project\devopsPFE\kubernetes\argocd\applications.yaml
```

---

## VALIDATION CHECKLIST

```
✅ argocd namespace is Active (not Terminating)
✅ argocd-server pod running
✅ argocd-application-controller running
✅ Application resource created
✅ Application showing "Synced" status
✅ Can access UI at https://localhost:8080
✅ Sync policy working (auto-deploy on Git push)
```

---

## GITOPS WORKFLOW FOR DEFENSE

### How it Works (Explain to Panel)

```
1. Developer pushes code to GitHub
   └─ Triggers Jenkins pipeline

2. Jenkins builds Docker images
   └─ Scans with Trivy
   └─ Pushes to Docker Hub

3. Jenkins updates GitOps repository
   └─ Modifies kubernetes/backend/service.yaml
   └─ Changes image tag to new version
   └─ Commits and pushes to GitHub

4. ArgoCD detects Git change
   └─ Pulls latest manifests
   └─ Compares desired vs current state
   └─ Applies differences to cluster

5. Kubernetes updates services
   └─ Rolling update (new pods created)
   └─ Old pods gradually terminated
   └─ Zero downtime
```

### Demo Flow (For Technical Defense)

```bash
# 1. Show GitOps repository structure
cd D:\project\devopsPFE-main
Get-ChildItem -Recurse -Filter "*.yaml"

# 2. Show ArgoCD application status
kubectl get application -n argocd

# 3. Show that manifests match Git
kubectl get deployment -n education -o yaml | grep image:

# 4. (Optional) Trigger a manual sync
argocd app sync education-platform --auth-token=$TOKEN

# 5. Show real-time sync happening
kubectl get pods -w -n education
```

---

## NEW GITOPS REPOSITORY SETUP

### Two Repository Approach

You now have two repositories:

**Repository 1: Source Code (CI)**
- **URL:** https://github.com/imenH-cloud/devops-education-platform.git
- **Purpose:** Application code (backend, frontend)
- **Branch:** main
- **Workflow:** Code → Commit → Push → Webhook → Jenkins

**Repository 2: GitOps (CD)**
- **URL:** https://github.com/imenH-cloud/devopsPFE-main.git
- **Purpose:** Kubernetes manifests (infrastructure)
- **Branch:** main
- **Workflow:** Jenkins updates images → Commit → Push → ArgoCD syncs

### Why Two Repos?

```
✅ Separation of concerns (code vs infrastructure)
✅ Different teams can manage manifests
✅ Different access control (developers vs DevOps)
✅ Infrastructure versioning independent of code
✅ Easy to manage multiple environments (dev/staging/prod)
```

### Jenkinsfile Integration

**Current Jenkinsfile (in devopsPFE) does:**

```
1. Checkout application repository ✓
2. Build Docker images ✓
3. Push to Docker Hub ✓
4. Clone GitOps repository ✓
5. Update image tags in manifests ✓
6. Commit and push GitOps repository ✓
7. (ArgoCD automatically syncs)
```

**Verification:**

```powershell
# Check Jenkinsfile exists
Get-Item "D:\project\devopsPFE\Jenkinsfile"

# Copy to GitOps repository
Copy-Item "D:\project\devopsPFE\Jenkinsfile" "D:\project\devopsPFE-main\Jenkinsfile" -Force

# Commit to GitOps repository
cd "D:\project\devopsPFE-main"
git add Jenkinsfile
git commit -m "Add CI/CD pipeline definition"
git push origin main
```

---

## MONITORING THE GITOPS WORKFLOW

### Check Git Status

```bash
# Current commit
git log --oneline -5

# Branch status
git branch -v

# Uncommitted changes
git status
```

### Check ArgoCD Status

```bash
# Application status
kubectl get application -n argocd
kubectl describe application education-platform -n argocd

# Sync history
kubectl get application education-platform -n argocd -o json | jq '.status.operationState'

# Last sync time
kubectl get application education-platform -n argocd -o jsonpath='{.status.operationState.finishedAt}'
```

### Check Kubernetes Resources

```bash
# Get deployed images
kubectl get deployment -A -o jsonpath='{..image}' | tr -s '[[:space:]]' '\n'

# Check rollout status
kubectl rollout status deployment -n education

# View recent events
kubectl get events -n education --sort-by='.lastTimestamp'
```

---

## TROUBLESHOOTING GITOPS

### Issue: Application shows "OutOfSync"

**Cause:** Git state ≠ Cluster state

**Fix:**
```bash
# Manual sync
kubectl patch application education-platform -n argocd --type merge -p '{"metadata":{"labels":{"force-sync":"true"}}}'

# Or via ArgoCD UI
# Right-click app → Sync
```

### Issue: Sync fails silently

**Cause:** Missing namespace, invalid manifests, or RBAC issues

**Debug:**
```bash
# Check ArgoCD controller logs
kubectl logs -n argocd argocd-application-controller-0 --tail=50

# Check syntax of manifests
kubectl apply -f D:\project\devopsPFE\kubernetes --dry-run=client

# Check RBAC
kubectl auth can-i create deployments -n education --as system:serviceaccount:argocd:argocd-application-controller
```

### Issue: Image tags not updating

**Cause:** Jenkinsfile not properly updating GitOps repo

**Debug:**
```bash
# Check if GitOps repo was cloned correctly
cd D:\project\devopsPFE-main
git log --oneline -5

# Verify image tags in manifests
Get-Content kubernetes/backend/activity-service.yaml | Select-String "image:"

# Re-run Jenkins build with PUSH_DOCKER=true
```

---

## SECURITY CONSIDERATIONS FOR GITOPS

### 1. Repository Access

```yaml
ArgoCD Repository Secret (kubernetes/argocd/applications.yaml):
  - URL: https://github.com/...
  - Username: imenH-cloud
  - Password: GitHub token (NOT plain password!)
  - Secure: Always use tokens, never passwords
```

**Best Practice:**
```bash
# Use GitHub personal access token with minimal scope
# Grant: repo:read (read repositories)
# Do NOT grant: admin, delete
```

### 2. Kubernetes RBAC

```yaml
ArgoCD Service Account:
  - Namespace: argocd
  - ClusterRole: argocd-application-controller
  - Can: create/update/delete resources in target namespaces
  - Cannot: modify ArgoCD itself
```

### 3. Image Registry Security

```yaml
Docker Hub Credentials (Jenkins):
  - Stored in Jenkins secrets
  - Encrypted at rest
  - Rotated regularly
  - Use service account (not personal account)
```

---

## PRESENTATION SCRIPT FOR GITOPS

**Opening (1 minute):**
> "Our infrastructure uses GitOps, meaning our entire Kubernetes cluster state is defined in Git. This gives us version control, audit trails, and automatic deployments."

**Architecture (2 minutes):**
> "Here's the flow: 
> 1. Developer pushes code to GitHub
> 2. Jenkins builds and tests the application
> 3. Jenkins creates Docker images and pushes them to Docker Hub
> 4. Jenkins updates our GitOps repository with the new image tags
> 5. ArgoCD sees the change in Git and automatically deploys to Kubernetes
> 6. The application is now running with zero manual intervention"

**Benefits (1 minute):**
> "Benefits: Automatic deployments mean faster releases. Git history means we can see who changed what and when. If something breaks, we can rollback with one Git revert. And our entire infrastructure is version-controlled, just like code."

**Demo (3-5 minutes):**
> "Let me show you the actual repositories and how everything is connected..."
> [Show GitHub repos, ArgoCD UI, and Kubernetes resources]

---

## NEXT STEPS BEFORE DEFENSE

### Checklist

- [ ] Force delete ArgoCD namespace
- [ ] Reinstall ArgoCD
- [ ] Verify application sync status is "Synced"
- [ ] Test port-forward to ArgoCD UI
- [ ] Prepare GitHub repository URLs
- [ ] Write demo script (what to click/show)
- [ ] Practice explanation with non-technical person
- [ ] Document credentials in secure location
- [ ] Test Jenkins trigger (manual push to GitHub)
- [ ] Verify images updated in Kubernetes after Jenkins run

### Timeline

- **Now:** Fix ArgoCD
- **Tomorrow:** Practice defense presentation
- **Day of defense:** Final verification + demo

---

## REFERENCE: ArgoCD Application Manifest

Your current application definition (for defense explanation):

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: education-platform
  namespace: argocd
spec:
  project: default
  
  # Source: GitHub repository with Kubernetes manifests
  source:
    repoURL: https://github.com/imenH-cloud/devops-education-platform-gitops.git
    targetRevision: main
    path: kubernetes/base
    
    # Kustomize for manifest templating
    kustomize:
      version: v4.5.7
  
  # Destination: Local Kubernetes cluster, education namespace
  destination:
    server: https://kubernetes.default.svc
    namespace: education
  
  # Sync Policy: Automatic with pruning
  syncPolicy:
    automated:
      prune: true           # Delete resources not in Git
      selfHeal: true        # Auto-sync when cluster drifts
    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
    
    # Retry failed syncs
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

---

**Status:** Ready to Fix  
**Estimated Fix Time:** 5 minutes  
**Estimated Testing:** 10 minutes  
**Total Prep Time:** 15 minutes
