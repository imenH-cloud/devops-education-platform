#!/bin/bash

# Docker Volumes Analysis & Cleanup Script

echo "🔍 Docker Volumes Analysis"
echo "=========================================="
echo ""

# Get all volumes
VOLUMES=$(docker volume ls -q)
TOTAL=$(echo "$VOLUMES" | wc -l)

echo "📊 Total Volumes: $TOTAL"
echo ""

# Categorize volumes
echo "📋 CATEGORIZATION:"
echo ""

# Named volumes (contain project name or descriptive name)
echo "✅ NAMED VOLUMES (8):"
docker volume ls --filter "label=com.docker.compose.project" --format "table {{.Name}}\t{{.Labels}}" | tail -n +2

echo ""
echo "❌ ANONYMOUS VOLUMES (orphans - 16):"
docker volume ls --filter "label!=com.docker.compose.project" --format "table {{.Name}}"

echo ""
echo "=========================================="
echo ""

# Check which volumes are in use
echo "🔎 VOLUME USAGE CHECK:"
echo ""

# Get all volumes mounted in containers
USED_VOLUMES=$(docker inspect $(docker ps -aq) 2>/dev/null | grep '"Name"' | grep -o '"Name":"[^"]*"' | cut -d'"' -f4 | sort | uniq)

echo "Used by active containers:"
echo "$USED_VOLUMES"

echo ""
echo "=========================================="
