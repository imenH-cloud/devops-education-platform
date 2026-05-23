#!/bin/bash

# Script pour appliquer la prévention des erreurs de schéma à TOUS les services
# Usage: chmod +x apply-schema-prevention.sh && ./apply-schema-prevention.sh

SERVICES=(
  "auth"
  "user"
  "activity"
  "parent"
  "student"
  "classroom"
  "teacher"
  "gateway"
)

echo "🔄 Applying schema prevention to all services..."
echo "=================================================="

for service in "${SERVICES[@]}"; do
  echo ""
  echo "📦 Processing: $service-service"
  
  SERVICE_PATH="./backend/$service"
  
  if [ ! -d "$SERVICE_PATH" ]; then
    echo "❌ Service not found: $SERVICE_PATH"
    continue
  fi

  # 1. Create migrations folder
  mkdir -p "$SERVICE_PATH/src/migrations"
  mkdir -p "$SERVICE_PATH/src/database"
  mkdir -p "$SERVICE_PATH/src/health"

  # 2. Copy init script if not exists
  if [ ! -f "$SERVICE_PATH/src/database/init.ts" ]; then
    echo "   📋 Adding database init script..."
    cp templates/database-init.ts "$SERVICE_PATH/src/database/init.ts"
  fi

  # 3. Copy health controller if not exists
  if [ ! -f "$SERVICE_PATH/src/health/health.controller.ts" ]; then
    echo "   🏥 Adding health controller..."
    cp templates/health.controller.ts "$SERVICE_PATH/src/health/health.controller.ts"
    cp templates/health.module.ts "$SERVICE_PATH/src/health/health.module.ts"
  fi

  # 4. Update package.json with migration scripts
  if ! grep -q "migration:run" "$SERVICE_PATH/package.json"; then
    echo "   📝 Updating package.json scripts..."
    # Using jq to add scripts
    jq '.scripts."migration:run" = "ts-node -r tsconfig-paths/register ./node_modules/typeorm/cli.js migration:run"' \
      "$SERVICE_PATH/package.json" > "$SERVICE_PATH/package.json.tmp" && \
      mv "$SERVICE_PATH/package.json.tmp" "$SERVICE_PATH/package.json"
  fi

  echo "   ✅ $service-service ready"
done

echo ""
echo "✅ All services updated!"
echo ""
echo "Next steps:"
echo "1. Add migrations to src/migrations/ for each service"
echo "2. Update main.ts: import & call initializeDatabase()"
echo "3. Update Kubernetes deployment YAML with health checks"
echo "4. Rebuild Docker images"
echo "5. Deploy!"
