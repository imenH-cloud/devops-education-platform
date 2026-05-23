# 📸 SCREENSHOTS CAPTURES - HORIZONS TSA DEVOPS

## ✅ STATUS: TOUS LES SERVICES ACTIFS ET ACCESSIBLES

```
✅ Prometheus:     http://localhost:30090     (RUNNING)
✅ Grafana:        http://localhost:30300     (RUNNING)
✅ Elasticsearch:  http://localhost:31200     (RUNNING)
✅ Kibana:         http://localhost:31601     (RUNNING)
✅ RabbitMQ:       http://localhost:32672     (RUNNING)
✅ ArgoCD:         https://localhost:32325    (RUNNING)
```

---

## 📋 INSTRUCTIONS DE CAPTURE MANUEL

### 🎯 5 minutes - Ouvre dans Chrome/Firefox les URLs suivantes:

```
Tab 1: http://localhost:30090              (Prometheus)
Tab 2: http://localhost:30300              (Grafana)
Tab 3: http://localhost:31601              (Kibana)
Tab 4: http://localhost:31200              (Elasticsearch)
Tab 5: http://localhost:32672              (RabbitMQ)
Tab 6: https://localhost:32325             (ArgoCD)
```

---

## 📸 PROMETHEUS - 2 SCREENSHOTS

### URL: http://localhost:30090

**Screenshot 1: HomePage**
- Affiche la page d'accueil
- Print Screen → Save as: `03_MONITORING/11_prometheus_home.png`

**Screenshot 2: Targets Status**
- Click "Status" → "Targets"
- Print Screen → Save as: `03_MONITORING/12_prometheus_targets.png`

---

## 📸 GRAFANA - 2 SCREENSHOTS

### URL: http://localhost:30300
### Login: admin / admin

**Screenshot 1: Dashboard**
- Login puis affiche main dashboard
- Print Screen → Save as: `03_MONITORING/11_grafana_alerts.png`

**Screenshot 2: Alerting**
- Menu → Alerting → Alert Rules
- Print Screen → Save as: `03_MONITORING/12_grafana_alerting_rules.png`

---

## 📸 ELASTICSEARCH - 2 SCREENSHOTS

### URL: http://localhost:31200

**Screenshot 1: Cluster Health (JSON)**
- Direct on: http://localhost:31200/_cluster/health
- Print Screen → Save as: `04_LOGGING/02_elasticsearch_health.png`

**Screenshot 2: Indices List (JSON)**
- Direct on: http://localhost:31200/_cat/indices?v
- Print Screen → Save as: `04_LOGGING/03_elasticsearch_indices_list.png`

---

## 📸 KIBANA - 3 SCREENSHOTS

### URL: http://localhost:31601

**Screenshot 1: Home Page**
- Access http://localhost:31601
- Print Screen → Save as: `04_LOGGING/04_kibana_home.png`

**Screenshot 2: Discover**
- Click "Discover" menu
- Select an index pattern
- Print Screen → Save as: `04_LOGGING/05_kibana_discover.png`

**Screenshot 3: Dashboards**
- Click "Dashboards"
- Show available dashboards
- Print Screen → Save as: `04_LOGGING/06_kibana_dashboards.png`

---

## 📸 RABBITMQ - 2 SCREENSHOTS

### URL: http://localhost:32672
### Login: guest / guest

**Screenshot 1: Overview**
- Login avec guest/guest
- Show Overview page
- Print Screen → Save as: `05_MESSAGE_QUEUE/02_rabbitmq_management.png`

**Screenshot 2: Queues**
- Click "Queues"
- Show all queues
- Print Screen → Save as: `05_MESSAGE_QUEUE/03_rabbitmq_queues.png`

---

## 📸 ARGOCD - 4 SCREENSHOTS

### URL: https://localhost:32325
### Login: admin / [get from secret]

**Get password:**
```powershell
kubectl -n gitops get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**Screenshot 1: Login Page**
- https://localhost:32325
- Print Screen → Save as: `08_GITOPS/08_argocd_login.png`

**Screenshot 2: Dashboard**
- After login
- Print Screen → Save as: `08_GITOPS/09_argocd_dashboard.png`

**Screenshot 3: Applications**
- Click "Applications"
- Print Screen → Save as: `08_GITOPS/10_argocd_applications.png`

**Screenshot 4: App Details**
- Click une application
- Print Screen → Save as: `08_GITOPS/11_argocd_app_details.png`

---

## 📊 RÉSUMÉ CAPTURES NÉCESSAIRES

| Service | Screenshots | Statut |
|---------|------------|--------|
| Prometheus | 2 | À capturer |
| Grafana | 2 | À capturer |
| Elasticsearch | 2 | À capturer |
| Kibana | 3 | À capturer |
| RabbitMQ | 2 | À capturer |
| ArgoCD | 4 | À capturer |
| **TOTAL** | **15** | **À FAIRE** |

---

## 🚀 APRÈS LES CAPTURES

1. Sauvegarde tous les fichiers PNG dans les bons dossiers
2. Exécute le script d'update rapport:

```powershell
.\update_rapport_with_screenshots.ps1
```

3. Génère le PDF final
4. Prêt pour la défense! 🎓

---

## 📝 CHECKLIST

- [ ] Tab 1 Prometheus chargée
- [ ] Tab 2 Grafana chargée  
- [ ] Tab 3 Kibana chargée
- [ ] Tab 4 Elasticsearch chargée
- [ ] Tab 5 RabbitMQ chargée
- [ ] Tab 6 ArgoCD chargée
- [ ] 15 screenshots capturées
- [ ] Fichiers dans les bons dossiers
- [ ] Rapport mis à jour
- [ ] PDF généré

**STATUS: READY FOR MANUAL CAPTURE** ✅
