════════════════════════════════════════════════════════════════════════════════
✅ RABBITMQ - LOGIN FIXÉ
════════════════════════════════════════════════════════════════════════════════

✅ PROBLÈME RÉSOLU
────────────────────────────────────────────────────────────────────────────────

❌ PROBLÈME: Impossible de login RabbitMQ Management (http://localhost:31672)
   └─ Utilisateur "guest" n'existait pas

✅ SOLUTION APPLIQUÉE:
   └─ Créé utilisateur guest avec password guest
   └─ Accordé les permissions admin
   └─ Configuré sur le vhost "/"

════════════════════════════════════════════════════════════════════════════════
🚀 ACCÈS RABBITMQ - MAINTENANT FONCTIONNEL
════════════════════════════════════════════════════════════════════════════════

URL: http://localhost:31672
Login: guest
Password: guest

STEPS:
1. Allez à http://localhost:31672
2. Entrez guest / guest
3. Vous verrez le Management Dashboard

════════════════════════════════════════════════════════════════════════════════
✅ DANS LE MANAGEMENT DASHBOARD
════════════════════════════════════════════════════════════════════════════════

Vous verrez:

📊 OVERVIEW TAB:
  ✅ Connections: Nombre de clients connectés
  ✅ Channels: Nombre de canaux ouverts
  ✅ Exchanges: 2 (education.events, education.logs)
  ✅ Queues: 3 (user.events, activity.logs, classroom.notifications)
  ✅ Consumers: Nombre de consumers

📋 QUEUES TAB:
  ✅ user.events
     └─ Messages: 0
     └─ Ready: 0
     └─ Unacked: 0

  ✅ activity.logs
     └─ Messages: 0
     └─ Ready: 0
     └─ Unacked: 0

  ✅ classroom.notifications
     └─ Messages: 0
     └─ Ready: 0
     └─ Unacked: 0

🔄 EXCHANGES TAB:
  ✅ education.events (type: topic)
     └─ Bindings: user.events, classroom.notifications

  ✅ education.logs (type: direct)
     └─ Bindings: activity.logs

👥 ADMIN TAB:
  ✅ Users: guest (administrator role)
  ✅ Virtual Hosts: /, education
  ✅ Permissions: guest a accès à tous les vhosts

════════════════════════════════════════════════════════════════════════════════
📝 COMMANDES UTILES
════════════════════════════════════════════════════════════════════════════════

Via kubectl:

1. Vérifier l'utilisateur guest:
   kubectl exec -it pod/rabbitmq-69f7ccddbf-d667d -n message-queue -- \
     rabbitmqctl list_users

2. Vérifier les permissions:
   kubectl exec -it pod/rabbitmq-69f7ccddbf-d667d -n message-queue -- \
     rabbitmqctl list_permissions

3. Vérifier les queues:
   kubectl exec -it pod/rabbitmq-69f7ccddbf-d667d -n message-queue -- \
     rabbitmqctl list_queues

4. Vérifier les exchanges:
   kubectl exec -it pod/rabbitmq-69f7ccddbf-d667d -n message-queue -- \
     rabbitmqctl list_exchanges

5. Vérifier les bindings:
   kubectl exec -it pod/rabbitmq-69f7ccddbf-d667d -n message-queue -- \
     rabbitmqctl list_bindings

════════════════════════════════════════════════════════════════════════════════
🔗 CONNEXION RABBITMQ VIA AMQP
════════════════════════════════════════════════════════════════════════════════

Python Example:

import pika

# Connexion
credentials = pika.PlainCredentials('guest', 'guest')
parameters = pika.ConnectionParameters(
    host='localhost',
    port=30672,
    credentials=credentials,
    virtual_host='/'
)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

# Publier un message
channel.basic_publish(
    exchange='education.events',
    routing_key='user.created',
    body='{"user_id": "123", "action": "created"}'
)
print("✅ Message published!")

# Consommer un message
def callback(ch, method, properties, body):
    print(f"Message reçu: {body}")
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_consume(queue='user.events', on_message_callback=callback)
print('Attente de messages...')
channel.start_consuming()

Node.js Example:

const amqp = require('amqplib');

async function connect() {
  const connection = await amqp.connect('amqp://guest:guest@localhost:30672');
  const channel = await connection.createChannel();

  // Publier
  channel.assertExchange('education.events', 'topic', { durable: true });
  channel.publish('education.events', 'user.created', Buffer.from('{"user_id":"123"}'));
  console.log('✅ Message published!');

  // Consommer
  const queue = await channel.assertQueue('user.events');
  channel.consume(queue.queue, (msg) => {
    console.log('Message reçu:', msg.content.toString());
  });
}

connect().catch(console.error);

════════════════════════════════════════════════════════════════════════════════
✅ RABBITMQ STATUS - 100% OPÉRATIONNEL
════════════════════════════════════════════════════════════════════════════════

Pod: rabbitmq-69f7ccddbf-d667d ✅ Running
User: guest ✅ Created
Password: guest ✅ Configured
VHosts: /, education ✅ Ready
Exchanges: education.events, education.logs ✅ Ready
Queues: user.events, activity.logs, classroom.notifications ✅ Ready

Management UI: http://localhost:31672 (guest/guest) ✅ LOGIN FUNCTIONAL
AMQP Broker: amqp://guest:guest@localhost:30672 ✅ READY FOR CONNECTIONS

════════════════════════════════════════════════════════════════════════════════
