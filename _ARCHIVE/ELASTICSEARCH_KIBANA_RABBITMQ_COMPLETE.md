════════════════════════════════════════════════════════════════════════════════
✅ ELASTICSEARCH, KIBANA & RABBITMQ - CONFIGURATION COMPLÈTE
════════════════════════════════════════════════════════════════════════════════

✅ TOUS LES SERVICES DÉPLOYÉS ET OPÉRATIONNELS
────────────────────────────────────────────────────────────────────────────────

════════════════════════════════════════════════════════════════════════════════
🔍 ELASTICSEARCH (Logging namespace)
════════════════════════════════════════════════════════════════════════════════

Pod: elasticsearch-5b6979568d-g6rxv
Status: 1/1 Running ✅
Namespace: logging
Port: 9200 (HTTP) / 9300 (Transport)
NodePort: 30920

URL d'accès:
  ├─ Internal: http://elasticsearch:9200
  ├─ External: http://localhost:30920
  └─ NodePort: http://10.1.13.151:9200

Configuration:
  ✅ Single-node cluster
  ✅ xpack.security: disabled (dev/test)
  ✅ Heap: 512m
  ✅ Persistence: 10Gi PVC
  ✅ Discovery type: single-node

════════════════════════════════════════════════════════════════════════════════
📊 KIBANA (Logging namespace)
════════════════════════════════════════════════════════════════════════════════

Pod: kibana-898d84dd4-r6b8x
Status: 1/1 Running ✅
Namespace: logging
Port: 5601 (HTTP)
NodePort: 30561

URL d'accès:
  ├─ Internal: http://kibana:5601
  ├─ External: http://localhost:30561
  └─ NodePort: http://10.1.13.150:5601

Configuration:
  ✅ Datasource: Elasticsearch (http://elasticsearch:9200)
  ✅ Version: 8.11.0
  ✅ Credentials: Default (no auth)
  ✅ Status endpoint: /api/status

════════════════════════════════════════════════════════════════════════════════
🐰 RABBITMQ (Message-queue namespace)
════════════════════════════════════════════════════════════════════════════════

Pod: rabbitmq-69f7ccddbf-d667d
Status: 1/1 Running ✅
Namespace: message-queue
Ports: 
  ├─ 5672 (AMQP)
  ├─ 15672 (Management UI)
  ├─ 4369 (EPMD)
  └─ 25672 (Clustering)

URL d'accès:
  AMQP (Message Broker):
    ├─ Internal: amqp://guest:guest@rabbitmq:5672
    ├─ External: amqp://guest:guest@localhost:30672
    └─ NodePort: amqp://guest:guest@10.1.13.187:5672

  Management UI:
    ├─ Internal: http://rabbitmq:15672
    ├─ External: http://localhost:31672
    └─ NodePort: http://10.1.13.187:15672

Configuration:
  ✅ Version: 3.12-management-alpine
  ✅ Default user: guest / guest
  ✅ VHosts: / (default), education
  ✅ Management plugin: enabled
  ✅ Kubernetes peer discovery: enabled

════════════════════════════════════════════════════════════════════════════════
📁 EXCHANGES CONFIGURÉS (RabbitMQ)
════════════════════════════════════════════════════════════════════════════════

VHost: education

Exchanges:
  1. education.events (type: topic, durable: yes)
     └─ Pour les événements d'application (user.*, classroom.*, etc.)

  2. education.logs (type: direct, durable: yes)
     └─ Pour les logs d'application (activity, errors, etc.)

════════════════════════════════════════════════════════════════════════════════
📋 QUEUES CONFIGURÉES (RabbitMQ)
════════════════════════════════════════════════════════════════════════════════

VHost: education

Queues:
  1. user.events (durable: yes)
     └─ Messages relatifs aux utilisateurs
     └─ Binding: education.events → routing_key: user.*

  2. activity.logs (durable: yes)
     └─ Logs d'activités
     └─ Binding: education.logs → routing_key: activity

  3. classroom.notifications (durable: yes)
     └─ Notifications de classe
     └─ Binding: education.events → routing_key: classroom.*

════════════════════════════════════════════════════════════════════════════════
🔌 FLUX DE DONNÉES
════════════════════════════════════════════════════════════════════════════════

ARCHITECTURE:

  Services Éducatifs                     Elasticsearch + Kibana
  (education namespace)                  (logging namespace)
        │                                       │
        │ Logs                                  │
        ├──────────────────────────────────────→ Elasticsearch
        │ (via Filebeat/Logstash)               │
        │                                       ├─→ Indexe les logs
        │                                       │
        │                                       └─→ Kibana visualise
        │
        │
    RabbitMQ
    (message-queue namespace)
        │
        ├─→ Exchanges: education.events, education.logs
        │
        ├─→ Queues: user.events, activity.logs, classroom.notifications
        │
        └─→ Consumers: Services éducatifs récupèrent les messages

════════════════════════════════════════════════════════════════════════════════
🚀 ACCÈS & UTILISATION
════════════════════════════════════════════════════════════════════════════════

1️⃣ ELASTICSEARCH
   URL: http://localhost:30920
   
   Commandes utiles:
   • Vérifier la santé: curl http://localhost:30920/_cluster/health
   • Lister les indices: curl http://localhost:30920/_cat/indices
   • Créer un index: 
     curl -X PUT http://localhost:30920/education-logs -H "Content-Type: application/json" \
       -d '{"settings":{"number_of_shards":1}}'

2️⃣ KIBANA
   URL: http://localhost:30561
   Login: Pas d'authentification (dev mode)
   
   Steps:
   1. Allez à http://localhost:30561
   2. Stack Management > Index Patterns
   3. Créez un pattern: education-*
   4. Allez à Discover pour voir les logs
   5. Créez des visualizations et dashboards

3️⃣ RABBITMQ Management
   URL: http://localhost:31672
   Login: guest / guest
   
   Steps:
   1. Allez à http://localhost:31672
   2. Onglet "Queues" → voir les 3 queues (user.events, activity.logs, etc.)
   3. Onglet "Exchanges" → voir les 2 exchanges
   4. Onglet "Admin" → créer users/vhosts supplémentaires
   5. Onglet "Connections" → voir les clients connectés

════════════════════════════════════════════════════════════════════════════════
📊 EXEMPLES D'UTILISATION
════════════════════════════════════════════════════════════════════════════════

✅ ELASTICSEARCH - Indexer un log:

curl -X POST http://localhost:30920/education-logs/_doc \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2026-05-29T11:00:00Z",
    "service": "user-service",
    "level": "INFO",
    "message": "User login successful",
    "user_id": "123"
  }'

✅ RABBITMQ - Publier un message:

curl -u guest:guest -H "content-type:application/json" \
  -X POST http://localhost:31672/api/exchanges/education/education.events/publish \
  -d '{
    "properties": {"delivery_mode": 2},
    "routing_key": "user.created",
    "payload": "{\"user_id\": \"123\", \"action\": \"created\"}",
    "payload_encoding": "string"
  }'

✅ RABBITMQ - Consommer un message (Python):

import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost', port=30672))
channel = connection.channel()

def callback(ch, method, properties, body):
    print(f"Message reçu: {body}")

channel.basic_consume(queue='user.events', on_message_callback=callback, auto_ack=True)
print('Attente de messages...')
channel.start_consuming()

════════════════════════════════════════════════════════════════════════════════
🔧 HEALTH CHECK
════════════════════════════════════════════════════════════════════════════════

Elasticsearch Status:
  curl http://localhost:30920/_cluster/health

Kibana Status:
  curl http://localhost:30561/api/status

RabbitMQ Status:
  kubectl exec -it pod/rabbitmq-69f7ccddbf-d667d -n message-queue -- rabbitmq-diagnostics ping

════════════════════════════════════════════════════════════════════════════════
📈 PROCHAINES ÉTAPES (OPTIONAL)
════════════════════════════════════════════════════════════════════════════════

1. Configurer les services éducatifs pour envoyer des logs à Elasticsearch
2. Configurer les services pour publier des messages dans RabbitMQ
3. Créer des dashboards Kibana pour visualiser les logs
4. Mettre en place des alertes Kibana
5. Configurer un Logstash/Filebeat pour parser les logs
6. Ajouter des consumers RabbitMQ pour traiter les messages

════════════════════════════════════════════════════════════════════════════════
✅ STATUS: ELASTICSEARCH, KIBANA & RABBITMQ OPÉRATIONNELS
════════════════════════════════════════════════════════════════════════════════

Elasticsearch: http://localhost:30920 ✅
Kibana:        http://localhost:30561 ✅
RabbitMQ:      http://localhost:31672 (guest/guest) ✅

All services running and configured!

════════════════════════════════════════════════════════════════════════════════
