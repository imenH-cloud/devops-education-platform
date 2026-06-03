════════════════════════════════════════════════════════════════════════════════
📚 GUIDE COMPLET - ELASTICSEARCH, KIBANA & RABBITMQ
════════════════════════════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════════════════════════
🔍 ELASTICSEARCH - GUIDE DÉTAILLÉ
═══════════════════════════════════════════════════════════════════════════════

✅ CE QUE VOUS VOYEZ:
  {
    "name" : "elasticsearch-5b6979568d-g6rxv",  ← Nom du noeud
    "cluster_name" : "docker-cluster",           ← Cluster
    "version" : "8.5.3"                          ← Version Elasticsearch
  }

C'EST QUOI ELASTICSEARCH?
  • Base de données SEARCH (moteur de recherche)
  • Stocke des LOGS, des DOCUMENTS JSON
  • Indexe pour recherches ultra-rapides
  • Comme Google pour vos données

QUÉ POUVEZ-VOUS FAIRE?
  1. Indexer des logs de vos services
  2. Chercher les logs (par date, par service, par niveau)
  3. Analyser les données (statistiques, trends)
  4. Créer des dashboards dans Kibana

════════════════════════════════════════════════════════════════════════════════
📝 ELASTICSEARCH - TÂCHES PRATIQUES
════════════════════════════════════════════════════════════════════════════════

TÂCHE 1: Créer un INDEX (container pour les logs)
────────────────────────────────────────────────────

Commande:
  curl -X PUT http://localhost:30920/education-logs-2026.05.29 \
    -H "Content-Type: application/json" \
    -d '{
      "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 0
      },
      "mappings": {
        "properties": {
          "timestamp": {"type": "date"},
          "service": {"type": "keyword"},
          "level": {"type": "keyword"},
          "message": {"type": "text"},
          "user_id": {"type": "keyword"}
        }
      }
    }'

Résultat: INDEX CRÉÉ ✅

────────────────────────────────────────────────────────────────────────────

TÂCHE 2: Indexer un LOG (ajouter un document)
──────────────────────────────────────────────

Commande:
  curl -X POST http://localhost:30920/education-logs-2026.05.29/_doc \
    -H "Content-Type: application/json" \
    -d '{
      "timestamp": "2026-05-29T11:30:00Z",
      "service": "user-service",
      "level": "INFO",
      "message": "User login successful",
      "user_id": "user-123"
    }'

Résultat: LOG CRÉÉ ✅
  _id: "ABC123"
  _index: "education-logs-2026.05.29"

────────────────────────────────────────────────────────────────────────────

TÂCHE 3: Ajouter plus de LOGS (simulation réelle)
──────────────────────────────────────────────────

Logs à insérer:

1. User Service - Login
  curl -X POST http://localhost:30920/education-logs-2026.05.29/_doc \
    -H "Content-Type: application/json" \
    -d '{"timestamp":"2026-05-29T11:30:00Z","service":"user-service","level":"INFO","message":"User login successful","user_id":"user-456"}'

2. Auth Service - Authentication
  curl -X POST http://localhost:30920/education-logs-2026.05.29/_doc \
    -H "Content-Type: application/json" \
    -d '{"timestamp":"2026-05-29T11:31:00Z","service":"auth-service","level":"INFO","message":"JWT token generated","user_id":"user-456"}'

3. Classroom Service - ERROR
  curl -X POST http://localhost:30920/education-logs-2026.05.29/_doc \
    -H "Content-Type: application/json" \
    -d '{"timestamp":"2026-05-29T11:32:00Z","service":"classroom-service","level":"ERROR","message":"Classroom not found","user_id":"user-456"}'

4. Activity Service - Log Activity
  curl -X POST http://localhost:30920/education-logs-2026.05.29/_doc \
    -H "Content-Type: application/json" \
    -d '{"timestamp":"2026-05-29T11:33:00Z","service":"activity-service","level":"INFO","message":"Activity logged: user viewed lesson","user_id":"user-456"}'

5. Student Service - Update
  curl -X POST http://localhost:30920/education-logs-2026.05.29/_doc \
    -H "Content-Type: application/json" \
    -d '{"timestamp":"2026-05-29T11:34:00Z","service":"student-service","level":"INFO","message":"Student profile updated","user_id":"user-456"}'

────────────────────────────────────────────────────────────────────────────

TÂCHE 4: CHERCHER les logs (par service)
──────────────────────────────────────────

Chercher tous les logs du user-service:

  curl -X GET http://localhost:30920/education-logs-2026.05.29/_search \
    -H "Content-Type: application/json" \
    -d '{
      "query": {
        "match": {
          "service": "user-service"
        }
      }
    }'

Résultat: 1 log trouvé (User login successful)

────────────────────────────────────────────────────────────────────────────

TÂCHE 5: Chercher les ERREURS
────────────────────────────────

  curl -X GET http://localhost:30920/education-logs-2026.05.29/_search \
    -H "Content-Type: application/json" \
    -d '{
      "query": {
        "match": {
          "level": "ERROR"
        }
      }
    }'

Résultat: 1 ERROR trouvée (Classroom not found)

════════════════════════════════════════════════════════════════════════════════
📊 KIBANA - GUIDE DÉTAILLÉ
════════════════════════════════════════════════════════════════════════════════

QU'EST-CE QUE KIBANA?
  • Interface VISUELLE pour Elasticsearch
  • Voir les logs dans des graphiques jolis
  • Créer des dashboards
  • Analyser les data en temps réel

════════════════════════════════════════════════════════════════════════════════
📝 KIBANA - TÂCHES PRATIQUES
════════════════════════════════════════════════════════════════════════════════

TÂCHE 1: Créer un INDEX PATTERN (connecter Kibana à Elasticsearch)
──────────────────────────────────────────────────────────────────

STEPS:
  1. Allez à http://localhost:30561
  2. Menu de gauche → "Stack Management" (icône rouage)
  3. Sélectionnez "Index Patterns"
  4. Cliquez "Create index pattern"
  5. Dans le champ "Index pattern name": entrez "education-logs-*"
     (Le * = wildcard, accepte education-logs-2026.05.29, etc.)
  6. Cliquez "Next step"
  7. Dans "Time field": sélectionnez "timestamp"
  8. Cliquez "Create index pattern"

RÉSULTAT: ✅ Kibana peut maintenant voir tous les logs Elasticsearch

────────────────────────────────────────────────────────────────────────────

TÂCHE 2: Voir les LOGS (Discover)
───────────────────────────────────

STEPS:
  1. Menu de gauche → "Discover"
  2. En haut, vérifiez le time range (choisissez "Last 24 hours")
  3. Vous verrez tous les logs indexés:
     • timestamp
     • service (user-service, auth-service, etc.)
     • level (INFO, ERROR, WARNING)
     • message
     • user_id

  4. Pour FILTRER:
     • Cliquez sur "service" à gauche
     • Sélectionnez "user-service"
     • Vous ne verrez que les logs du user-service

────────────────────────────────────────────────────────────────────────────

TÂCHE 3: Créer une VISUALIZATION (graphique)
──────────────────────────────────────────────

STEPS:
  1. Menu de gauche → "Visualizations"
  2. Cliquez "Create visualization"
  3. Sélectionnez "Bar chart"
  4. En bas, cliquez "education-logs-*"
  5. Vertical axis: "Count"
  6. Horizontal axis: "service"
  7. Cliquez "Update"

RÉSULTAT: ✅ Graphique montrant combien de logs par service
  • user-service: 1 log
  • auth-service: 1 log
  • classroom-service: 1 log
  • activity-service: 1 log
  • student-service: 1 log

────────────────────────────────────────────────────────────────────────────

TÂCHE 4: Créer un DASHBOARD (tableau de bord)
───────────────────────────────────────────────

STEPS:
  1. Menu de gauche → "Dashboards"
  2. Cliquez "Create new dashboard"
  3. Cliquez "Add from library"
  4. Sélectionnez la visualization que vous avez créée
  5. Cliquez "Save"
  6. Donnez un nom: "Education Platform - Activity Monitor"
  7. Cliquez "Save"

RÉSULTAT: ✅ Dashboard avec votre graphique
  • Vous voyez les logs en temps réel
  • Rafraîchissement automatique toutes les 5 secondes

════════════════════════════════════════════════════════════════════════════════
🐰 RABBITMQ - GUIDE DÉTAILLÉ
════════════════════════════════════════════════════════════════════════════════

QU'EST-CE QUE RABBITMQ?
  • MESSAGE BROKER (courtier de messages)
  • Permet aux services de communiquer
  • Publisher → Message → Queue → Consumer
  • Comme un système de courrier électronique pour les services

CONCEPTS CLÉS:
  1. EXCHANGE: Reçoit les messages (routeur)
  2. QUEUE: Stocke les messages (boîte aux lettres)
  3. BINDING: Connecte exchange à queue (adresse postale)
  4. PUBLISHER: Envoie des messages
  5. CONSUMER: Reçoit et traite les messages

════════════════════════════════════════════════════════════════════════════════
📝 RABBITMQ - TÂCHES PRATIQUES
════════════════════════════════════════════════════════════════════════════════

TÂCHE 1: Comprendre la STRUCTURE (Management UI)
─────────────────────────────────────────────────

STEPS:
  1. Allez à http://localhost:31672 (guest/guest)
  2. Cliquez "Queues and Streams"
  
  VOUS VERREZ 3 QUEUES:
    ✅ user.events
       └─ Reçoit les messages: user.created, user.updated, user.deleted
    
    ✅ activity.logs
       └─ Reçoit les messages: activity.logged
    
    ✅ classroom.notifications
       └─ Reçoit les messages: classroom.created, classroom.updated

  3. Cliquez "Exchanges"
  
  VOUS VERREZ 2 EXCHANGES:
    ✅ education.events (topic)
       └─ Routes les messages user.* vers user.events
       └─ Routes les messages classroom.* vers classroom.notifications
    
    ✅ education.logs (direct)
       └─ Routes les messages activity vers activity.logs

────────────────────────────────────────────────────────────────────────────

TÂCHE 2: Publier un MESSAGE (envoyer un message)
────────────────────────────────────────────────

Scénario: Un utilisateur se connecte, publier l'événement

Commande:
  curl -u guest:guest -H "content-type:application/json" \
    -X POST http://localhost:31672/api/exchanges/education/education.events/publish \
    -d '{
      "properties": {"delivery_mode": 2},
      "routing_key": "user.created",
      "payload": "{\"user_id\": \"user-789\", \"name\": \"Ahmed\", \"email\": \"ahmed@education.com\"}",
      "payload_encoding": "string"
    }'

RÉSULTAT: ✅ Message envoyé à la queue "user.events"

VÉRIFICATION (Management UI):
  1. Allez à http://localhost:31672
  2. Cliquez "Queues and Streams"
  3. Cliquez "user.events"
  4. Vous verrez:
     • Ready: 1 (un message en attente)
     • Messages: 1

────────────────────────────────────────────────────────────────────────────

TÂCHE 3: Publier PLUSIEURS MESSAGES (simulation réelle)
────────────────────────────────────────────────────────

1. Événement USER CREATED:
  curl -u guest:guest -H "content-type:application/json" \
    -X POST http://localhost:31672/api/exchanges/education/education.events/publish \
    -d '{"properties":{"delivery_mode":2},"routing_key":"user.created","payload":"{\"user_id\":\"user-789\",\"action\":\"created\"}","payload_encoding":"string"}'

2. Événement CLASSROOM CREATED:
  curl -u guest:guest -H "content-type:application/json" \
    -X POST http://localhost:31672/api/exchanges/education/education.events/publish \
    -d '{"properties":{"delivery_mode":2},"routing_key":"classroom.created","payload":"{\"classroom_id\":\"class-456\",\"name\":\"Python 101\"}","payload_encoding":"string"}'

3. Log ACTIVITY:
  curl -u guest:guest -H "content-type:application/json" \
    -X POST http://localhost:31672/api/exchanges/education/education.logs/publish \
    -d '{"properties":{"delivery_mode":2},"routing_key":"activity","payload":"{\"user_id\":\"user-789\",\"action\":\"viewed_lesson\"}","payload_encoding":"string"}'

RÉSULTAT: ✅ Messages dans les queues
  • user.events: 1 message (user created)
  • classroom.notifications: 1 message (classroom created)
  • activity.logs: 1 message (activity logged)

────────────────────────────────────────────────────────────────────────────

TÂCHE 4: Consommer un MESSAGE (recevoir et traiter)
─────────────────────────────────────────────────────

Via Management UI (simple):
  1. Allez à http://localhost:31672
  2. Cliquez "Queues and Streams"
  3. Cliquez "user.events"
  4. Cliquez "Get messages" (en bas)
  5. Cliquez "Get Message(s)"
  6. VOUS VERREZ LE MESSAGE:
     {"user_id":"user-789","action":"created"}

Via Python (pour les services réels):

import pika
import json

# Connexion
credentials = pika.PlainCredentials('guest', 'guest')
parameters = pika.ConnectionParameters(
    host='localhost',
    port=30672,
    credentials=credentials,
    virtual_host='education'
)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

# Consommer
def process_message(ch, method, properties, body):
    message = json.loads(body)
    print(f"✅ Message reçu: {message}")
    
    # Traiter le message
    user_id = message.get('user_id')
    action = message.get('action')
    print(f"   → User {user_id} {action}")
    
    # Confirmer réception
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_consume(queue='user.events', on_message_callback=process_message)
print('🔴 Consumer en attente de messages...')
channel.start_consuming()

RÉSULTAT: ✅ Consumer traite les messages
  ✅ Message reçu: {'user_id': 'user-789', 'action': 'created'}
     → User user-789 created

════════════════════════════════════════════════════════════════════════════════
🎯 FLUX COMPLET - DE BOUT EN BOUT
════════════════════════════════════════════════════════════════════════════════

SCÉNARIO: Un utilisateur se connecte

1️⃣ USER SERVICE publie un événement:
   "user.login" → education.events exchange

2️⃣ RabbitMQ route vers user.events queue

3️⃣ ACTIVITY SERVICE consomme et log:
   Envoie un message vers education.logs

4️⃣ RabbitMQ route vers activity.logs queue

5️⃣ LOGGING SERVICE consomme et indexe:
   Envoie le log à Elasticsearch

6️⃣ Elasticsearch indexe dans education-logs-*

7️⃣ KIBANA affiche le log:
   Dashboard montre "1 login activity"

RÉSULTAT: Traçabilité complète du flux utilisateur! ✅

════════════════════════════════════════════════════════════════════════════════
✅ RÉSUMÉ - QUE VOUS AVEZ
════════════════════════════════════════════════════════════════════════════════

✅ ELASTICSEARCH
   └─ Moteur de recherche pour les logs
   └─ Stocke les logs JSON indexés
   └─ Cherche ultra-rapide (ms)

✅ KIBANA
   └─ Interface visuelle pour Elasticsearch
   └─ Dashboards pour voir les logs
   └─ Alertes et analyses

✅ RABBITMQ
   └─ Message broker pour communication entre services
   └─ Queues pour asynchrone messaging
   └─ Garantit livraison des messages

════════════════════════════════════════════════════════════════════════════════
