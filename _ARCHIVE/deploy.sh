#!/bin/bash
set -e

echo "=== ÉTAPE 1: Arrêter les conteneurs existants ==="
docker stop auth-service gateway-backend frontend-app user-service 2>/dev/null || true
docker rm auth-service gateway-backend frontend-app user-service 2>/dev/null || true

echo "=== ÉTAPE 2: Reconstruire les images ==="
echo "Building auth-service..."
docker build -t eline2016/devopspfe-auth-service:v1 --no-cache -f backend/auth/Dockerfile backend/auth

echo "Building gateway-backend..."
docker build -t eline2016/devopspfe-gateway-backend:v1 --no-cache -f backend/gateway/Dockerfile backend/gateway

echo "Building user-service..."
docker build -t eline2016/devopspfe-user-service:v1 --no-cache -f backend/user/Dockerfile backend/user

echo "Building frontend..."
docker build -t eline2016/devopspfe-frontend-app:v1 --no-cache -f frontend/Dockerfile frontend

echo "=== ÉTAPE 3: Démarrer les conteneurs ==="
docker run -d -p 3001:3001 --network devopspfe_app-network --name auth-service \
  -e "USER_SERVICE_URL=http://user-service:3002" \
  -e "DB_HOST=postgres-db" -e "DB_PORT=5432" \
  -e "DB_USERNAME=postgres" -e "DB_PASSWORD=postgres" \
  -e "DB_NAME=education" \
  eline2016/devopspfe-auth-service:v1

docker run -d -p 3002:3002 --network devopspfe_app-network --name user-service \
  -e "DB_HOST=postgres-db" -e "DB_PORT=5432" \
  -e "DB_USERNAME=postgres" -e "DB_PASSWORD=postgres" \
  -e "DB_NAME=education" \
  eline2016/devopspfe-user-service:v1

docker run -d -p 3000:3000 --network devopspfe_app-network --name gateway-backend \
  -e "DB_HOST=postgres-db" -e "DB_PORT=5432" \
  -e "DB_USERNAME=postgres" -e "DB_PASSWORD=postgres" \
  -e "DB_NAME=education" \
  eline2016/devopspfe-gateway-backend:v1

docker run -d -p 31927:4200 --network devopspfe_app-network --name frontend-app \
  eline2016/devopspfe-frontend-app:v1

echo "=== ÉTAPE 4: Attendre le démarrage ==="
sleep 5

echo "=== ÉTAPE 5: Charger les données ==="
docker exec postgres-db psql -U postgres -d education << 'SQL'
DELETE FROM users WHERE email = 'admin@school.com';
INSERT INTO users (email, password, "firstName", "lastName", active) 
VALUES ('admin@school.com', 'admin12345', 'Admin', 'School', true)
ON CONFLICT DO NOTHING;
SQL

echo "✓ Déploiement complet!"
echo "Frontend: http://localhost:31927"
echo "Gateway: http://localhost:3000"
echo "Identifiants: admin@school.com / admin12345"
