#!/bin/bash

# Interactive Docker Volumes Cleanup Script

echo "🧹 Docker Volumes Interactive Cleanup"
echo "======================================"
echo ""

# Show volumes statistics
echo "📊 Current Docker Volumes:"
TOTAL_VOLUMES=$(docker volume ls -q | wc -l)
NAMED_VOLUMES=$(docker volume ls --filter "label=com.docker.compose.project" -q | wc -l)
ORPHAN_VOLUMES=$((TOTAL_VOLUMES - NAMED_VOLUMES))

echo "   Total: $TOTAL_VOLUMES"
echo "   Named (production): $NAMED_VOLUMES ✅"
echo "   Orphans (can delete): $ORPHAN_VOLUMES ❌"
echo ""

# Show disk usage
echo "💾 Disk Usage Estimate:"
docker system df | tail -n +2
echo ""

# Menu
echo "Select an option:"
echo "1) List all volumes (with details)"
echo "2) List only orphan volumes"
echo "3) List only named volumes"
echo "4) Clean orphan volumes (SAFE)"
echo "5) Clean all unused volumes (SAFE)"
echo "6) Clean everything (DANGEROUS - data loss!)"
echo "7) Exit"
echo ""

read -p "Choose option (1-7): " choice

case $choice in
  1)
    echo ""
    echo "📋 ALL VOLUMES:"
    docker volume ls
    ;;
  2)
    echo ""
    echo "❌ ORPHAN VOLUMES:"
    docker volume ls --filter "label!=com.docker.compose.project" -q
    ;;
  3)
    echo ""
    echo "✅ NAMED VOLUMES:"
    docker volume ls --filter "label=com.docker.compose.project" -q
    ;;
  4)
    echo ""
    read -p "⚠️  This will remove orphan volumes. Continue? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
      docker volume prune -f
      echo "✅ Orphan volumes cleaned!"
    else
      echo "❌ Cancelled"
    fi
    ;;
  5)
    echo ""
    read -p "⚠️  This will remove all unused volumes. Continue? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
      docker system prune --volumes -f
      echo "✅ Unused volumes cleaned!"
    else
      echo "❌ Cancelled"
    fi
    ;;
  6)
    echo ""
    echo "🚨 WARNING: This will DELETE ALL VOLUMES including production data!"
    read -p "Are you ABSOLUTELY SURE? Type 'DELETE_ALL' to confirm: " confirm
    if [ "$confirm" = "DELETE_ALL" ]; then
      docker volume prune -af
      docker system prune -af --volumes
      echo "✅ ALL volumes deleted!"
    else
      echo "❌ Cancelled"
    fi
    ;;
  7)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac

echo ""
echo "======================================"
echo "✅ Done!"
