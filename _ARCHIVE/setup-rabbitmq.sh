#!/bin/bash

# RabbitMQ Setup Script
echo "════════════════════════════════════════════════════════════════════════════════"
echo "🐰 RABBITMQ - AUTO SETUP"
echo "════════════════════════════════════════════════════════════════════════════════"

RMQ_URL="http://localhost:31672/api"
CREDENTIALS="guest:guest"

# 1. Vérifier la connexion
echo -e "\n1️⃣ Vérifier la connexion RabbitMQ"
curl -s -u $CREDENTIALS "$RMQ_URL/overview" | jq '.rabbitmq_version' > /dev/null && echo "✅ Connecté" || echo "❌ Erreur"

# 2. Publier des messages
echo -e "\n2️⃣ Publier des MESSAGES"

echo "   • Message 1: USER CREATED"
curl -s -u $CREDENTIALS -H "content-type:application/json" \
  -X POST "$RMQ_URL/exchanges/education/education.events/publish" \
  -d '{"properties":{"delivery_mode":2},"routing_key":"user.created","payload":"{\"user_id\":\"user-789\",\"name\":\"Ahmed\"}","payload_encoding":"string"}' > /dev/null

echo "   • Message 2: CLASSROOM CREATED"
curl -s -u $CREDENTIALS -H "content-type:application/json" \
  -X POST "$RMQ_URL/exchanges/education/education.events/publish" \
  -d '{"properties":{"delivery_mode":2},"routing_key":"classroom.created","payload":"{\"classroom_id\":\"class-456\",\"name\":\"Python 101\"}","payload_encoding":"string"}' > /dev/null

echo "   • Message 3: ACTIVITY LOG"
curl -s -u $CREDENTIALS -H "content-type:application/json" \
  -X POST "$RMQ_URL/exchanges/education/education.logs/publish" \
  -d '{"properties":{"delivery_mode":2},"routing_key":"activity","payload":"{\"user_id\":\"user-789\",\"action\":\"viewed_lesson\"}","payload_encoding":"string"}' > /dev/null

echo "✅ 3 messages publiés"

# 3. Vérifier les queues
echo -e "\n3️⃣ Vérifier les QUEUES"

USER_EVENTS=$(curl -s -u $CREDENTIALS "$RMQ_URL/queues/education/user.events" | jq '.messages')
ACTIVITY_LOGS=$(curl -s -u $CREDENTIALS "$RMQ_URL/queues/education/activity.logs" | jq '.messages')
CLASS_NOTIFY=$(curl -s -u $CREDENTIALS "$RMQ_URL/queues/education/classroom.notifications" | jq '.messages')

echo "   ✅ user.events: $USER_EVENTS messages"
echo "   ✅ activity.logs: $ACTIVITY_LOGS messages"
echo "   ✅ classroom.notifications: $CLASS_NOTIFY messages"

echo -e "\n════════════════════════════════════════════════════════════════════════════════"
echo "✅ RABBITMQ SETUP COMPLETE"
echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "\nPROCHAINES ÉTAPES:"
echo "1. Allez à http://localhost:31672 (guest/guest)"
echo "2. Cliquez 'Queues and Streams'"
echo "3. Vous verrez les messages dans les queues"
echo "4. Pour consommer: http://localhost:31672 > Queues > Select Queue > Get messages"
