════════════════════════════════════════════════════════════════════════════════
⚡ KIBANA DASHBOARD - QUICK SETUP (5 MINUTES)
════════════════════════════════════════════════════════════════════════════════

VOUS AVEZ DÉJÀ "Event Activity Timeline" SAUVEGARDÉE ✅

MAINTENANT, CRÉEZ LES 4 AUTRES VISUALIZATIONS EN 5 MINUTES MAX

════════════════════════════════════════════════════════════════════════════════
VIS #2: PIE CHART - "Events by Agent" (1 MINUTE)
════════════════════════════════════════════════════════════════════════════════

URL: http://localhost:30561/app/visualize

1. Click "Create"
2. Select "Lens"
3. DRAG: agent.name (from left) → center
4. Wait for pie chart
5. TOP: Click graph type dropdown → select "Pie"
6. TOP RIGHT: Click "Save"
7. Title: Events by Agent
8. Click "Save visualization"

✅ DONE - 1 minute

════════════════════════════════════════════════════════════════════════════════
VIS #3: METRIC - "Total Events (Last 24h)" (1 MINUTE)
════════════════════════════════════════════════════════════════════════════════

1. Click "Create"
2. Select "Lens"
3. DRAG: @timestamp → center (ONCE)
4. System shows BIG NUMBER automatically
5. TOP RIGHT: Click "Save"
6. Title: Total Events (Last 24h)
7. Click "Save visualization"

✅ DONE - 1 minute

════════════════════════════════════════════════════════════════════════════════
VIS #4: LINE CHART - "Activity Trend" (1 MINUTE)
════════════════════════════════════════════════════════════════════════════════

1. Click "Create"
2. Select "Lens"
3. DRAG: @timestamp → center
4. TOP: Click graph type → select "Line"
5. Wait for line chart
6. TOP RIGHT: Click "Save"
7. Title: Activity Trend
8. Click "Save visualization"

✅ DONE - 1 minute

════════════════════════════════════════════════════════════════════════════════
VIS #5: HORIZONTAL BAR - "Top Event Types" (1 MINUTE)
════════════════════════════════════════════════════════════════════════════════

1. Click "Create"
2. Select "Lens"
3. DRAG: aws.cloudtrail.event_type → center
4. TOP: Click graph type → select "Bar (horizontal)"
5. Wait for bar chart
6. TOP RIGHT: Click "Save"
7. Title: Top Event Types
8. Click "Save visualization"

✅ DONE - 1 minute

════════════════════════════════════════════════════════════════════════════════
CREATE DASHBOARD & ADD ALL VISUALIZATIONS (2 MINUTES)
════════════════════════════════════════════════════════════════════════════════

1. LEFT MENU: Click "Dashboards"
2. Click "Create new dashboard"
3. Click "Add" (top)
4. Click "Add existing"
5. SEARCH & ADD ALL 5:
   ✓ Event Activity Timeline
   ✓ Events by Agent
   ✓ Total Events (Last 24h)
   ✓ Activity Trend
   ✓ Top Event Types

6. RESIZE & ORGANIZE:
   - Drag visualizations around
   - Drag corners to resize
   
   Layout suggestion:
   ┌─────────────┬──────────────┐
   │ Total(Big#) │ Events(Pie)   │
   ├─────────────┴──────────────┤
   │ Activity Trend (Line)       │
   ├─────────────────────────────┤
   │ Event Activity Timeline(Bar)│
   ├─────────────────────────────┤
   │ Top Event Types (H-Bar)     │
   └─────────────────────────────┘

7. TOP RIGHT: Click "Save"
8. Title: Education Platform - Event Monitoring
9. Click "Save dashboard"

✅ DONE - Dashboard created with all visualizations!

════════════════════════════════════════════════════════════════════════════════
✅ FINAL RESULT
════════════════════════════════════════════════════════════════════════════════

URL: http://localhost:30561

Menu > Dashboards > "Education Platform - Event Monitoring"

5 VISUALIZATIONS READY:
✅ Event Activity Timeline (Time series bar chart)
✅ Events by Agent (Pie chart)
✅ Total Events (Metric - 2,613)
✅ Activity Trend (Line chart)
✅ Top Event Types (Horizontal bar)

NOW YOU CAN:
📊 Monitor logs in real-time
📈 Analyze trends
🔍 Filter by date/service
📥 Export data
⚠️ Set alerts

════════════════════════════════════════════════════════════════════════════════
