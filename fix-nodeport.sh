#!/bin/bash

# Fix the services to be accessible from localhost
# Services are in 'education' namespace, need to be exposed via NodePort

echo "🔧 Converting Services to NodePort for external access..."
echo ""

# Grafana
echo "Converting grafana-service to NodePort..."
kubectl patch svc grafana-service -n education -p '{"spec":{"type":"NodePort","ports":[{"port":80,"nodePort":30300,"protocol":"TCP"}]}}'
echo "✅ Grafana available at http://localhost:30300"
echo ""

# Prometheus
echo "Converting prometheus-service to NodePort..."
kubectl patch svc prometheus-service -n education -p '{"spec":{"type":"NodePort","ports":[{"port":9090,"nodePort":30090,"protocol":"TCP"}]}}'
echo "✅ Prometheus available at http://localhost:30090"
echo ""

# Gateway
echo "Converting gateway-backend to NodePort..."
kubectl patch svc gateway-backend -n education -p '{"spec":{"type":"NodePort","ports":[{"port":3000,"nodePort":30000,"protocol":"TCP"}]}}'
echo "✅ API Gateway available at http://localhost:30000"
echo ""

# Verify
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All services converted to NodePort!"
echo ""
echo "Available URLs:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Frontend:      http://localhost:31927/"
echo "API Gateway:   http://localhost:30000/"
echo "Grafana:       http://localhost:30300/ (admin/admin)"
echo "Prometheus:    http://localhost:30090/"
echo "ArgoCD:        https://localhost:31961/"
echo ""
echo "All services should be accessible now!"
