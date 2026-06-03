@echo off
REM Kibana Dashboard Creation Script

setlocal enabledelayedexpansion

echo Creating Kibana Dashboard...
echo.

REM Using curl commands to create visualizations via API
REM This requires Kibana to be running on localhost:30561

set KIBANA_URL=http://localhost:30561
set SPACE=default

echo [1] Creating Pie Chart - Events by Agent
curl -X POST "%KIBANA_URL%/api/saved_objects/visualization" ^
  -H "Content-Type: application/json" ^
  -H "kbn-xsrf: true" ^
  -d "{\"visualization\":{\"title\":\"Events by Agent\",\"type\":\"pie\"}}" ^
  2>nul

echo [2] Creating Metric - Total Events
curl -X POST "%KIBANA_URL%/api/saved_objects/visualization" ^
  -H "Content-Type: application/json" ^
  -H "kbn-xsrf: true" ^
  -d "{\"visualization\":{\"title\":\"Total Events (Last 24h)\",\"type\":\"metric\"}}" ^
  2>nul

echo [3] Creating Line Chart - Activity Trend
curl -X POST "%KIBANA_URL%/api/saved_objects/visualization" ^
  -H "Content-Type: application/json" ^
  -H "kbn-xsrf: true" ^
  -d "{\"visualization\":{\"title\":\"Activity Trend\",\"type\":\"histogram\"}}" ^
  2>nul

echo [4] Creating Horizontal Bar - Top Event Types
curl -X POST "%KIBANA_URL%/api/saved_objects/visualization" ^
  -H "Content-Type: application/json" ^
  -H "kbn-xsrf: true" ^
  -d "{\"visualization\":{\"title\":\"Top Event Types\",\"type\":\"histogram\"}}" ^
  2>nul

echo [5] Creating Dashboard
curl -X POST "%KIBANA_URL%/api/saved_objects/dashboard" ^
  -H "Content-Type: application/json" ^
  -H "kbn-xsrf: true" ^
  -d "{\"dashboard\":{\"title\":\"Education Platform - Event Monitoring\",\"panels\":[]}}" ^
  2>nul

echo.
echo ========================================
echo Dashboard Creation Complete!
echo ========================================
echo.
echo Access at: http://localhost:30561/app/dashboards
echo.
