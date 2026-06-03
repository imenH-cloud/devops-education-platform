#!/bin/bash

# Elasticsearch Setup Script
echo "════════════════════════════════════════════════════════════════════════════════"
echo "🔍 ELASTICSEARCH - AUTO SETUP"
echo "════════════════════════════════════════════════════════════════════════════════"

ES_URL="http://localhost:30920"

# 1. Créer l'index
echo -e "\n1️⃣ Créer INDEX: education-logs-2026.05.29"
curl -s -X PUT "$ES_URL/education-logs-2026.05.29" \
  -H "Content-Type: application/json" \
  -d '{
    "settings": {"number_of_shards": 1, "number_of_replicas": 0},
    "mappings": {
      "properties": {
        "timestamp": {"type": "date"},
        "service": {"type": "keyword"},
        "level": {"type": "keyword"},
        "message": {"type": "text"},
        "user_id": {"type": "keyword"}
      }
    }
  }' | jq '.acknowledged'
echo "✅ Index créé"

# 2. Indexer des logs
echo -e "\n2️⃣ Indexer des LOGS (5 logs différents)"

echo "   • Log 1: User Service"
curl -s -X POST "$ES_URL/education-logs-2026.05.29/_doc" \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:30:00Z","service":"user-service","level":"INFO","message":"User login successful","user_id":"user-456"}' > /dev/null

echo "   • Log 2: Auth Service"
curl -s -X POST "$ES_URL/education-logs-2026.05.29/_doc" \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:31:00Z","service":"auth-service","level":"INFO","message":"JWT token generated","user_id":"user-456"}' > /dev/null

echo "   • Log 3: Classroom Service (ERROR)"
curl -s -X POST "$ES_URL/education-logs-2026.05.29/_doc" \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:32:00Z","service":"classroom-service","level":"ERROR","message":"Classroom not found","user_id":"user-456"}' > /dev/null

echo "   • Log 4: Activity Service"
curl -s -X POST "$ES_URL/education-logs-2026.05.29/_doc" \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:33:00Z","service":"activity-service","level":"INFO","message":"Activity logged: user viewed lesson","user_id":"user-456"}' > /dev/null

echo "   • Log 5: Student Service"
curl -s -X POST "$ES_URL/education-logs-2026.05.29/_doc" \
  -H "Content-Type: application/json" \
  -d '{"timestamp":"2026-05-29T11:34:00Z","service":"student-service","level":"INFO","message":"Student profile updated","user_id":"user-456"}' > /dev/null

echo "✅ 5 logs indexés"

# 3. Vérifier
echo -e "\n3️⃣ Vérifier les logs indexés"
TOTAL=$(curl -s -X GET "$ES_URL/education-logs-2026.05.29/_search" \
  -H "Content-Type: application/json" \
  -d '{"query":{"match_all":{}}}' | jq '.hits.total.value')
echo "✅ Total logs: $TOTAL"

# 4. Chercher les ERREURS
echo -e "\n4️⃣ Chercher les ERREURS"
ERRORS=$(curl -s -X GET "$ES_URL/education-logs-2026.05.29/_search" \
  -H "Content-Type: application/json" \
  -d '{"query":{"match":{"level":"ERROR"}}}' | jq '.hits.total.value')
echo "✅ Erreurs trouvées: $ERRORS"

echo -e "\n════════════════════════════════════════════════════════════════════════════════"
echo "✅ ELASTICSEARCH SETUP COMPLETE"
echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "\nPROCHAINES ÉTAPES:"
echo "1. Allez à http://localhost:30561 (Kibana)"
echo "2. Stack Management > Index Patterns"
echo "3. Create pattern: 'education-logs-*'"
echo "4. Allez à Discover pour voir les logs"
