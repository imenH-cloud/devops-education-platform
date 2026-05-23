#!/bin/bash
# Script to organize and rename screenshots for Horizons TSA PFE project
# Usage: bash organize_screenshots.sh

set -e

RAPPORT_DIR="./RAPPORT/scrennPFE"
TARGET_DIR="./RAPPORT/scrennPFE_ORGANIZED"

echo "🎯 Starting screenshot organization..."
echo "Source: $RAPPORT_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Create directory structure
mkdir -p "$TARGET_DIR/{01_ARCHITECTURE,02_INFRASTRUCTURE,03_MONITORING,04_LOGGING,05_MESSAGE_QUEUE,06_CACHE,07_CI-CD,08_GITOPS,09_APPLICATION,10_ACTIVITIES}"

# Function to copy and rename file
copy_file() {
    local source=$1
    local dest=$2
    local name=$3
    
    if [ -f "$source" ]; then
        cp "$source" "$dest/$name"
        echo "✅ Copied: $name"
    fi
}

echo "📋 Organizing screenshots..."
echo ""

# INFRASTRUCTURE
echo "→ Infrastructure screenshots:"
copy_file "$RAPPORT_DIR/PODS EN ETAT RUNNING NAMESPACE EDUCATION.png" "$TARGET_DIR/02_INFRASTRUCTURE" "01_pods_running_education.png"
copy_file "$RAPPORT_DIR/Déploiements namespace education.png" "$TARGET_DIR/02_INFRASTRUCTURE" "02_deployments_education.png"
copy_file "$RAPPORT_DIR/Services du namespace education.png" "$TARGET_DIR/02_INFRASTRUCTURE" "03_services_education.png"
copy_file "$RAPPORT_DIR/service health statut .png" "$TARGET_DIR/02_INFRASTRUCTURE" "04_service_health.png"

# MONITORING
echo "→ Monitoring screenshots:"
copy_file "$RAPPORT_DIR/grafana promotheus.png" "$TARGET_DIR/03_MONITORING" "01_grafana_prometheus.png"
copy_file "$RAPPORT_DIR/grafana nodeport.png" "$TARGET_DIR/03_MONITORING" "02_grafana_nodeport.png"
copy_file "$RAPPORT_DIR/partie1 dashbord.png" "$TARGET_DIR/03_MONITORING" "03_dashboard_part1.png"
copy_file "$RAPPORT_DIR/partie2 dashbord.png" "$TARGET_DIR/03_MONITORING" "04_dashboard_part2.png"
copy_file "$RAPPORT_DIR/partie3 dashbord.png" "$TARGET_DIR/03_MONITORING" "05_dashboard_part3.png"
copy_file "$RAPPORT_DIR/CPU USAGE.png" "$TARGET_DIR/03_MONITORING" "06_cpu_usage.png"
copy_file "$RAPPORT_DIR/promotheus memory usage.png" "$TARGET_DIR/03_MONITORING" "07_prometheus_memory.png"
copy_file "$RAPPORT_DIR/l'ID du dashboard 315 - Kubernetes Cluster Monitoring.png" "$TARGET_DIR/03_MONITORING" "08_kubernetes_cluster_monitoring.png"

# LOGGING
echo "→ Logging screenshots:"
copy_file "$RAPPORT_DIR/elastiserchIndices.png" "$TARGET_DIR/04_LOGGING" "01_elasticsearch_indices.png"

# MESSAGE QUEUE
echo "→ Message Queue screenshots:"
copy_file "$RAPPORT_DIR/RABBITMQ AUTISME PALTEFORME.png" "$TARGET_DIR/05_MESSAGE_QUEUE" "01_rabbitmq_overview.png"

# GITOPS
echo "→ GitOps screenshots:"
copy_file "$RAPPORT_DIR/argoCD.png" "$TARGET_DIR/08_GITOPS" "01_argocd_dashboard.png"
copy_file "$RAPPORT_DIR/RGOCD3.png" "$TARGET_DIR/08_GITOPS" "02_argocd_apps.png"
copy_file "$RAPPORT_DIR/ArgoCD (namespace argocd.png" "$TARGET_DIR/08_GITOPS" "03_argocd_namespace.png"
copy_file "$RAPPORT_DIR/argoCD APPS.png" "$TARGET_DIR/08_GITOPS" "04_argocd_applications.png"
copy_file "$RAPPORT_DIR/argoCD PODS.png" "$TARGET_DIR/08_GITOPS" "05_argocd_pods.png"
copy_file "$RAPPORT_DIR/ARGOCD2.png" "$TARGET_DIR/08_GITOPS" "06_argocd_deployment.png"
copy_file "$RAPPORT_DIR/ARGOCDAPP.png" "$TARGET_DIR/08_GITOPS" "07_argocd_app_details.png"

# APPLICATION
echo "→ Application screenshots:"
copy_file "$RAPPORT_DIR/Preuve fonctionnelle réponse du frontend.png" "$TARGET_DIR/09_APPLICATION" "01_frontend_response.png"
copy_file "$RAPPORT_DIR/classroom list.png" "$TARGET_DIR/09_APPLICATION" "02_classroom_list.png"
copy_file "$RAPPORT_DIR/list-classroom.png" "$TARGET_DIR/09_APPLICATION" "03_classroom_management.png"

# ACTIVITIES
echo "→ Activities screenshots:"
copy_file "$RAPPORT_DIR/list intervenants.png" "$TARGET_DIR/10_ACTIVITIES" "01_intervenants_list.png"
copy_file "$RAPPORT_DIR/list activity.png" "$TARGET_DIR/10_ACTIVITIES" "02_activity_list.png"
copy_file "$RAPPORT_DIR/list-user.png" "$TARGET_DIR/10_ACTIVITIES" "03_user_list.png"
copy_file "$RAPPORT_DIR/parent list.png" "$TARGET_DIR/10_ACTIVITIES" "04_parent_list.png"
copy_file "$RAPPORT_DIR/student list.png" "$TARGET_DIR/10_ACTIVITIES" "05_student_list.png"

# OTHER (Gateway logs)
echo "→ Infrastructure logs:"
copy_file "$RAPPORT_DIR/Logs récents de la gateway tourne.png" "$TARGET_DIR/02_INFRASTRUCTURE" "05_gateway_logs.png"

echo ""
echo "✅ Organization complete!"
echo ""
echo "📊 Summary:"
ls -la "$TARGET_DIR"/ | grep "^d" | wc -l | xargs echo "Directories created:"
find "$TARGET_DIR" -type f | wc -l | xargs echo "Files organized:"
echo ""
echo "📁 New structure:"
tree "$TARGET_DIR" 2>/dev/null || find "$TARGET_DIR" -type f -printf "%P\n" | head -20
echo ""
echo "🎯 Next steps:"
echo "1. Verify organized screenshots in: $TARGET_DIR"
echo "2. Capture missing screenshots (Kibana, ES, detailed monitoring, ArgoCD)"
echo "3. Add screenshots to: ./RAPPORT_PFE_FINAL_IMEN_HAMADA_2025.md"
echo "4. Generate PDF from markdown"
echo ""
echo "✨ Ready for final report! 🚀"
