#!/bin/bash
# SOUTENANCE DEPLOYMENT SCRIPT
# Applique les manifests Kubernetes depuis le repo GitOps local

echo "🚀 Deploying from LOCAL GitOps repo..."
echo "======================================"
echo ""

GITOPS_PATH="D:\project\devopsPFE\devops-education-platform-gitops\kubernetes"

echo "1️⃣ Applying Kustomize manifests..."
kubectl apply -k "$GITOPS_PATH"

echo ""
echo "2️⃣ Waiting for rollout..."
sleep 10

echo ""
echo "3️⃣ Verification:"
kubectl get deployments -n education
kubectl get pods -n education

echo ""
echo "✅ Deployment complete!"
echo "All services from LocalGitOps applied"
