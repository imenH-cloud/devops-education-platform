# REDÉPLOIEMENT COMPLET APRÈS RESTART DOCKER DESKTOP (PowerShell)
# Usage: .\REDEPLOY_AFTER_RESTART.ps1

$ErrorActionPreference = "Continue"

Write-Host "🚀 REDÉPLOIEMENT APRÈS RESTART DOCKER DESKTOP" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# ÉTAPE 1: Vérifier Docker
Write-Host "✓ Étape 1: Vérifier Docker..." -ForegroundColor Cyan
try {
    docker info > $null 2>&1
    Write-Host "✓ Docker est actif" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker non disponible" -ForegroundColor Red
    exit 1
}
Write-Host ""

# ÉTAPE 2: Charger les images Docker
Write-Host "✓ Étape 2: Charger les images Docker..." -ForegroundColor Cyan
Write-Host "  - activity-service:v10"
docker pull eline2016/devopspfe-activity-service:v10 2>&1 | Out-Null
Write-Host "  - gateway-backend:v8"
docker pull eline2016/devopspfe-gateway-backend:v8 2>&1 | Out-Null
Write-Host "✓ Images chargées" -ForegroundColor Green
Write-Host ""

# ÉTAPE 3: Vérifier Kubernetes
Write-Host "✓ Étape 3: Vérifier Kubernetes..." -ForegroundColor Cyan
try {
    kubectl cluster-info > $null 2>&1
    Write-Host "✓ Kubernetes est actif" -ForegroundColor Green
} catch {
    Write-Host "❌ Kubernetes non disponible" -ForegroundColor Red
    exit 1
}
Write-Host ""

# ÉTAPE 4: Créer namespace
Write-Host "✓ Étape 4: Créer namespace..." -ForegroundColor Cyan
kubectl create namespace education --dry-run=client -o yaml | kubectl apply -f - 2>&1 | Out-Null
Write-Host "✓ Namespace créé/existant" -ForegroundColor Green
Write-Host ""

# ÉTAPE 5: Créer Secrets
Write-Host "✓ Étape 5: Créer Secrets..." -ForegroundColor Cyan
kubectl create secret generic postgres-secret `
  --from-literal=username=education `
  --from-literal=password=education123 `
  -n education `
  --dry-run=client -o yaml | kubectl apply -f - 2>&1 | Out-Null

kubectl create secret generic jwt-secret `
  --from-literal=jwt-secret=your-jwt-secret-key-here `
  -n education `
  --dry-run=client -o yaml | kubectl apply -f - 2>&1 | Out-Null
Write-Host "✓ Secrets créés" -ForegroundColor Green
Write-Host ""

# ÉTAPE 6: Restaurer la DB depuis backup
Write-Host "✓ Étape 6: Restaurer la base de données..." -ForegroundColor Cyan
if (Test-Path "backup_database.sql") {
    Write-Host "  ⚙ Attente du pod PostgreSQL..."
    kubectl rollout status statefulset/postgres -n education --timeout=5m 2>&1 | Out-Null
    
    Write-Host "  ⚙ Restauration de la DB..."
    Get-Content backup_database.sql | kubectl exec -i postgres-0 -n education -- psql -U education -d education_db 2>&1 | Out-Null
    Write-Host "✓ DB restaurée" -ForegroundColor Green
} else {
    Write-Host "⚠ backup_database.sql non trouvé, DB sera créée à neuf" -ForegroundColor Yellow
}
Write-Host ""

# ÉTAPE 7: Déployer tous les services
Write-Host "✓ Étape 7: Déployer les services Kubernetes..." -ForegroundColor Cyan
kubectl apply -k kubernetes/ 2>&1 | Out-Null
Write-Host "✓ Services déployés" -ForegroundColor Green
Write-Host ""

# ÉTAPE 8: Vérifier les pods
Write-Host "✓ Étape 8: Vérifier les pods..." -ForegroundColor Cyan
kubectl rollout status deployment -n education --timeout=5m 2>&1 | Out-Null
Write-Host ""

# ÉTAPE 9: Afficher les services
Write-Host "✓ Étape 9: Services disponibles:" -ForegroundColor Cyan
kubectl get svc -n education
Write-Host ""

Write-Host "✅ REDÉPLOIEMENT COMPLET!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 Accès aux services:" -ForegroundColor Yellow
Write-Host "  - Frontend: http://localhost:31927"
Write-Host "  - Gateway: kubectl port-forward -n education svc/gateway 3000:3000"
Write-Host "  - Activity-service: kubectl port-forward -n education svc/activity-service 3003:3003"
Write-Host ""
Write-Host "📊 Vérifier les logs:" -ForegroundColor Yellow
Write-Host "  - kubectl logs -n education -l app=activity-service --tail=50"
Write-Host "  - kubectl logs -n education -l app=gateway --tail=50"
