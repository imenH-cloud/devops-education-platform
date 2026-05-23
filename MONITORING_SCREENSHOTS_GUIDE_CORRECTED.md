# 📊 GUIDE CORRECT - MONITORING SCREENSHOTS PAR NAMESPACE

## 🎯 STRUCTURE RÉELLE DE TES NAMESPACES

Tu as **BIEN ORGANISÉ** tes services en 4 namespaces séparés:

| Namespace | Services | Purpose |
|-----------|----------|---------|
| **monitoring** | Prometheus, Grafana | Métriques & Dashboards |
| **cache** | Redis | Caching & Sessions |
| **logging** | Elasticsearch, Kibana | Logs centralisés |
| **message-queue** | RabbitMQ | Message broker |
| **education** | 8 microservices + DB | Application principale |

---

# ✅ ÉTAPE 1: PORT-FORWARD TOUS LES SERVICES

**Ouvre 5 terminaux PowerShell/CMD:**

## Terminal 1 - Prometheus (namespace: monitoring)
```powershell
kubectl port-forward -n monitoring svc/prometheus 9090:9090
```

**Output:** `Forwarding from 127.0.0.1:9090 -> 9090`

---

## Terminal 2 - Grafana (namespace: monitoring)
```powershell
kubectl port-forward -n monitoring svc/grafana 3000:3000
```

**Output:** `Forwarding from 127.0.0.1:3000 -> 3000`

---

## Terminal 3 - Redis (namespace: cache)
```powershell
kubectl port-forward -n cache svc/redis 6379:6379
```

**Output:** `Forwarding from 127.0.0.1:6379 -> 6379`

---

## Terminal 4 - Elasticsearch & Kibana (namespace: logging)

**Sub-Terminal 4a - Elasticsearch:**
```powershell
kubectl port-forward -n logging svc/elasticsearch 9200:9200
```

**Sub-Terminal 4b - Kibana:**
```powershell
kubectl port-forward -n logging svc/kibana 5601:5601
```

---

## Terminal 5 - RabbitMQ (namespace: message-queue)
```powershell
kubectl port-forward -n message-queue svc/rabbitmq 15672:15672
```

**Output:** `Forwarding from 127.0.0.1:15672 -> 15672`

---

# ✅ ÉTAPE 2: VÉRIFIER LES PODS

Avant de prendre les screenshots, assure-toi que tous les pods tournent:

```bash
# Vérifier monitoring
kubectl get pods -n monitoring

# Vérifier cache
kubectl get pods -n cache

# Vérifier logging
kubectl get pods -n logging

# Vérifier message-queue
kubectl get pods -n message-queue
```

**Tu devrais voir STATUS = "Running" pour tous**

---

# 📸 ÉTAPE 3: PRENDRE SCREENSHOTS

## A. PROMETHEUS (localhost:9090)

**URL:** http://localhost:9090

### Screenshot 1: Prometheus Homepage
```
1. Ouvre http://localhost:9090
2. Tu vois "Prometheus" dans le header
3. Print Screen → Save as: 01_prometheus_homepage.png
```

### Screenshot 2: Prometheus Metrics
```
1. Clique sur dropdown "- insert metric at cursor"
2. Tu vois une liste des métriques disponibles
3. Print Screen → Save as: 02_prometheus_metrics.png
```

### Screenshot 3: Prometheus Query Results
```
1. Dans le champ "Expression (Expr)" tape: up
2. Clique "Execute" ou Ctrl+Enter
3. Tu vois un graphique avec des points
4. Print Screen → Save as: 03_prometheus_query.png
```

---

## B. GRAFANA (localhost:3000)

**URL:** http://localhost:3000

### Login Grafana
```
Username: admin
Password: admin (ou password, ou 1q2w3e)

Si demande de changer: Skip ou utilise admin123
```

### Screenshot 4: Grafana Login Page
```
1. Avant de login, prendre screenshot de la page login
2. Print Screen → Save as: 04_grafana_login.png
```

### Screenshot 5: Grafana Home/Dashboard
```
1. Après login, tu vois l'accueil
2. Print Screen → Save as: 05_grafana_home.png
```

### Screenshot 6: Grafana Cluster Monitoring
```
1. Cherche le dashboard "Cluster Monitoring" (ou similaire)
2. Clique dessus
3. Tu vois des graphiques: CPU, Memory, Network
4. Print Screen → Save as: 06_grafana_cluster.png
```

### Screenshot 7: Grafana Application Metrics
```
1. Cherche "Application Performance" ou "Services" dashboard
2. Tu vois: Request/sec, Latency P95, Error rate
3. Print Screen → Save as: 07_grafana_app_metrics.png
```

---

## C. REDIS (localhost:6379)

**Note:** Redis n'a pas d'interface web par défaut. 
**Alternative:** Utilise redis-commander ou affiche une commande redis-cli

### Option 1: redis-cli
```bash
# Dans le terminal (pas de port-forward pour redis-cli directement)
# Tu peux afficher les info Redis:

kubectl exec -it -n cache deployment/redis -- redis-cli INFO

# Ou accéder à la console:
kubectl exec -it -n cache deployment/redis -- redis-cli
> INFO
> DBSIZE
> KEYS *
```

### Screenshot 8: Redis Info
```
Si tu veux une interface graphique, installe redis-commander:
docker run -d -p 8081:8081 rediscommander/redis-commander:latest \
  --redis-host host.docker.internal --redis-port 6379

Puis accède à http://localhost:8081

Print Screen → Save as: 08_redis_commander.png
```

---

## D. ELASTICSEARCH (localhost:9200)

**URL:** http://localhost:9200

### Screenshot 9: Elasticsearch Status
```
1. Ouvre http://localhost:9200
2. Tu vois du JSON avec le status d'Elasticsearch
3. Print Screen → Save as: 09_elasticsearch_status.png
```

### Screenshot 10: Elasticsearch Indices
```
1. Ouvre http://localhost:9200/_cat/indices
2. Tu vois la liste des indices (logs)
3. Print Screen → Save as: 10_elasticsearch_indices.png
```

---

## E. KIBANA (localhost:5601)

**URL:** http://localhost:5601

### Screenshot 11: Kibana Home
```
1. Ouvre http://localhost:5601
2. Tu vois "Welcome to Kibana" ou des dashboards
3. Print Screen → Save as: 11_kibana_home.png
```

### Screenshot 12: Kibana Discover
```
1. Clique "Discover" dans le menu gauche
2. Tu vois les logs (ou interface vide si pas de logs)
3. Print Screen → Save as: 12_kibana_discover.png
```

### Screenshot 13: Kibana Logs Dashboard
```
1. Clique "Dashboards"
2. Cherche un dashboard "Logs" ou similaire
3. Print Screen → Save as: 13_kibana_dashboard.png
```

---

## F. RABBITMQ (localhost:15672)

**URL:** http://localhost:15672

### Login RabbitMQ
```
Username: guest
Password: guest
```

### Screenshot 14: RabbitMQ Login
```
1. Ouvre http://localhost:15672
2. Tu vois le login
3. Print Screen → Save as: 14_rabbitmq_login.png
```

### Screenshot 15: RabbitMQ Overview
```
1. Login avec guest/guest
2. Tu vois le dashboard Overview
3. Print Screen → Save as: 15_rabbitmq_overview.png
```

### Screenshot 16: RabbitMQ Queues
```
1. Clique "Queues" dans le menu
2. Tu vois la liste des queues (ou vide si pas de messages)
3. Print Screen → Save as: 16_rabbitmq_queues.png
```

### Screenshot 17: RabbitMQ Connections
```
1. Clique "Connections"
2. Tu vois les clients connectés
3. Print Screen → Save as: 17_rabbitmq_connections.png
```

---

# 📁 ORGANISATION FINALE

```
D:\project\devopsPFE\
└── screenshots\
    └── monitoring\
        ├── 01_prometheus_homepage.png
        ├── 02_prometheus_metrics.png
        ├── 03_prometheus_query.png
        ├── 04_grafana_login.png
        ├── 05_grafana_home.png
        ├── 06_grafana_cluster.png
        ├── 07_grafana_app_metrics.png
        ├── 08_redis_commander.png (optional)
        ├── 09_elasticsearch_status.png
        ├── 10_elasticsearch_indices.png
        ├── 11_kibana_home.png
        ├── 12_kibana_discover.png
        ├── 13_kibana_dashboard.png
        ├── 14_rabbitmq_login.png
        ├── 15_rabbitmq_overview.png
        ├── 16_rabbitmq_queues.png
        └── 17_rabbitmq_connections.png
```

---

# 🎯 OÙ METTRE DANS LE RAPPORT

## Section 8: RÉSULTATS ET VALIDATION

```markdown
## 8.4 Monitoring & Logging Infrastructure

### Monitoring Stack (Namespace: monitoring)

#### Prometheus
Figure 8.1: Prometheus Interface - Query execution
[IMAGE: 03_prometheus_query.png]

#### Grafana Dashboards
Figure 8.2: Grafana Cluster Monitoring - CPU, Memory, Network
[IMAGE: 06_grafana_cluster.png]

Figure 8.3: Grafana Application Metrics - Requests, Latency, Errors
[IMAGE: 07_grafana_app_metrics.png]

### Logging Stack (Namespace: logging)

#### Elasticsearch
Figure 8.4: Elasticsearch Status and Indices
[IMAGE: 10_elasticsearch_indices.png]

#### Kibana
Figure 8.5: Kibana Discover - Centralized Logs
[IMAGE: 12_kibana_discover.png]

Figure 8.6: Kibana Logs Dashboard
[IMAGE: 13_kibana_dashboard.png]

### Message Queue (Namespace: message-queue)

#### RabbitMQ Management
Figure 8.7: RabbitMQ Overview and Statistics
[IMAGE: 15_rabbitmq_overview.png]

Figure 8.8: RabbitMQ Queues
[IMAGE: 16_rabbitmq_queues.png]

Figure 8.9: RabbitMQ Active Connections
[IMAGE: 17_rabbitmq_connections.png]

### Caching Layer (Namespace: cache)

#### Redis
Figure 8.10: Redis Status and Keys
[IMAGE: 08_redis_commander.png]
```

---

# ✅ CHECKLIST FINALE

- [ ] Terminal 1: Prometheus port-forward running
- [ ] Terminal 2: Grafana port-forward running
- [ ] Terminal 3: Redis port-forward running
- [ ] Terminal 4a: Elasticsearch port-forward running
- [ ] Terminal 4b: Kibana port-forward running
- [ ] Terminal 5: RabbitMQ port-forward running

- [ ] http://localhost:9090 - Prometheus accessible ✅
- [ ] http://localhost:3000 - Grafana accessible ✅
- [ ] http://localhost:6379 - Redis accessible ✅
- [ ] http://localhost:9200 - Elasticsearch accessible ✅
- [ ] http://localhost:5601 - Kibana accessible ✅
- [ ] http://localhost:15672 - RabbitMQ accessible ✅

- [ ] Screenshots Prometheus taken (3 images)
- [ ] Screenshots Grafana taken (4 images)
- [ ] Screenshots Elasticsearch taken (2 images)
- [ ] Screenshots Kibana taken (3 images)
- [ ] Screenshots RabbitMQ taken (4 images)
- [ ] Screenshots Redis taken (1 image - optional)

- [ ] Tous les screenshots dans `/screenshots/monitoring/`
- [ ] Nommés selon le pattern: NN_service_description.png
- [ ] Format PNG/JPG
- [ ] Taille < 2MB chacun

---

# 🔄 COMMANDES RAPIDES (COPIER-COLLER)

```bash
# Vérifier tous les services
kubectl get all -n monitoring
kubectl get all -n cache
kubectl get all -n logging
kubectl get all -n message-queue

# Activer le debug si besoin
kubectl describe pod -n monitoring <pod-name>
kubectl logs -n monitoring <pod-name>
```

---

**Tu peux maintenant exécuter toutes les commandes port-forward!** 🚀

**Besoin d'aide pour une étape spécifique?**
