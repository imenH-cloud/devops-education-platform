#!/bin/bash

# Setup Grafana dashboards via API
GRAFANA_URL="http://localhost:3000"
GRAFANA_USER="admin"
GRAFANA_PASS="admin123"

echo "Setting up Grafana dashboards..."

# 1. Create Prometheus datasource
echo "Creating Prometheus datasource..."
curl -s -X POST "$GRAFANA_URL/api/datasources" \
  -H "Content-Type: application/json" \
  -u "$GRAFANA_USER:$GRAFANA_PASS" \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://prometheus:9090",
    "access": "proxy",
    "isDefault": true,
    "jsonData": {"timeInterval": "15s"}
  }' | grep -o '"id":[0-9]*' || echo "Datasource may already exist"

# 2. Create Education Platform Dashboard
echo "Creating Education Platform dashboard..."
curl -s -X POST "$GRAFANA_URL/api/dashboards/db" \
  -H "Content-Type: application/json" \
  -u "$GRAFANA_USER:$GRAFANA_PASS" \
  -d '{
    "dashboard": {
      "title": "Education Platform Monitoring",
      "tags": ["education", "production"],
      "timezone": "browser",
      "panels": [
        {
          "id": 1,
          "title": "Prometheus Status",
          "type": "stat",
          "gridPos": {"h": 4, "w": 6, "x": 0, "y": 0},
          "targets": [{"expr": "up{job=\"prometheus\"}", "refId": "A"}],
          "fieldConfig": {"defaults": {"color": {"mode": "thresholds"}, "thresholds": {"mode": "absolute", "steps": [{"color": "red", "value": null}, {"color": "green", "value": 1}]}}}
        },
        {
          "id": 2,
          "title": "Grafana Status",
          "type": "stat",
          "gridPos": {"h": 4, "w": 6, "x": 6, "y": 0},
          "targets": [{"expr": "up{job=\"grafana\"}", "refId": "A"}],
          "fieldConfig": {"defaults": {"color": {"mode": "thresholds"}, "thresholds": {"mode": "absolute", "steps": [{"color": "red", "value": null}, {"color": "green", "value": 1}]}}}
        },
        {
          "id": 3,
          "title": "Prometheus Memory (MB)",
          "type": "gauge",
          "gridPos": {"h": 4, "w": 6, "x": 12, "y": 0},
          "targets": [{"expr": "process_resident_memory_bytes{job=\"prometheus\"} / 1024 / 1024", "refId": "A"}],
          "fieldConfig": {"defaults": {"color": {"mode": "thresholds"}, "thresholds": {"mode": "absolute", "steps": [{"color": "green", "value": null}]}}}
        },
        {
          "id": 4,
          "title": "Grafana Memory (MB)",
          "type": "gauge",
          "gridPos": {"h": 4, "w": 6, "x": 18, "y": 0},
          "targets": [{"expr": "process_resident_memory_bytes{job=\"grafana\"} / 1024 / 1024", "refId": "A"}],
          "fieldConfig": {"defaults": {"color": {"mode": "thresholds"}, "thresholds": {"mode": "absolute", "steps": [{"color": "green", "value": null}]}}}
        },
        {
          "id": 5,
          "title": "Memory Usage Timeline",
          "type": "timeseries",
          "gridPos": {"h": 8, "w": 24, "x": 0, "y": 4},
          "targets": [{"expr": "process_resident_memory_bytes{job=~\"prometheus|grafana\"} / 1024 / 1024", "legendFormat": "{{ job }}", "refId": "A"}],
          "fieldConfig": {"defaults": {"custom": {"lineWidth": 1, "fillOpacity": 0}}}
        },
        {
          "id": 6,
          "title": "CPU Usage (5m)",
          "type": "timeseries",
          "gridPos": {"h": 8, "w": 24, "x": 0, "y": 12},
          "targets": [{"expr": "rate(process_cpu_seconds_total{job=~\"prometheus|grafana\"}[5m])", "legendFormat": "{{ job }}", "refId": "A"}],
          "fieldConfig": {"defaults": {"custom": {"lineWidth": 1}}}
        }
      ],
      "refresh": "5s",
      "schemaVersion": 27,
      "version": 0
    },
    "overwrite": true
  }' || echo "Dashboard creation may have failed"

echo "✅ Grafana setup complete!"
