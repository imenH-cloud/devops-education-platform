# 🚀 QUICK START - PRENDRE LES SCREENSHOTS EN 30 MINUTES

## ✅ STATUS: TOUS LES SERVICES TOURNENT!

```
Prometheus   ✅ Running
Grafana      ✅ Running
Elasticsearch ✅ Running
Kibana       ✅ Running
RabbitMQ     ✅ Running
Redis        ✅ Running
```

---

## 📋 ÉTAPES RAPIDES

### ÉTAPE 1: Ouvrir 6 PowerShell/Terminal (2 minutes)

**PowerShell 1:**
```powershell
kubectl port-forward -n monitoring svc/prometheus 9090:9090
```
Wait for: `Forwarding from 127.0.0.1:9090 -> 9090`

**PowerShell 2:**
```powershell
kubectl port-forward -n monitoring svc/grafana 3000:3000
```
Wait for: `Forwarding from 127.0.0.1:3000 -> 3000`

**PowerShell 3:**
```powershell
kubectl port-forward -n logging svc/elasticsearch 9200:9200
```
Wait for: `Forwarding from 127.0.0.1:9200 -> 9200`

**PowerShell 4:**
```powershell
kubectl port-forward -n logging svc/kibana 5601:5601
```
Wait for: `Forwarding from 127.0.0.1:5601 -> 5601`

**PowerShell 5:**
```powershell
kubectl port-forward -n message-queue svc/rabbitmq 15672:15672
```
Wait for: `Forwarding from 127.0.0.1:15672 -> 15672`

**PowerShell 6 (Optional - Redis):**
```powershell
kubectl port-forward -n cache svc/redis 6379:6379
```
Wait for: `Forwarding from 127.0.0.1:6379 -> 6379`

---

### ÉTAPE 2: Ouvrir 5 Onglets Chrome (1 minute)

1. Tab 1: http://localhost:9090 (Prometheus)
2. Tab 2: http://localhost:3000 (Grafana)
3. Tab 3: http://localhost:5601 (Kibana)
4. Tab 4: http://localhost:9200 (Elasticsearch)
5. Tab 5: http://localhost:15672 (RabbitMQ)

---

### ÉTAPE 3: Créer le Dossier pour les Screenshots (1 minute)

Crée ce dossier:
```
D:\project\devopsPFE\screenshots\monitoring\
```

---

### ÉTAPE 4: Prendre les Screenshots (20 minutes)

#### PROMETHEUS (3 images - 3 min)

**Screenshot 1: Homepage**
1. Tab 1: http://localhost:9090
2. Tu vois la page "Prometheus"
3. Print Screen → Paste in Paint
4. Save: `01_prometheus_homepage.png`

**Screenshot 2: Metrics List**
1. Clique le dropdown "- insert metric at cursor"
2. Tu vois la liste des metrics
3. Print Screen
4. Save: `02_prometheus_metrics.png`

**Screenshot 3: Query Results**
1. Dans "Expression (Expr)" tape: `up`
2. Clique "Execute"
3. Tu vois le graphique
4. Print Screen
5. Save: `03_prometheus_query.png`

---

#### GRAFANA (4 images - 5 min)

**Screenshot 4: Login Page**
1. Tab 2: http://localhost:3000
2. Print Screen
3. Save: `04_grafana_login.png`

**Screenshot 5: After Login**
1. Login: admin / admin
2. Print Screen
3. Save: `05_grafana_home.png`

**Screenshot 6: Cluster Dashboard**
1. Cherche "Cluster Monitoring" dashboard
2. Print Screen
3. Save: `06_grafana_cluster.png`

**Screenshot 7: Application Dashboard**
1. Cherche "Application Performance" dashboard
2. Print Screen
3. Save: `07_grafana_app_metrics.png`

---

#### ELASTICSEARCH (2 images - 2 min)

**Screenshot 8: Status**
1. Tab 4: http://localhost:9200
2. Tu vois du JSON
3. Print Screen
4. Save: `09_elasticsearch_status.png`

**Screenshot 9: Indices**
1. Va sur: http://localhost:9200/_cat/indices
2. Tu vois la liste des indices
3. Print Screen
4. Save: `10_elasticsearch_indices.png`

---

#### KIBANA (3 images - 3 min)

**Screenshot 10: Home**
1. Tab 3: http://localhost:5601
2. Print Screen
3. Save: `11_kibana_home.png`

**Screenshot 11: Discover**
1. Clique "Discover" dans le menu
2. Print Screen
3. Save: `12_kibana_discover.png`

**Screenshot 12: Dashboard**
1. Clique "Dashboards"
2. Print Screen
3. Save: `13_kibana_dashboard.png`

---

#### RABBITMQ (4 images - 4 min)

**Screenshot 13: Login**
1. Tab 5: http://localhost:15672
2. Print Screen
3. Save: `14_rabbitmq_login.png`

**Screenshot 14: Overview**
1. Login: guest / guest
2. Print Screen
3. Save: `15_rabbitmq_overview.png`

**Screenshot 15: Queues**
1. Clique "Queues"
2. Print Screen
3. Save: `16_rabbitmq_queues.png`

**Screenshot 16: Connections**
1. Clique "Connections"
2. Print Screen
3. Save: `17_rabbitmq_connections.png`

---

## 📁 RÉSUMÉ DES FICHIERS

Après étape 4, tu auras:

```
D:\project\devopsPFE\screenshots\monitoring\
├── 01_prometheus_homepage.png
├── 02_prometheus_metrics.png
├── 03_prometheus_query.png
├── 04_grafana_login.png
├── 05_grafana_home.png
├── 06_grafana_cluster.png
├── 07_grafana_app_metrics.png
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

**Total: 16 screenshots** ✅

---

## 📄 ÉTAPE 5: Ajouter au Rapport (2 minutes)

Dans le fichier `RAPPORT_PFE_FINAL_IMEN_HAMADA_2025.md`:

Cherche la section: **8. RÉSULTATS ET VALIDATION**

Ajoute:

```markdown
## 8.4 Monitoring & Logging Infrastructure

### Prometheus Metrics
Figure 8.1: Prometheus Query Execution
![Prometheus Query](screenshots/monitoring/03_prometheus_query.png)

### Grafana Dashboards
Figure 8.2: Cluster Monitoring
![Grafana Cluster](screenshots/monitoring/06_grafana_cluster.png)

Figure 8.3: Application Performance
![Grafana App](screenshots/monitoring/07_grafana_app_metrics.png)

### Elasticsearch & Kibana
Figure 8.4: Elasticsearch Indices
![ES Indices](screenshots/monitoring/10_elasticsearch_indices.png)

Figure 8.5: Kibana Logs
![Kibana Logs](screenshots/monitoring/12_kibana_discover.png)

Figure 8.6: Kibana Dashboard
![Kibana Dashboard](screenshots/monitoring/13_kibana_dashboard.png)

### RabbitMQ
Figure 8.7: RabbitMQ Overview
![RabbitMQ Overview](screenshots/monitoring/15_rabbitmq_overview.png)

Figure 8.8: RabbitMQ Queues
![RabbitMQ Queues](screenshots/monitoring/16_rabbitmq_queues.png)

Figure 8.9: RabbitMQ Connections
![RabbitMQ Connections](screenshots/monitoring/17_rabbitmq_connections.png)
```

---

## ⏱️ TIMELINE TOTALE

- **Étape 1 (Port-forward):** 2 min
- **Étape 2 (Ouvrir URLs):** 1 min
- **Étape 3 (Créer dossier):** 1 min
- **Étape 4 (Screenshots):** 20 min
- **Étape 5 (Ajouter rapport):** 2 min

**TOTAL: 26 minutes!** ⚡

---

## 🎯 APRÈS LES SCREENSHOTS

Tu auras:

✅ Rapport PFE complet  
✅ Screenshots Jenkins (6 images)  
✅ Screenshots Monitoring (16 images)  
✅ Article Medium (published)  
✅ Prêt à défendre! 🎓

---

**Start now! Tu peux finir en moins d'une heure!** 🚀
