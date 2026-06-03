════════════════════════════════════════════════════════════════════════════════
✅ CRÉER UN DASHBOARD COMPLET - GUIDE ÉTAPE PAR ÉTAPE
════════════════════════════════════════════════════════════════════════════════

VOUS ÊTES DÉJÀ DANS KIBANA AVEC UNE VISUALIZATION SAUVEGARDÉE ✅

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 1: CRÉER LE DASHBOARD
════════════════════════════════════════════════════════════════════════════════

1. Menu gauche → Dashboards
2. Cliquez "Create new dashboard"
3. Cliquez "Add" (en haut)
4. Sélectionnez "Add existing"
5. Cherchez "Event Activity Timeline"
6. Cliquez dessus pour l'ajouter
7. Resizez-la (glissez les coins)

RÉSULTAT: Dashboard avec 1 visualization ✅

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 2: CRÉER UNE 2ÈME VISUALIZATION (PIE CHART)
════════════════════════════════════════════════════════════════════════════════

1. Menu gauche → Visualizations → Create
2. Sélectionnez "Lens"
3. À gauche, glissez `agent.name` vers le centre
4. Cliquez le type de graphique en haut
5. Sélectionnez "Pie"
6. Cliquez "Save"
7. Titre: "Events by Agent"
8. Cliquez "Save and go to Dashboard"

RÉSULTAT: Pie chart montrant la distribution par agent ✅

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 3: CRÉER UNE 3ÈME VISUALIZATION (METRIC - NOMBRE TOTAL)
════════════════════════════════════════════════════════════════════════════════

1. Menu gauche → Visualizations → Create
2. Sélectionnez "Lens"
3. À gauche, glissez `@timestamp` vers le centre (une fois)
4. Le graphique affiche automatiquement un nombre
5. Cliquez "Save"
6. Titre: "Total Events (Last 24h)"
7. Cliquez "Save and go to Dashboard"

RÉSULTAT: Métrique montrant 2,613 ✅

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 4: CRÉER UNE 4ÈME VISUALIZATION (LINE CHART)
════════════════════════════════════════════════════════════════════════════════

1. Menu gauche → Visualizations → Create
2. Sélectionnez "Lens"
3. À gauche, glissez `@timestamp` vers le centre
4. Cliquez le type de graphique
5. Sélectionnez "Line"
6. Cliquez "Save"
7. Titre: "Activity Trend"
8. Cliquez "Save and go to Dashboard"

RÉSULTAT: Line chart montrant la tendance ✅

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 5: CRÉER UNE 5ÈME VISUALIZATION (HORIZONTAL BAR)
════════════════════════════════════════════════════════════════════════════════

1. Menu gauche → Visualizations → Create
2. Sélectionnez "Lens"
3. À gauche, glissez `aws.cloudtrail.event_type` vers le centre
4. Cliquez le type de graphique
5. Sélectionnez "Bar (horizontal)"
6. Cliquez "Save"
7. Titre: "Top Event Types"
8. Cliquez "Save and go to Dashboard"

RÉSULTAT: Bar chart horizontal montrant les top événements ✅

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 6: AJOUTER TOUTES LES VISUALIZATIONS AU DASHBOARD
════════════════════════════════════════════════════════════════════════════════

1. Menu gauche → Dashboards
2. Cliquez "Create new dashboard"
3. Cliquez "Add"
4. Sélectionnez "Add existing"
5. Cherchez et ajoutez:
   • Event Activity Timeline
   • Events by Agent
   • Total Events (Last 24h)
   • Activity Trend
   • Top Event Types

RÉSULTAT: Dashboard avec 5 visualizations! ✅

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 7: ORGANISER LE DASHBOARD
════════════════════════════════════════════════════════════════════════════════

1. Glissez et resizez les visualizations
   • Top: Total Events (métrique)
   • Gauche: Events by Agent (Pie)
   • Droite: Activity Trend (Line)
   • Bas: Event Activity Timeline (Bar)
   • Bas: Top Event Types (Horizontal Bar)

2. Cliquez "Save" (en haut à droite)
3. Titre: "Education Platform - Event Monitoring"
4. Cliquez "Save dashboard"

RÉSULTAT: Dashboard professionnel! ✅

════════════════════════════════════════════════════════════════════════════════
🎉 RÉSULTAT FINAL
════════════════════════════════════════════════════════════════════════════════

DASHBOARD AVEC 5 VISUALIZATIONS:

┌─────────────────────────────────────────────────────────────┐
│         Total Events: 2,613                                 │
├──────────────────────┬──────────────────────────────────────┤
│  Events by Agent     │  Activity Trend (Line Chart)         │
│  (Pie Chart)         │  (Showing activity over time)        │
├──────────────────────┴──────────────────────────────────────┤
│  Event Activity Timeline (Bar Chart - per 30 sec)           │
├───────────────────────────────────────────────────────────── │
│  Top Event Types (Horizontal Bar Chart)                     │
└─────────────────────────────────────────────────────────────┘

════════════════════════════════════════════════════════════════════════════════
✅ VOUS AVEZ UN DASHBOARD COMPLET!
════════════════════════════════════════════════════════════════════════════════

Accès: http://localhost:30561 > Menu > Dashboards > "Education Platform - Event Monitoring"

Vous pouvez maintenant:
✅ Voir les logs en temps réel
✅ Analyser les tendances
✅ Identifier les anomalies
✅ Filtrer par dates/services
✅ Exporter les données

════════════════════════════════════════════════════════════════════════════════
