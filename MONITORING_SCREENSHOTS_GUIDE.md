# 📊 GUIDE COMPLET - MONITORING SCREENSHOTS POUR LE RAPPORT

## 🎯 Services à Configurer et Capturer

Tu vas ouvrir 4 services et prendre des screenshots:

1. **Prometheus** - Collecte des métriques
2. **Grafana** - Dashboards visuels
3. **Kibana** - Logs et analytics
4. **RabbitMQ** - Message queue management

---

## ✅ ÉTAPE 1: DÉMARRER LES SERVICES

### Prérequis:
- Docker Desktop running ✅
- Kubernetes cluster running ✅
- Services déployés dans namespace `education` ✅

### Commandes pour Vérifier:

```bash
# Vérifier que les pods tournent
kubectl get pods -n education

# Vérifier les services
kubectl get svc -n education
```

Cherche ces services dans la sortie:
- prometheus
- grafana
- kibana
- elasticsearch
- rabbitmq

---

## 🔴 ÉTAPE 2: ACCÉDER À PROMETHEUS

### Ouvrir Prometheus:

```bash
# Port-forward vers Prometheus
kubectl port-forward -n education svc/prometheus 9090:9090
```

**Ou:** Si Prometheus est exposé via NodePort

```bash
# Vérifier le port NodePort
kubectl get svc -n education prometheus

# Cherche le port externe (ex: 31090)
# Va sur: http://localhost:31090
```

### URL:
```
http://localhost:9090
```

### Qu'est-ce qu'on voit?

Tu devrais voir:
- "Prometheus" dans le header
- "Expression Browser" au centre
- Graphiques vides (normal, pas encore de requêtes)

### Screenshots à Prendre:

#### Screenshot 1: Prometheus Homepage
**Ce à capter:**
- L'interface principale
- Le menu gauche
- "Expression Browser"

**Comment:**
1. Va sur http://localhost:9090
2. Appuie Print Screen
3. Save as `01_prometheus_homepage.png`

#### Screenshot 2: Prometheus Metrics

**Ce à capter:**
- Les métriques disponibles
- Exemples: `up`, `rate`, `http_requests_total`

**Comment:**
1. Clique sur le dropdown "- insert metric at cursor"
2. Tu vois une liste de metrics
3. Screenshot
4. Save as `02_prometheus_metrics_list.png`

#### Screenshot 3: Prometheus Query Results

**Ce à capter:**
- Une requête Prometheus exécutée
- Graphique avec des données
- Tableau de résultats

**Requête à exécuter:**
```
up
```

**Comment:**
1. Dans "Expression (Expr)": Tape `up`
2. Clique "Execute" (ou Ctrl+Enter)
3. Tu vois un graphique
4. Screenshot
5. Save as `03_prometheus_query_results.png`

---

## 🔵 ÉTAPE 3: ACCÉDER À GRAFANA

### Ouvrir Grafana:

```bash
# Port-forward vers Grafana
kubectl port-forward -n education svc/grafana 3000:3000
```

### URL:
```
http://localhost:3000
```

### Login Grafana:

**Identifiants par défaut:**
- Username: `admin`
- Password: `admin` (ou `password`)

**Si ça demande de changer le password:**
- Clique "Skip" ou crée un nouveau
- Utilise `admin123` ou `grafana123`

### Qu'est-ce qu'on voit?

Tu devrais voir:
- Dashboard avec plusieurs panneaux
- Graphiques temps-réel
- CPU, Memory, Request rates
- Status des services

### Screenshots à Prendre:

#### Screenshot 4: Grafana Login
**Ce à capter:**
- Page de login Grafana
- Champs username/password

**Comment:**
1. Va sur http://localhost:3000
2. Tu vois la page de login
3. Screenshot
4. Save as `04_grafana_login.png`

#### Screenshot 5: Grafana Dashboard - Cluster Monitoring

**Ce à capter:**
- Dashboard avec Cluster Health
- Graphiques colorés
- Métriques CPU, Memory, Network

**Comment:**
1. Login (admin / admin)
2. Tu arrives sur accueil
3. Cherche "Cluster Monitoring" dashboard (dans Home)
4. Clique dessus
5. Screenshot
6. Save as `05_grafana_cluster_dashboard.png`

#### Screenshot 6: Grafana Dashboard - Application Performance

**Ce à capter:**
- Dashboard avec Application Metrics
- Request/sec
- Latency P95, P99
- Error rate
- Service health

**Comment:**
1. Cherche "Application Performance" dashboard
2. Ou "Services" dashboard
3. Screenshot
4. Save as `06_grafana_app_dashboard.png`

#### Screenshot 7: Grafana Alerting (Optional)

**Ce à capter:**
- Alertes configurées
- Thresholds
- Status: OK, Warning, Critical

**Comment:**
1. Clique "Alerting" dans le menu gauche
2. Cherche les alertes
3. Screenshot
4. Save as `07_grafana_alerts.png`

---

## 🟡 ÉTAPE 4: ACCÉDER À KIBANA

### Ouvrir Kibana:

```bash
# Port-forward vers Kibana
kubectl port-forward -n education svc/kibana 5601:5601
```

### URL:
```
http://localhost:5601
```

### Qu'est-ce qu'on voit?

Tu devrais voir:
- Kibana interface
- "Welcome to Kibana"
- Logs et visualizations
- Données d'Elasticsearch

### Screenshots à Prendre:

#### Screenshot 8: Kibana Homepage

**Ce à capter:**
- Kibana logo
- Menu principal
- "Discover" option

**Comment:**
1. Va sur http://localhost:5601
2. Tu vois l'accueil
3. Screenshot
4. Save as `08_kibana_homepage.png`

#### Screenshot 9: Kibana Discover - Logs

**Ce à capter:**
- Liste des logs
- Timestamps
- Log entries
- Filtres appliqués

**Comment:**
1. Clique "Discover" dans le menu
2. Tu vois les logs indexés
3. Si aucun log: ce n'est pas grave (prendre screenshot de l'interface vide)
4. Screenshot
5. Save as `09_kibana_discover_logs.png`

#### Screenshot 10: Kibana Visualizations

**Ce à capter:**
- Graphiques des logs
- Timeline
- Log levels (INFO, ERROR, WARNING)
- Service names

**Comment:**
1. Clique "Visualizations" dans le menu
2. Tu vois les graphiques
3. Screenshot
4. Save as `10_kibana_visualizations.png`

#### Screenshot 11: Kibana Dashboard

**Ce à capter:**
- Dashboard avec logs
- Plusieurs panneaux
- Statistiques

**Comment:**
1. Clique "Dashboards"
2. Cherche "Logs Dashboard" ou similaire
3. Clique pour ouvrir
4. Screenshot
5. Save as `11_kibana_dashboard.png`

---

## 🟣 ÉTAPE 5: ACCÉDER À RABBITMQ

### Ouvrir RabbitMQ:

```bash
# Port-forward vers RabbitMQ Management
kubectl port-forward -n education svc/rabbitmq 15672:15672
```

### URL:
```
http://localhost:15672
```

### Login RabbitMQ:

**Identifiants par défaut:**
- Username: `guest`
- Password: `guest`

### Qu'est-ce qu'on voit?

Tu devrais voir:
- RabbitMQ Management Console
- Queues
- Connections
- Channels
- Statistics

### Screenshots à Prendre:

#### Screenshot 12: RabbitMQ Overview

**Ce à capter:**
- Dashboard principal
- Statistics
- Queue status
- Node health

**Comment:**
1. Va sur http://localhost:15672
2. Login (guest / guest)
3. Tu vois l'Overview
4. Screenshot
5. Save as `12_rabbitmq_overview.png`

#### Screenshot 13: RabbitMQ Queues

**Ce à capter:**
- Liste des queues
- Queue names
- Messages count
- Consumer count

**Comment:**
1. Clique "Queues" dans le menu
2. Tu vois la liste des queues
3. Screenshot
4. Save as `13_rabbitmq_queues.png`

#### Screenshot 14: RabbitMQ Connections

**Ce à capter:**
- Connexions actives
- Clients connectés
- Channels

**Comment:**
1. Clique "Connections"
2. Tu vois les connexions
3. Screenshot
4. Save as `14_rabbitmq_connections.png`

---

## 📋 RÉSUMÉ - TOUS LES SCREENSHOTS

| # | Service | Screenshot | Contenu |
|---|---------|-----------|---------|
| 01 | Prometheus | prometheus_homepage.png | Interface principale |
| 02 | Prometheus | prometheus_metrics_list.png | Liste des métriques |
| 03 | Prometheus | prometheus_query_results.png | Requête + graphique |
| 04 | Grafana | grafana_login.png | Page login |
| 05 | Grafana | grafana_cluster_dashboard.png | Cluster monitoring |
| 06 | Grafana | grafana_app_dashboard.png | Application performance |
| 07 | Grafana | grafana_alerts.png | Alertes (optional) |
| 08 | Kibana | kibana_homepage.png | Interface principale |
| 09 | Kibana | kibana_discover_logs.png | Logs découverte |
| 10 | Kibana | kibana_visualizations.png | Visualisations |
| 11 | Kibana | kibana_dashboard.png | Logs dashboard |
| 12 | RabbitMQ | rabbitmq_overview.png | Overview |
| 13 | RabbitMQ | rabbitmq_queues.png | Liste queues |
| 14 | RabbitMQ | rabbitmq_connections.png | Connexions |

---

## 🎯 OÙ METTRE CES SCREENSHOTS DANS LE RAPPORT

### Section: **8. RÉSULTATS ET VALIDATION → 8.1 Métriques de Performance**

```markdown
### Monitoring Stack - Screenshots

#### Prometheus
Figure 8.1: Prometheus Interface - Métriques disponibles
[Screenshot Prometheus Homepage]

Figure 8.2: Prometheus Query Results - Uptime des services
[Screenshot Prometheus Query]

#### Grafana Dashboards
Figure 8.3: Grafana Cluster Monitoring - CPU/Memory/Network
[Screenshot Grafana Cluster]

Figure 8.4: Grafana Application Performance - Request rate et Latency
[Screenshot Grafana App]

#### Kibana Logs
Figure 8.5: Kibana Discover - Logs centralisés
[Screenshot Kibana Logs]

Figure 8.6: Kibana Dashboard - Visualisations temps réel
[Screenshot Kibana Dashboard]

#### RabbitMQ Management
Figure 8.7: RabbitMQ Queues - Message flow
[Screenshot RabbitMQ Queues]

Figure 8.8: RabbitMQ Connections - Clients connectés
[Screenshot RabbitMQ Connections]
```

---

## 💡 TIPS POUR SCREENSHOTS PROFESSIONNELS

### ✅ FAIRE:
- Screenshots avec données visibles
- Titres clairs dans les interfaces
- Graphiques colorés (bien visibles)
- Dates/heures pour montrer en temps réel
- Context visible (menus, headers)

### ❌ NE PAS FAIRE:
- Screenshots vides (attendre que données chargent)
- Barre Windows entière
- Zoom trop faible (illisible)
- Données sensibles
- Screenshots floues

---

## 🔄 CHECKLIST COMPLÈTE

- [ ] Prometheus ouvert sur http://localhost:9090
- [ ] Metrics visibles
- [ ] Query exécutée et graphique affiché
- [ ] Screenshots Prometheus prises (3 images)

- [ ] Grafana ouvert sur http://localhost:3000
- [ ] Login successful (admin/admin)
- [ ] Dashboards visibles
- [ ] Screenshots Grafana prises (3-4 images)

- [ ] Kibana ouvert sur http://localhost:5601
- [ ] Logs indexés et affichés
- [ ] Dashboard visible
- [ ] Screenshots Kibana prises (3-4 images)

- [ ] RabbitMQ ouvert sur http://localhost:15672
- [ ] Login successful (guest/guest)
- [ ] Queues visibles
- [ ] Screenshots RabbitMQ prises (3 images)

- [ ] Tous les screenshots dans dossier `screenshots/monitoring/`
- [ ] Nommés logiquement (01_, 02_, etc)
- [ ] Format PNG ou JPG
- [ ] Taille < 2MB chacun

---

## 🚨 TROUBLESHOOTING

### "Service non accessible sur localhost:xxxx"

**Solution:**
```bash
# Vérifier que le pod tourne
kubectl get pod -n education | grep prometheus
# ou grafana, kibana, rabbitmq

# Vérifier le port-forward
kubectl port-forward -n education svc/prometheus 9090:9090

# Attendre 5 secondes et recharger le navigateur
```

### "Login Grafana/RabbitMQ échoue"

**Solution:**
```bash
# Pour Grafana, essaye:
# admin / password
# admin / 1q2w3e

# Pour RabbitMQ:
# guest / guest
```

### "Aucune donnée dans Prometheus/Kibana"

**C'est normal!** Les pods tournent depuis peu. Prends le screenshot de l'interface vide, c'est suffisant pour montrer que les services sont running.

---

## ✅ COMMANDES FINALES

```bash
# Ouvrir tous les services à la fois:

# Terminal 1: Prometheus
kubectl port-forward -n education svc/prometheus 9090:9090

# Terminal 2: Grafana
kubectl port-forward -n education svc/grafana 3000:3000

# Terminal 3: Kibana
kubectl port-forward -n education svc/kibana 5601:5601

# Terminal 4: RabbitMQ
kubectl port-forward -n education svc/rabbitmq 15672:15672
```

**Puis ouvrir 4 onglets navigateur:**
1. http://localhost:9090 (Prometheus)
2. http://localhost:3000 (Grafana)
3. http://localhost:5601 (Kibana)
4. http://localhost:15672 (RabbitMQ)

---

**Besoin d'aide pour exécuter ces commandes?** 🚀
