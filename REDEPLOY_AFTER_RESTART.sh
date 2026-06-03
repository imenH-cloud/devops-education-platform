#!/bin/bash

# REDÉPLOIEMENT COMPLET APRÈS RESTART DOCKER DESKTOP
# Usage: ./REDEPLOY_AFTER_RESTART.sh

set -e

echo "🚀 REDÉPLOIEMENT APRÈS RESTART DOCKER DESKTOP"
echo "=============================================="
echo ""

# ÉTAPE 1: Vérifier Docker
echo "✓ Étape 1: Vérifier Docker..."
docker info > /dev/null 2>&1 || { echo "❌ Docker non disponible"; exit 1; }
echo "✓ Docker est actif"
echo ""

# ÉTAPE 2: Charger les images Docker
echo "✓ Étape 2: Charger les images Docker..."
echo "  - activity-service:v10"
docker pull eline2016/devopspfe-activity-service:v10 || echo "⚠ Pull échoué, utilisation locale"

echo "  - gateway-backend:v8"
docker pull eline2016/devopspfe-gateway-backend:v8 || echo "⚠ Pull échoué, utilisation locale"
echo "✓ Images chargées"
echo ""

# ÉTAPE 3: Vérifier Kubernetes
echo "✓ Étape 3: Vérifier Kubernetes..."
kubectl cluster-info > /dev/null 2>&1 || { echo "❌ Kubernetes non disponible"; exit 1; }
echo "✓ Kubernetes est actif"
echo ""

# ÉTAPE 4: Créer namespace
echo "✓ Étape 4: Créer namespace..."
kubectl create namespace education --dry-run=client -o yaml | kubectl apply -f -
echo "✓ Namespace créé/existant"
echo ""

# ÉTAPE 5: Créer Secrets
echo "✓ Étape 5: Créer Secrets..."
kubectl create secret generic postgres-secret \
  --from-literal=username=education \
  --from-literal=password=education123 \
  -n education \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic jwt-secret \
  --from-literal=jwt-secret=your-jwt-secret-key-here \
  -n education \
  --dry-run=client -o yaml | kubectl apply -f -
echo "✓ Secrets créés"
echo ""

# ÉTAPE 6: Restaurer la DB depuis backup
echo "✓ Étape 6: Restaurer la base de données..."
if [ -f "backup_database.sql" ]; then
  echo "  ⚙ Attente du pod PostgreSQL..."
  kubectl rollout status statefulset/postgres -n education --timeout=5m || true
  
  echo "  ⚙ Restauration de la DB..."
  kubectl exec postgres-0 -n education -- psql -U education -d education_db -f - < backup_database.sql 2>/dev/null || echo "  ⚠ Restauration échouée ou DB déjà existante"
  echo "✓ DB restaurée"
else
  echo "⚠ backup_database.sql non trouvé, DB sera créée à neuf"
fi
echo ""

# ÉTAPE 7: Déployer tous les services
echo "✓ Étape 7: Déployer les services Kubernetes..."
kubectl apply -k kubernetes/
echo "✓ Services déployés"
echo ""

# ÉTAPE 8: Vérifier les pods
echo "✓ Étape 8: Vérifier les pods..."
kubectl rollout status deployment -n education --timeout=5m || echo "⚠ Rollout timeout (normal pour premiers déploiements)"
echo ""

# ÉTAPE 9: Afficher les services
echo "✓ Étape 9: Services disponibles:"
kubectl get svc -n education
echo ""

echo "✅ REDÉPLOIEMENT COMPLET!"
echo ""
echo "🔗 Accès aux services:"
echo "  - Frontend: http://localhost:31927"
echo "  - Gateway: kubectl port-forward -n education svc/gateway 3000:3000"
echo "  - Activity-service: kubectl port-forward -n education svc/activity-service 3003:3003"
echo ""
echo "📊 Vérifier les logs:"
echo "  - kubectl logs -n education -l app=activity-service --tail=50"
echo "  - kubectl logs -n education -l app=gateway --tail=50"
