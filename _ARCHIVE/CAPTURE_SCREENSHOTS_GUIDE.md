# 📸 CAPTURE SCREENSHOTS MANQUANTS - GUIDE RAPIDE

## 🎯 OBJECTIF: 19 screenshots à capturer (30-40 min)

---

## ✅ AVANT DE COMMENCER

```powershell
# Vérifier que le cluster est actif
kubectl get nodes

# Vérifier les namespaces
kubectl get namespaces

# Afficher les services
kubectl get svc -A | grep -E "prometheus|grafana|elasticsearch|kibana|rabbitmq|argocd"
```

---

## 📋 ÉTAPE 1: LANCER LES PORT-FORWARDS (5 min)

Ouvre **6 PowerShell/Terminal** séparés:

### Terminal 1: Prometheus
```powershell
kubectl port-forward -n monitoring svc/prometheus 9090:9090
```
Wait for: `Forwarding from 127.0.0.1:9090 -> 9090`

### Terminal 2: Grafana
```powershell
kubectl port-forward -n monitoring svc/grafana 3000:3000
```

### Terminal 3: Kibana
```powershell
kubectl port-forward -n logging svc/kibana 5601:5601
```

### Terminal 4: Elasticsearch
```powershell
kubectl port-forward -n logging svc/elasticsearch 9200:9200
```

### Terminal 5: RabbitMQ
```powershell
kubectl port-forward -n message-queue svc/rabbitmq 15672:15672
```

### Terminal 6: ArgoCD
```powershell
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

---

## 📸 ÉTAPE 2: CAPTURER KIBANA (5 min - 5 screenshots)

### URL: http://localhost:5601

**Screenshot 1: Kibana Home**
1. Accès direct: http://localhost:5601
2. Attends le chargement
3. Print Screen + Save as: `04_LOGGING/01_kibana_home.png`

**Screenshot 2: Discover Page**
1. Click menu "Discover"
2. Sélectionne un index (e.g., "logs-*")
3. Print Screen + Save as: `04_LOGGING/02_kibana_discover.png`

**Screenshot 3: Sample Logs**
1. Expand une ligne de log
2. Affiche les détails complets
3. Print Screen + Save as: `04_LOGGING/03_kibana_log_details.png`

**Screenshot 4: Dashboards List**
1. Click menu "Dashboards"
2. Affiche la liste disponible
3. Print Screen + Save as: `04_LOGGING/04_kibana_dashboards.png`

**Screenshot 5: View Dashboard (if exists)**
1. Sélectionne un dashboard
2. Print Screen + Save as: `04_LOGGING/05_kibana_dashboard_view.png`

---

## 📸 ÉTAPE 3: ELASTICSEARCH (3 min - 2 screenshots)

### URL: http://localhost:9200

**Screenshot 1: Cluster Health**
1. Accès: http://localhost:9200/_cluster/health
2. Copy dans navigateur, affiche JSON
3. Print Screen + Save as: `04_LOGGING/06_elasticsearch_health.json.png`

**Screenshot 2: Nodes Info**
1. Accès: http://localhost:9200/_nodes
2. Affiche la structure JSON avec nodes
3. Print Screen + Save as: `04_LOGGING/07_elasticsearch_nodes.json.png`

---

## 📸 ÉTAPE 4: GRAFANA - ALERTING (5 min - 3 screenshots)

### URL: http://localhost:3000
### Login: admin / admin

**Screenshot 1: Alerting Rules**
1. Menu → Alerting → Alert Rules
2. Affiche toutes les règles d'alerte
3. Print Screen + Save as: `03_MONITORING/10_grafana_alerting_rules.png`

**Screenshot 2: Alert History**
1. Menu → Alerting → Notification policies (ou Alert instances)
2. Affiche l'historique
3. Print Screen + Save as: `03_MONITORING/11_grafana_alert_history.png`

**Screenshot 3: Notification Channels** (if configured)
1. Menu → Alerting → Contact points
2. Print Screen + Save as: `03_MONITORING/12_grafana_notification_channels.png`

---

## 📸 ÉTAPE 5: PROMETHEUS - TARGETS (2 min - 1 screenshot)

### URL: http://localhost:9090

**Screenshot 1: Targets**
1. Click "Status" dropdown → "Targets"
2. Affiche tous les targets (UP/DOWN)
3. Print Screen + Save as: `03_MONITORING/13_prometheus_targets.png`

---

## 📸 ÉTAPE 6: ARGOCD (15 min - 6 screenshots)

### URL: https://localhost:8080
### Login: admin / [password from secret]

**Get ArgoCD Password (if needed):**
```powershell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**Screenshot 1: Login Page**
1. https://localhost:8080
2. Print Screen + Save as: `08_GITOPS/08_argocd_login.png`

**Screenshot 2: Dashboard After Login**
1. After login - main page
2. Print Screen + Save as: `08_GITOPS/09_argocd_main_dashboard.png`

**Screenshot 3: Applications List**
1. Click "Applications" menu
2. Affiche toutes les apps déployées
3. Print Screen + Save as: `08_GITOPS/10_argocd_applications_list.png`

**Screenshot 4: Application Details**
1. Sélectionne une application (e.g., "education-service")
2. Affiche topology, sync status, etc.
3. Print Screen + Save as: `08_GITOPS/11_argocd_app_details.png`

**Screenshot 5: Sync Status**
1. Dans l'app details, affiche sync status
2. Affiche "Synced" ou "OutOfSync"
3. Print Screen + Save as: `08_GITOPS/12_argocd_sync_status.png`

**Screenshot 6: Deployment History**
1. Onglet "History" dans l'app
2. Affiche tous les déploiements antérieurs
3. Print Screen + Save as: `08_GITOPS/13_argocd_deployment_history.png`

---

## 📁 DOSSIER CIBLE

Tous les fichiers doivent aller dans: `./RAPPORT/scrennPFE_ORGANIZED/`

```
./RAPPORT/scrennPFE_ORGANIZED/
├── 03_MONITORING/
│   ├── 10_grafana_alerting_rules.png
│   ├── 11_grafana_alert_history.png
│   ├── 12_grafana_notification_channels.png
│   └── 13_prometheus_targets.png
│
├── 04_LOGGING/
│   ├── 01_kibana_home.png
│   ├── 02_kibana_discover.png
│   ├── 03_kibana_log_details.png
│   ├── 04_kibana_dashboards.png
│   ├── 05_kibana_dashboard_view.png
│   ├── 06_elasticsearch_health.json.png
│   └── 07_elasticsearch_nodes.json.png
│
└── 08_GITOPS/
    ├── 08_argocd_login.png
    ├── 09_argocd_main_dashboard.png
    ├── 10_argocd_applications_list.png
    ├── 11_argocd_app_details.png
    ├── 12_argocd_sync_status.png
    └── 13_argocd_deployment_history.png
```

---

## ⏱️ TIMELINE ESTIMÉE

| Étape | Durée | Tâche |
|-------|-------|-------|
| 1 | 5 min | Port-forwards |
| 2 | 5 min | Kibana (5 screenshots) |
| 3 | 3 min | Elasticsearch (2 screenshots) |
| 4 | 5 min | Grafana Alerting (3 screenshots) |
| 5 | 2 min | Prometheus Targets (1 screenshot) |
| 6 | 15 min | ArgoCD (6 screenshots) |
| **TOTAL** | **35 min** | **19 screenshots** |

---

## ✅ APRÈS LA CAPTURE

1. **Vérifier les fichiers:**
   ```powershell
   Get-ChildItem -Path ".\RAPPORT\scrennPFE_ORGANIZED" -Recurse | Measure-Object | select Count
   ```

2. **Ajouter au rapport:**
   - Ouvre: `./RAPPORT_PFE_FINAL_IMEN_HAMADA_2025.md`
   - Ajoute les images aux sections appropriées
   - Ajoute des captions descriptives

3. **Générer PDF:**
   - Utilise Pandoc ou Typora pour convertir en PDF
   - Vérifie que toutes les images s'affichent

4. **Test final:**
   - Imprime une copie
   - Simule une défense
   - Prépare les questions potentielles

---

## 🎯 POINTS À METTRE EN AVANT DANS LES SCREENSHOTS

**Kibana:**
- Logs en temps réel
- Index patterns
- Dashboards aggregés
- Queries avancées

**Elasticsearch:**
- Cluster health status
- Nombre de nodes
- Shards distribution

**Grafana Alerting:**
- Règles d'alerte basées sur métriques
- Thresholds et conditions
- Notification channels

**Prometheus:**
- Targets actifs
- Status des scrapers
- UP/DOWN indicators

**ArgoCD:**
- Applications synchronized
- Sync status (Synced/OutOfSync)
- Deployment history
- Git repository link

---

## 🚀 COMMANDES UTILES

**Vérifie services actifs:**
```powershell
kubectl get svc -A --field-selector metadata.namespace=monitoring,logging,message-queue
```

**Vérifie logs d'erreur:**
```powershell
kubectl logs -n logging -l app=kibana
kubectl logs -n logging -l app=elasticsearch
kubectl logs -n monitoring -l app=prometheus
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

**Redémarrer un service (if needed):**
```powershell
kubectl rollout restart deployment/grafana -n monitoring
```

---

## 📝 NOTES IMPORTANTES

1. **Timing:**
   - Kibana/Elasticsearch: peut être lent au premier accès (~10 sec)
   - ArgoCD: demande authentification, avoir le password prêt
   - Prometheus/Grafana: généralement rapides

2. **Qualité des screenshots:**
   - Utilise Print Screen (captures l'écran entier)
   - Snipping Tool pour précision
   - Format PNG (1920x1080 minimum)

3. **Données manquantes:**
   - Si Kibana affiche "No data", c'est normal (dépend des logs)
   - Si ArgoCD affiche "OutOfSync", c'est aussi intéressant pour montrer la fonctionnalité

4. **Défaillances possibles:**
   - Service pas accessible: vérifier le port-forward
   - 404 error: attendre le chargement complet
   - Timeout: augmenter le timeout du port-forward

---

## 🎓 APRÈS LES SCREENSHOTS

**Rapport mise à jour:**

Tu dois avoir:
- ✅ 43 screenshots existants (organisés)
- ✅ 19 screenshots nouveaux (capturés)
- = **62 screenshots total** 🎉

**Prochaine étape:**
```markdown
## 8. RÉSULTATS ET VALIDATION

### 8.1 Infrastructure
### 8.2 Monitoring
### 8.3 Logging
### 8.4 Message Queue
### 8.5 Cache
### 8.6 CI/CD
### 8.7 GitOps
### 8.8 Application
```

---

**GOOD LUCK! Tu es presque à la fin!** 🚀

**Start: First terminal with port-forward!**
