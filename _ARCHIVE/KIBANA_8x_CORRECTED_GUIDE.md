════════════════════════════════════════════════════════════════════════════════
✅ KIBANA 8.x - GUIDE CORRIGÉ (Index Management)
════════════════════════════════════════════════════════════════════════════════

QU'EST-CE QUI A CHANGÉ?
  Kibana 8.x a renommé "Index Patterns" en "Data Views"
  Location: Stack Management > Data Views (pas Index Patterns)

════════════════════════════════════════════════════════════════════════════════
📊 KIBANA - CRÉER UNE DATA VIEW (Anciennement Index Pattern)
════════════════════════════════════════════════════════════════════════════════

ÉTAPE 1: Allez à http://localhost:30561

ÉTAPE 2: Aller à Data Views
  1. Menu gauche → Stack Management (engrenage)
  2. Sous "Data", vous verrez "Data Views"
  3. Cliquez sur "Data Views"

ÉTAPE 3: Créer une Data View
  1. Cliquez "Create data view" (bouton bleu)
  2. Dans "Index pattern": tapez "education-logs"
     (ou "education-logs*" pour wildcard)
  3. Dans "Timestamp field": sélectionnez "timestamp"
  4. Cliquez "Save data view to Kibana"

RÉSULTAT: ✅ Data view créée
  • Nom: education-logs
  • Timestamp: timestamp
  • Statut: Connected to Elasticsearch

════════════════════════════════════════════════════════════════════════════════
📋 KIBANA - VOIR LES LOGS (Discover)
════════════════════════════════════════════════════════════════════════════════

ÉTAPE 1: Allez à Discover
  1. Menu gauche → Discover
  2. En haut, sélectionnez "education-logs" (votre data view)
  3. Vous verrez TOUS LES LOGS:
     • timestamp
     • service
     • level
     • message

ÉTAPE 2: Filtrer les logs
  Exemple 1: Voir seulement ERROR logs
    1. Cliquez sur "level" à gauche
    2. Sélectionnez "ERROR"
    3. Vous verrez uniquement les ERRORs

  Exemple 2: Voir seulement user-service logs
    1. Cliquez sur "service" à gauche
    2. Sélectionnez "user-service"
    3. Vous verrez uniquement les user-service logs

ÉTAPE 3: Chercher un message spécifique
  1. Dans la barre "Search": tapez "login"
  2. Appuyez Entrée
  3. Kibana cherche dans tous les logs

════════════════════════════════════════════════════════════════════════════════
📈 KIBANA - CRÉER UNE VISUALIZATION (Graphique)
════════════════════════════════════════════════════════════════════════════════

ÉTAPE 1: Allez à Visualize
  1. Menu gauche → Visualizations
  2. Cliquez "Create new visualization"

ÉTAPE 2: Créer un graphique "Logs par Service"
  1. Sélectionnez "Bar chart" (graphique en barres)
  2. Sélectionnez "education-logs" (votre data view)
  3. Vous verrez un graphique vide

ÉTAPE 3: Configurer le graphique
  VERTICAL AXIS (Axe vertical):
    1. Cliquez "Metrics"
    2. Fonction: "Count"
  
  HORIZONTAL AXIS (Axe horizontal):
    1. Cliquez "Buckets"
    2. Aggregation: "Terms"
    3. Field: "service"
    4. Size: 10
  
  4. Cliquez "Update"

RÉSULTAT: ✅ Graphique en barres montrant:
  • user-service: 1 log
  • auth-service: 1 log
  • classroom-service: 1 log
  • activity-service: 1 log
  • student-service: 1 log

════════════════════════════════════════════════════════════════════════════════
📊 KIBANA - CRÉER UN DASHBOARD (Tableau de bord)
════════════════════════════════════════════════════════════════════════════════

ÉTAPE 1: Allez à Dashboards
  1. Menu gauche → Dashboards
  2. Cliquez "Create new dashboard"

ÉTAPE 2: Ajouter des visualizations
  1. Cliquez "Add" (en haut)
  2. Sélectionnez "Add existing"
  3. Cherchez votre visualization ("Logs par Service")
  4. Cliquez dessus

ÉTAPE 3: Redimensionner et organiser
  1. Glissez le graphique pour le placer
  2. Redimensionnez en tirant les coins

ÉTAPE 4: Sauvegarder
  1. Cliquez "Save" (en haut à droite)
  2. Name: "Education Platform - Logs Monitor"
  3. Cliquez "Save"

RÉSULTAT: ✅ Dashboard créé
  • Montre le graphique des logs par service
  • Rafraîchissement auto toutes les 5 secondes

════════════════════════════════════════════════════════════════════════════════
🔍 ELASTICSEARCH - ÉTAPES D'ABORD (SI PAS ENCORE FAIT)
════════════════════════════════════════════════════════════════════════════════

AVANT de créer une Data View, il faut créer l'index dans Elasticsearch.

ÉTAPE 1: Terminal - Créer l'index
```
curl -X PUT http://localhost:30920/education-logs \
  -H "Content-Type: application/json" \
  -d '{
    "settings": {"number_of_shards": 1, "number_of_replicas": 0},
    "mappings": {
      "properties": {
        "timestamp": {"type": "date"},
        "service": {"type": "keyword"},
        "level": {"type": "keyword"},
        "message": {"type": "text"}
      }
    }
  }'
```

ÉTAPE 2: Terminal - Ajouter des logs
```
curl -X POST http://localhost:30920/education-logs/_doc \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:30Z","service":"user-service","level":"INFO","message":"User login successful"}'

curl -X POST http://localhost:30920/education-logs/_doc \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:31Z","service":"auth-service","level":"INFO","message":"JWT token generated"}'

curl -X POST http://localhost:30920/education-logs/_doc \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:32Z","service":"classroom-service","level":"ERROR","message":"Classroom not found"}'

curl -X POST http://localhost:30920/education-logs/_doc \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:33Z","service":"activity-service","level":"INFO","message":"Activity logged"}'

curl -X POST http://localhost:30920/education-logs/_doc \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:34Z","service":"student-service","level":"INFO","message":"Profile updated"}'
```

ÉTAPE 3: Vérifier dans Elasticsearch
```
curl http://localhost:30920/education-logs/_search
```

════════════════════════════════════════════════════════════════════════════════
✅ MENU NAVIGATION - KIBANA 8.x
════════════════════════════════════════════════════════════════════════════════

Menu gauche (hamburger):

📊 ANALYTICS:
  ├─ Discover (voir les logs)
  ├─ Visualizations (créer des graphiques)
  └─ Dashboards (créer des tableaux de bord)

⚙️ STACK MANAGEMENT:
  ├─ Data Views (anciennement Index Patterns)
  ├─ Saved Objects
  ├─ Dev Tools
  └─ Etc.

════════════════════════════════════════════════════════════════════════════════
📝 RÉSUMÉ - ÉTAPES RAPIDES
════════════════════════════════════════════════════════════════════════════════

1. ELASTICSEARCH: Créer index + Ajouter 5 logs (Terminal)
2. KIBANA: Stack Management > Data Views > Create "education-logs"
3. KIBANA: Discover > Voir les logs
4. KIBANA: Visualizations > Créer graphique "Logs par Service"
5. KIBANA: Dashboards > Créer dashboard avec le graphique

RÉSULTAT: Dashboard en temps réel affichant les logs! ✅

════════════════════════════════════════════════════════════════════════════════
