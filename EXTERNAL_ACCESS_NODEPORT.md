# 🌐 Guide d'Accès Externe - NodePort Configuration

## 📋 Vue d'ensemble

Tous les services sont configurés pour être accessibles en externe via:
- **Docker Compose**: Ports directs exposés
- **Kubernetes**: Services NodePort

---

## 🐳 Docker Compose - Accès Directs

### Services Backend

| Service | Port | URL |
|---------|------|-----|
| **Gateway** | 3000 | http://localhost:3000 |
| **Auth Service** | 3001 | http://localhost:3001 |
| **User Service** | 3002 | http://localhost:3002 |
| **Activity Service** | 3003 | http://localhost:3003 |
| **Parent Service** | 3004 | http://localhost:3004 |
| **Student Service** | 3005 | http://localhost:3005 |
| **Classroom Service** | 3006 | http://localhost:3006 |
| **Teacher Service** | 3007 | http://localhost:3007 |

### Frontend

| Service | Port | URL |
|---------|------|-----|
| **Frontend App** | 4200 | http://localhost:4200 |

### Infrastructure

| Service | Port | URL | Credentials |
|---------|------|-----|-------------|
| **PostgreSQL** | 5432 | `localhost:5432` | postgres/postgres |
| **Redis** | 6379 | `localhost:6379` | - |
| **RabbitMQ (AMQP)** | 5672 | `localhost:5672` | guest/guest |
| **RabbitMQ (UI)** | 15672 | http://localhost:15672 | guest/guest |
| **Elasticsearch** | 9200 | http://localhost:9200 | - |
| **Kibana** | 5601 | http://localhost:5601 | - |
| **MinIO (API)** | 9000 | http://localhost:9000 | minioadmin/minioadmin |
| **MinIO (Console)** | 9001 | http://localhost:9001 | minioadmin/minioadmin |
| **Prometheus** | 9090 | http://localhost:9090 | - |
| **Grafana** | 3099 | http://localhost:3099 | admin/admin |

---

## ☸️ Kubernetes - NodePort Access

### Service Ports Mapping

#### API Services
| Service | Internal Port | NodePort | Access |
|---------|---------------|----------|--------|
| Gateway | 3000 | 30000 | `http://<node-ip>:30000` |
| Auth Service | 3001 | 30001 | `http://<node-ip>:30001` |
| User Service | 3002 | 30002 | `http://<node-ip>:30002` |
| Activity Service | 3003 | 30003 | `http://<node-ip>:30003` |
| Parent Service | 3004 | 30004 | `http://<node-ip>:30004` |
| Student Service | 3005 | 30005 | `http://<node-ip>:30005` |
| Classroom Service | 3006 | 30006 | `http://<node-ip>:30006` |
| Teacher Service | 3007 | 30007 | `http://<node-ip>:30007` |

#### Frontend
| Service | Internal Port | NodePort | Access |
|---------|---------------|----------|--------|
| Frontend | 4200 | 30420 | `http://<node-ip>:30420` |

#### Infrastructure
| Service | Internal Port | NodePort | Access | Credentials |
|---------|---------------|----------|--------|-------------|
| PostgreSQL | 5432 | 30432 | `<node-ip>:30432` | postgres/postgres |
| Redis | 6379 | 30379 | `<node-ip>:30379` | - |
| RabbitMQ (AMQP) | 5672 | 30672 | `<node-ip>:30672` | guest/guest |
| RabbitMQ (UI) | 15672 | 30015 | `http://<node-ip>:30015` | guest/guest |
| Elasticsearch | 9200 | 30920 | `http://<node-ip>:30920` | - |
| Kibana | 5601 | 30601 | `http://<node-ip>:30601` | - |
| MinIO (API) | 9000 | 30900 | `http://<node-ip>:30900` | minioadmin/minioadmin |
| MinIO (Console) | 9001 | 30901 | `http://<node-ip>:30901` | minioadmin/minioadmin |
| Prometheus | 9090 | 30090 | `http://<node-ip>:30090` | - |
| Grafana | 3000 | 30300 | `http://<node-ip>:30300` | admin/admin |

---

## 🚀 Déploiement Kubernetes

### Avec Helm (NodePort activé)

```bash
# Development
helm install devops-education ./helm/devops-education \
  --namespace dev \
  --values ./helm/devops-education/values-dev.yaml

# Staging
helm install devops-education ./helm/devops-education \
  --namespace staging \
  --values ./helm/devops-education/values-staging.yaml

# Production
helm install devops-education ./helm/devops-education \
  --namespace prod \
  --values ./helm/devops-education/values-prod.yaml
```

### Vérifier les Services NodePort

```bash
# List all NodePort services
kubectl get services -n prod -o wide | grep NodePort

# Get NodePort details
kubectl get svc -n prod -o jsonpath='{range .items[?(@.spec.type=="NodePort")]}{.metadata.name}{"\t"}{.spec.ports[0].nodePort}{"\n"}{end}'

# Describe specific service
kubectl describe svc gateway-nodeport -n prod
```

### Trouver l'IP du Node

```bash
# Get node IP (external IP if available, else internal)
kubectl get nodes -o wide

# Or get specific node IP
kubectl get node <node-name> -o jsonpath='{.status.addresses[?(@.type=="ExternalIP")].address}'

# If no external IP, use internal IP
kubectl get node <node-name> -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'
```

---

## 🔧 Accès Externe - Par Scénario

### Scénario 1: Docker Compose Local

```bash
# Start stack
docker compose up -d

# Access from same machine
curl http://localhost:3000/health
open http://localhost:4200
open http://localhost:3099  # Grafana

# Access from another machine on network
curl http://<your-machine-ip>:3000/health
```

### Scénario 2: Kubernetes Minikube

```bash
# Get minikube IP
MINIKUBE_IP=$(minikube ip)

# Access services
curl http://$MINIKUBE_IP:30000/health
open http://$MINIKUBE_IP:30420  # Frontend

# Or use minikube service command
minikube service gateway-nodeport -n prod
minikube service frontend-nodeport -n prod
```

### Scénario 3: Kubernetes on Cloud (AWS/GCP/Azure)

```bash
# Get any node's external IP
EXTERNAL_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')

# Access services
curl http://$EXTERNAL_IP:30000/health
curl http://$EXTERNAL_IP:30920  # Elasticsearch
open http://$EXTERNAL_IP:30300  # Grafana

# Or via LoadBalancer (additional setup required)
```

### Scénario 4: Kubernetes on Ubuntu/Linux (Kind)

```bash
# Get kind cluster IP
KIND_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-control-plane)

# Access services
curl http://$KIND_IP:30000/health
open http://$KIND_IP:30420
open http://$KIND_IP:30300  # Grafana
```

---

## 🔌 Connexions de Base de Données

### PostgreSQL via CLI

```bash
# Docker Compose
psql -h localhost -p 5432 -U postgres -d education

# Kubernetes
kubectl port-forward svc/postgres-nodeport 5432:5432 -n prod
psql -h localhost -p 5432 -U postgres -d education

# Or connect directly to NodePort
psql -h <node-ip> -p 30432 -U postgres -d education
```

### Redis via CLI

```bash
# Docker Compose
redis-cli -h localhost -p 6379

# Kubernetes
kubectl port-forward svc/redis-nodeport 6379:6379 -n prod
redis-cli -h localhost -p 6379

# Or connect directly
redis-cli -h <node-ip> -p 30379
```

### Elasticsearch via API

```bash
# Docker Compose
curl http://localhost:9200/_cluster/health

# Kubernetes
curl http://<node-ip>:30920/_cluster/health
```

---

## 🧪 Test de Connectivité

### Script de Test Complet

```bash
#!/bin/bash

echo "=== Docker Compose Connectivity Test ==="

# Backend services
for port in 3000 3001 3002 3003 3004 3005 3006 3007; do
  curl -s http://localhost:$port/health > /dev/null && \
    echo "✅ Service on port $port: OK" || \
    echo "❌ Service on port $port: FAILED"
done

# Frontend
curl -s http://localhost:4200 > /dev/null && \
  echo "✅ Frontend: OK" || \
  echo "❌ Frontend: FAILED"

# Infrastructure
echo "✅ PostgreSQL: $(psql -h localhost -U postgres -d education -c 'SELECT 1' 2>/dev/null && echo 'OK' || echo 'FAILED')"
echo "✅ Redis: $(redis-cli -h localhost ping 2>/dev/null)"
curl -s http://localhost:9200/_cluster/health | jq '.status' && \
  echo "✅ Elasticsearch: OK" || \
  echo "❌ Elasticsearch: FAILED"
curl -s http://localhost:5601/api/status && \
  echo "✅ Kibana: OK" || \
  echo "❌ Kibana: FAILED"
```

### Kubernetes Test

```bash
#!/bin/bash

NAMESPACE=${1:-prod}
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "=== Kubernetes Connectivity Test (Node IP: $NODE_IP) ==="

# API Services
for port in 30000 30001 30002 30003 30004 30005 30006 30007; do
  curl -s http://$NODE_IP:$port/health > /dev/null && \
    echo "✅ NodePort $port: OK" || \
    echo "❌ NodePort $port: FAILED"
done

# Frontend
curl -s http://$NODE_IP:30420 > /dev/null && \
  echo "✅ Frontend (30420): OK" || \
  echo "❌ Frontend (30420): FAILED"

# Infrastructure
curl -s http://$NODE_IP:30920/_cluster/health > /dev/null && \
  echo "✅ Elasticsearch (30920): OK" || \
  echo "❌ Elasticsearch (30920): FAILED"

curl -s http://$NODE_IP:30300/api/health > /dev/null && \
  echo "✅ Grafana (30300): OK" || \
  echo "❌ Grafana (30300): FAILED"
```

---

## 🌍 Accès Distant (SSH Port Forward)

### Desde un client distant

```bash
# Forward local port to remote node
ssh -L 3000:localhost:30000 user@<node-ip>

# Now access locally
curl http://localhost:3000/health

# Multiple forwards
ssh -L 3000:localhost:30000 \
    -L 4200:localhost:30420 \
    -L 9000:localhost:30900 \
    user@<node-ip>
```

---

## 🔒 Sécuriser les NodePorts

### Option 1: Firewall

```bash
# Allow only specific IPs to access NodePorts
ufw allow from 192.168.1.0/24 to any port 30000:30999
```

### Option 2: Network Policy (Kubernetes)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: nodeport-access
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: prod
```

### Option 3: Convert to LoadBalancer (Cloud)

```bash
# Change service type
kubectl patch svc gateway-nodeport -n prod -p '{"spec": {"type": "LoadBalancer"}}'

# Get external IP
kubectl get svc gateway-nodeport -n prod -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

---

## 📊 Résumé des Accès

```
┌─────────────────────────────────────────────────────────────┐
│              EXTERNAL ACCESS CONFIGURATION                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Docker Compose (Local):                                   │
│   Frontend     → http://localhost:4200                    │
│   API Gateway  → http://localhost:3000                    │
│   Grafana      → http://localhost:3099                    │
│                                                             │
│ Kubernetes NodePort (Network):                            │
│   Frontend     → http://<node-ip>:30420                   │
│   API Gateway  → http://<node-ip>:30000                   │
│   Grafana      → http://<node-ip>:30300                   │
│   PostgreSQL   → <node-ip>:30432                          │
│   Elasticsearch→ http://<node-ip>:30920                   │
│                                                             │
│ All 20 Services Accessible Externally! ✅                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚠️ Important Notes

1. **Node Port Range**: 30000-32767 (Kubernetes default)
2. **Firewall**: Ensure firewall allows these ports
3. **DNS**: Configure DNS for better accessibility
4. **LoadBalancer**: For production, use LoadBalancer type
5. **VPN**: For security, use VPN or proxy in production
6. **SSL/TLS**: Add SSL certificates for HTTPS access

---

**Version**: 2.1.0 - NodePort Edition  
**All Services External**: ✅ 20/20 Services  
**Ready for Deployment**: ✅ Yes
