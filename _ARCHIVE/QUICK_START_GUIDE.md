════════════════════════════════════════════════════════════════════════════════
📚 GUIDE RAPIDE - ELASTICSEARCH, KIBANA & RABBITMQ
════════════════════════════════════════════════════════════════════════════════

════════════════════════════════════════════════════════════════════════════════
🔍 ELASTICSEARCH - CRÉER UN INDEX ET AJOUTER DES LOGS
════════════════════════════════════════════════════════════════════════════════

ÉTAPE 1: Ouvrez un terminal/PowerShell et exécutez:

────────────────────────────────────────────────────────────────────────────

# Créer l'index
curl -X PUT http://localhost:30920/education-logs -H "Content-Type: application/json" -d '{
  "settings": {"number_of_shards": 1, "number_of_replicas": 0},
  "mappings": {"properties": {
    "timestamp": {"type": "date"},
    "service": {"type": "keyword"},
    "level": {"type": "keyword"},
    "message": {"type": "text"}
  }}
}'

# Ajouter 5 logs
curl -X POST http://localhost:30920/education-logs/_doc -H "Content-Type: application/json" -d '{"timestamp":"2026-05-29T11:30Z","service":"user-service","level":"INFO","message":"Login successful"}'

curl -X POST http://localhost:30920/education-logs/_doc -H "Content-Type: application/json" -d '{"timestamp":"2026-05-29T11:31Z","service":"auth-service","level":"INFO","message":"Token generated"}'

curl -X POST http://localhost:30920/education-logs/_doc -H "Content-Type: application/json" -d '{"timestamp":"2026-05-29T11:32Z","service":"classroom-service","level":"ERROR","message":"Not found"}'

curl -X POST http://localhost:30920/education-logs/_doc -H "Content-Type: application/json" -d '{"timestamp":"2026-05-29T11:33Z","service":"activity-service","level":"INFO","message":"Activity logged"}'

curl -X POST http://localhost:30920/education-logs/_doc -H "Content-Type: application/json" -d '{"timestamp":"2026-05-29T11:34Z","service":"student-service","level":"INFO","message":"Profile updated"}'

════════════════════════════════════════════════════════════════════════════════
📊 KIBANA - CRÉER UN DASHBOARD
════════════════════════════════════════════════════════════════════════════════

ÉTAPE 1: Allez à http://localhost:30561

ÉTAPE 2: Créer Index Pattern
  1. Menu gauche → Stack Management (engrenage)
  2. Index Patterns → Create index pattern
  3. Name: education-logs
  4. Time field: timestamp
  5. Create pattern

ÉTAPE 3: Voir les logs (Discover)
  1. Menu gauche → Discover
  2. Sélectionnez "education-logs"
  3. Vous verrez tous les logs avec les colonnes:
     • timestamp
     • service (user-service, auth-service, etc.)
     • level (INFO, ERROR)
     • message

ÉTAPE 4: Créer une Visualization (graphique)
  1. Menu gauche → Visualizations → Create visualization
  2. Choisissez "Bar chart"
  3. Select data source: education-logs
  4. Vertical axis: Count
  5. Horizontal axis: Add → service
  6. Click "Update"
  
  RÉSULTAT: Graphique montrant combien de logs par service

ÉTAPE 5: Créer un Dashboard
  1. Menu gauche → Dashboards → Create new dashboard
  2. Click "Add from library"
  3. Sélectionnez votre visualization
  4. Save dashboard: "Education Logs"

════════════════════════════════════════════════════════════════════════════════
🐰 RABBITMQ - PUBLIER & CONSOMMER DES MESSAGES
════════════════════════════════════════════════════════════════════════════════

ÉTAPE 1: Allez à http://localhost:31672 (guest/guest)

ÉTAPE 2: Comprendre la structure
  • Allez à "Queues and Streams"
  • Vous verrez 3 queues:
    ✅ user.events
    ✅ activity.logs
    ✅ classroom.notifications

ÉTAPE 3: Publier des messages (Terminal)

────────────────────────────────────────────────────────────────────────────

# Message 1: User Created
curl -u guest:guest -H "content-type:application/json" -X POST \
  http://localhost:31672/api/exchanges/education/education.events/publish \
  -d '{
    "properties": {"delivery_mode": 2},
    "routing_key": "user.created",
    "payload": "{\"user_id\": \"user-789\", \"action\": \"created\"}",
    "payload_encoding": "string"
  }'

# Message 2: Classroom Created
curl -u guest:guest -H "content-type:application/json" -X POST \
  http://localhost:31672/api/exchanges/education/education.events/publish \
  -d '{
    "properties": {"delivery_mode": 2},
    "routing_key": "classroom.created",
    "payload": "{\"classroom_id\": \"class-456\", \"name\": \"Python 101\"}",
    "payload_encoding": "string"
  }'

# Message 3: Activity Log
curl -u guest:guest -H "content-type:application/json" -X POST \
  http://localhost:31672/api/exchanges/education/education.logs/publish \
  -d '{
    "properties": {"delivery_mode": 2},
    "routing_key": "activity",
    "payload": "{\"user_id\": \"user-789\", \"action\": \"viewed_lesson\"}",
    "payload_encoding": "string"
  }'

────────────────────────────────────────────────────────────────────────────

ÉTAPE 4: Vérifier les messages (RabbitMQ UI)
  1. Allez à http://localhost:31672 (guest/guest)
  2. Queues and Streams
  3. Cliquez sur "user.events"
  4. Vous verrez "Ready: 1" (1 message en attente)
  5. Cliquez "Get messages" → "Get Message(s)"
  6. VOUS VERREZ LE MESSAGE JSON

ÉTAPE 5: Consommer les messages (Optionnel - Python)

────────────────────────────────────────────────────────────────────────────

import pika
import json

# Setup
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
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_consume(queue='user.events', on_message_callback=process_message)
print('Attente de messages...')
channel.start_consuming()

════════════════════════════════════════════════════════════════════════════════
🎯 FLUX COMPLET D'UN ÉVÉNEMENT
════════════════════════════════════════════════════════════════════════════════

1. USER-SERVICE publie "user.created"
   ↓
2. RabbitMQ reçoit via education.events exchange
   ↓
3. RabbitMQ route vers user.events queue
   ↓
4. ACTIVITY-SERVICE consomme le message
   ↓
5. ACTIVITY-SERVICE crée un log:
   {"service":"activity-service","message":"User created","level":"INFO"}
   ↓
6. LOG est envoyé à Elasticsearch
   ↓
7. Elasticsearch indexe dans education-logs
   ↓
8. Kibana affiche dans le Dashboard
   ↓
✅ Vous voyez tout le flux en temps réel!

════════════════════════════════════════════════════════════════════════════════
✅ RÉSUMÉ - CE QUE VOUS AVEZ FAIRE
════════════════════════════════════════════════════════════════════════════════

ELASTICSEARCH (http://localhost:30920)
✅ Créez un index
✅ Indexez des logs
✅ Cherchez des logs

KIBANA (http://localhost:30561)
✅ Connectez-vous à Elasticsearch
✅ Créez un index pattern
✅ Visualisez les logs dans Discover
✅ Créez des graphiques et dashboards

RABBITMQ (http://localhost:31672)
✅ Publiez des messages
✅ Voyez les messages en queue
✅ Consommez les messages

════════════════════════════════════════════════════════════════════════════════
