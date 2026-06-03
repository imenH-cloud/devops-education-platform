════════════════════════════════════════════════════════════════════════════════
✅ KIBANA DASHBOARD AUTOMATION - CURL COMMANDS
════════════════════════════════════════════════════════════════════════════════

Copiez et collez CES COMMANDES dans votre terminal/PowerShell pour créer
automatiquement 4 visualizations + 1 dashboard!

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 1: CREATE PIE CHART - "Events by Agent"
════════════════════════════════════════════════════════════════════════════════

curl -X POST "http://localhost:30561/api/saved_objects/visualization" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "attributes": {
      "title": "Events by Agent",
      "visState": "{\"title\":\"Events by Agent\",\"type\":\"pie\",\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"agent.name\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"_count\"}}]}",
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"filebeat-logs\",\"query\":{\"match_all\":{}},\"version\":true}"
      },
      "uiStateJSON": "{}"
    }
  }'

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 2: CREATE METRIC - "Total Events (Last 24h)"
════════════════════════════════════════════════════════════════════════════════

curl -X POST "http://localhost:30561/api/saved_objects/visualization" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "attributes": {
      "title": "Total Events (Last 24h)",
      "visState": "{\"title\":\"Total Events (Last 24h)\",\"type\":\"metric\",\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}}]}",
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"filebeat-logs\",\"query\":{\"match_all\":{}},\"version\":true}"
      },
      "uiStateJSON": "{}"
    }
  }'

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 3: CREATE LINE CHART - "Activity Trend"
════════════════════════════════════════════════════════════════════════════════

curl -X POST "http://localhost:30561/api/saved_objects/visualization" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "attributes": {
      "title": "Activity Trend",
      "visState": "{\"title\":\"Activity Trend\",\"type\":\"histogram\",\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"date_histogram\",\"schema\":\"segment\",\"params\":{\"field\":\"@timestamp\",\"interval\":\"30s\",\"customInterval\":\"2h\",\"format\":\"strict_date_optional_time\",\"min_doc_count\":1}}]}",
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"filebeat-logs\",\"query\":{\"match_all\":{}},\"version\":true}"
      },
      "uiStateJSON": "{}"
    }
  }'

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 4: CREATE HORIZONTAL BAR - "Top Event Types"
════════════════════════════════════════════════════════════════════════════════

curl -X POST "http://localhost:30561/api/saved_objects/visualization" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "attributes": {
      "title": "Top Event Types",
      "visState": "{\"title\":\"Top Event Types\",\"type\":\"histogram\",\"aggs\":[{\"id\":\"1\",\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"aws.cloudtrail.event_type\",\"size\":10,\"order\":\"desc\",\"orderBy\":\"_count\"}}]}",
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"filebeat-logs\",\"query\":{\"match_all\":{}},\"version\":true}"
      },
      "uiStateJSON": "{}"
    }
  }'

════════════════════════════════════════════════════════════════════════════════
ÉTAPE 5: CREATE DASHBOARD
════════════════════════════════════════════════════════════════════════════════

curl -X POST "http://localhost:30561/api/saved_objects/dashboard" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "attributes": {
      "title": "Education Platform - Event Monitoring",
      "description": "Complete event monitoring dashboard with visualizations",
      "timeRestore": true,
      "timeFrom": "now-24h",
      "timeTo": "now",
      "refreshInterval": {
        "pause": false,
        "value": 10000
      }
    }
  }'

════════════════════════════════════════════════════════════════════════════════
HOW TO USE
════════════════════════════════════════════════════════════════════════════════

OPTION 1 - Copy each curl command individually:
1. Open PowerShell or Terminal
2. Copy ÉTAPE 1 command → Paste → Run
3. Wait for response
4. Copy ÉTAPE 2 → Paste → Run
5. Repeat for ÉTAPE 3, 4, 5

OPTION 2 - Use all at once:
1. Copy ALL 5 commands
2. Paste in terminal
3. Run

OPTION 3 - Create a batch file:
1. Save all commands to a .sh file
2. Run: bash filename.sh

════════════════════════════════════════════════════════════════════════════════
VERIFY
════════════════════════════════════════════════════════════════════════════════

After running all commands:

1. Go to http://localhost:30561
2. Left menu → Dashboards
3. Search "Education Platform"
4. Click the dashboard to view all visualizations

Expected Result:
✅ 4 visualizations created
✅ 1 dashboard created
✅ All visualizations auto-added to dashboard

════════════════════════════════════════════════════════════════════════════════
TROUBLESHOOTING
════════════════════════════════════════════════════════════════════════════════

If curl commands fail:
- Ensure Kibana is running: http://localhost:30561
- Check kbn-xsrf header is present
- Try with double quotes escaped: \"

If visualizations don't appear:
- Refresh browser (F5)
- Wait 5 seconds for Kibana to process
- Check browser console for errors

════════════════════════════════════════════════════════════════════════════════
