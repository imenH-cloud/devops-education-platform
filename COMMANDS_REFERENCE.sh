#!/bin/bash
# Essential Commands Reference - DevOps Education Platform v2.1

# ============================================================================
# DOCKER COMPOSE - QUICK COMMANDS
# ============================================================================

echo "=== DOCKER COMPOSE COMMANDS ==="

# Start all services
# docker compose up -d

# Check status
# docker compose ps

# View logs (all)
# docker compose logs -f

# View specific service logs
# docker compose logs -f gateway-backend
# docker compose logs -f user-service
# docker compose logs -f elasticsearch

# Stop all
# docker compose stop

# Remove all
# docker compose down

# Remove with volumes
# docker compose down -v

# Rebuild images
# docker compose build --no-cache

# Scale a service
# docker compose up -d --scale user-service=3

# ============================================================================
# DATABASE - POSTGRESQL
# ============================================================================

echo "=== POSTGRESQL COMMANDS ==="

# Connect to database
# docker compose exec postgres psql -U postgres -d education

# Common SQL queries (inside psql)
# \dt                              # list all tables
# SELECT * FROM users;             # query users
# SELECT COUNT(*) FROM activities; # count activities
# CREATE TABLE test (id INT);      # create table
# DROP TABLE test;                 # delete table
# \q                               # quit

# ============================================================================
# CACHING - REDIS
# ============================================================================

echo "=== REDIS COMMANDS ==="

# Connect to Redis
# docker compose exec redis redis-cli

# Redis commands (inside redis-cli)
# KEYS *              # list all keys
# GET key_name        # get value
# SET key value       # set value
# DEL key             # delete key
# DBSIZE              # database size
# FLUSHDB             # clear all keys
# EXPIRE key 3600     # set TTL
# TTL key             # check TTL
# INFO                # server info

# ============================================================================
# MESSAGE BROKER - RABBITMQ
# ============================================================================

echo "=== RABBITMQ COMMANDS ==="

# Access Management UI
# http://localhost:15672
# Username: guest
# Password: guest

# List queues
# docker compose exec rabbitmq rabbitmqctl list_queues

# Reset RabbitMQ
# docker compose exec rabbitmq rabbitmqctl reset

# ============================================================================
# SEARCH & LOGGING - ELASTICSEARCH
# ============================================================================

echo "=== ELASTICSEARCH COMMANDS ==="

# Check health
# curl http://localhost:9200/_cluster/health

# List indices
# curl http://localhost:9200/_cat/indices

# Search logs
# curl -X POST "http://localhost:9200/logs-*/_search" \
#   -H 'Content-Type: application/json' \
#   -d '{"query": {"match": {"message": "error"}}}'

# Delete index
# curl -X DELETE "http://localhost:9200/logs-2024.01.15"

# ============================================================================
# OBJECT STORAGE - MINIO
# ============================================================================

echo "=== MINIO COMMANDS ==="

# Access Console
# http://localhost:9001
# Username: minioadmin
# Password: minioadmin

# Create bucket via API
# curl -X PUT http://localhost:9000/bucket-name

# Upload file
# curl -X PUT -d @file.pdf http://localhost:9000/bucket/file.pdf

# ============================================================================
# MONITORING - PROMETHEUS & GRAFANA
# ============================================================================

echo "=== PROMETHEUS & GRAFANA COMMANDS ==="

# Prometheus UI
# http://localhost:9090

# Query metrics
# curl http://localhost:9090/api/v1/query?query=up

# Grafana UI
# http://localhost:3099
# Username: admin
# Password: admin

# Get Grafana dashboards
# curl http://localhost:3099/api/dashboards/db

# ============================================================================
# API - GATEWAY
# ============================================================================

echo "=== API GATEWAY COMMANDS ==="

# Health check
# curl http://localhost:3000/health

# API documentation
# http://localhost:3000/api/docs

# Get all users
# curl http://localhost:3000/api/users

# Create user
# curl -X POST http://localhost:3000/api/users \
#   -H "Content-Type: application/json" \
#   -d '{"email":"test@example.com","name":"Test","password":"pass"}'

# Get metrics
# curl http://localhost:3000/metrics

# ============================================================================
# FRONTEND
# ============================================================================

echo "=== FRONTEND COMMANDS ==="

# Access app
# http://localhost:4200

# Build for production
# cd frontend/app && npm run build

# Run tests
# npm test

# Run coverage
# npm run test:cov

# Lint code
# npm run lint

# ============================================================================
# KUBERNETES - DEPLOYMENT
# ============================================================================

echo "=== KUBERNETES COMMANDS ==="

# Deploy to dev
# ./deploy.sh dev

# Deploy to staging
# ./deploy.sh staging

# Deploy to production
# ./deploy.sh prod

# Check deployment status
# kubectl get deployments -n prod
# kubectl get pods -n prod
# kubectl get services -n prod

# View pod logs
# kubectl logs -f deployment/gateway-backend -n prod

# Port forward
# kubectl port-forward svc/gateway 3000:3000 -n prod
# kubectl port-forward svc/frontend 4200:4200 -n prod

# Check resources
# kubectl top pods -n prod
# kubectl top nodes

# Describe pod
# kubectl describe pod <pod-name> -n prod

# Get events
# kubectl get events -n prod

# Scale deployment
# kubectl scale deployment gateway-backend --replicas=5 -n prod

# Rollback
# helm rollback devops-education -n prod

# ============================================================================
# DOCKER - IMAGES & CONTAINERS
# ============================================================================

echo "=== DOCKER COMMANDS ==="

# Build specific image
# docker build -t devopspfe-gateway:latest ./backend/gateway

# List images
# docker images

# Remove image
# docker rmi devopspfe-gateway:latest

# Tag image
# docker tag devopspfe-gateway:latest myregistry/devopspfe-gateway:v2.1

# Push to registry
# docker push myregistry/devopspfe-gateway:v2.1

# Pull from registry
# docker pull myregistry/devopspfe-gateway:v2.1

# View image layers
# docker history devopspfe-gateway:latest

# Inspect image
# docker inspect devopspfe-gateway:latest

# Run container
# docker run -p 3000:3000 devopspfe-gateway:latest

# View container logs
# docker logs -f <container-id>

# Execute command in container
# docker exec -it <container-id> bash

# Stop container
# docker stop <container-id>

# Remove container
# docker rm <container-id>

# Prune unused resources
# docker system prune -a

# ============================================================================
# CI/CD - JENKINS
# ============================================================================

echo "=== JENKINS COMMANDS ==="

# Trigger build
# curl -X POST http://jenkins-url/job/devops-education/build

# Get build status
# curl http://jenkins-url/job/devops-education/lastBuild/api/json

# View pipeline
# http://jenkins-url/job/devops-education

# ============================================================================
# HELM - KUBERNETES PACKAGE MANAGER
# ============================================================================

echo "=== HELM COMMANDS ==="

# Install chart
# helm install devops-education ./helm/devops-education \
#   --namespace prod \
#   --values ./helm/devops-education/values-prod.yaml

# Upgrade chart
# helm upgrade devops-education ./helm/devops-education \
#   --namespace prod \
#   --values ./helm/devops-education/values-prod.yaml

# Check deployment
# helm list -n prod

# Get chart values
# helm get values devops-education -n prod

# Rollback release
# helm rollback devops-education 1 -n prod

# Delete release
# helm uninstall devops-education -n prod

# ============================================================================
# GIT - VERSION CONTROL
# ============================================================================

echo "=== GIT COMMANDS ==="

# Clone repository
# git clone <repo-url>

# Create branch
# git checkout -b feature/new-feature

# Commit changes
# git commit -m "Add new feature" -m "" -m "Assisted-By: docker-agent"

# Push to remote
# git push origin feature/new-feature

# Create pull request
# (via GitHub/GitLab UI)

# Merge to main
# git merge feature/new-feature

# ============================================================================
# TESTING & QUALITY
# ============================================================================

echo "=== TESTING COMMANDS ==="

# Run unit tests
# npm test

# Run with coverage
# npm run test:cov

# Run E2E tests
# npm run e2e

# Lint code
# npm run lint

# Format code
# npm run format

# SonarQube scan
# sonar-scanner -Dsonar.projectKey=devops-education

# ============================================================================
# MONITORING & DEBUGGING
# ============================================================================

echo "=== MONITORING COMMANDS ==="

# Check all service health
# curl http://localhost:3000/api/health/all

# Monitor resource usage
# docker stats

# Monitor with top
# docker compose exec gateway-backend top

# Check network connections
# docker compose exec gateway-backend netstat -tulpn

# Check disk usage
# docker compose exec postgres du -sh /var/lib/postgresql

# ============================================================================
# CLEANUP & MAINTENANCE
# ============================================================================

echo "=== CLEANUP COMMANDS ==="

# Clean Docker
# docker system prune -a --volumes

# Clean Kubernetes
# kubectl delete pod --all -n prod

# Clean logs
# docker compose logs --tail 0
# find . -name "*.log" -delete

# ============================================================================
# USEFUL TIPS
# ============================================================================

# Watch command output in real-time
# watch 'docker compose ps'

# Follow multiple logs
# docker compose logs -f gateway-backend user-service

# Export logs
# docker compose logs > logs.txt

# Record metrics
# kubectl get --raw /metrics > metrics.txt

# ============================================================================

echo "✅ All commands documented!"
echo ""
echo "📚 For more information, see:"
echo "  - QUICK_START.md"
echo "  - DEPLOYMENT_GUIDE.md"
echo "  - TOOLS_FRONTEND_IMPROVEMENTS.md"
