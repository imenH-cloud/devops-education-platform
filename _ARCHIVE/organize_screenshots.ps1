# PowerShell script to organize and rename screenshots
# Usage: .\organize_screenshots.ps1

Write-Host "🎯 Starting screenshot organization..." -ForegroundColor Cyan
Write-Host ""

$RAPPORT_DIR = ".\RAPPORT\scrennPFE"
$TARGET_DIR = ".\RAPPORT\scrennPFE_ORGANIZED"

Write-Host "Source: $RAPPORT_DIR" -ForegroundColor Yellow
Write-Host "Target: $TARGET_DIR" -ForegroundColor Yellow
Write-Host ""

# Create directory structure
$folders = @(
    "01_ARCHITECTURE",
    "02_INFRASTRUCTURE",
    "03_MONITORING",
    "04_LOGGING",
    "05_MESSAGE_QUEUE",
    "06_CACHE",
    "07_CI-CD",
    "08_GITOPS",
    "09_APPLICATION",
    "10_ACTIVITIES"
)

foreach ($folder in $folders) {
    $path = "$TARGET_DIR\$folder"
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "📁 Created: $folder" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📋 Organizing screenshots..." -ForegroundColor Cyan
Write-Host ""

# Function to copy and rename
function Copy-ScreenShot {
    param(
        [string]$source,
        [string]$destination,
        [string]$newName
    )
    
    if (Test-Path "$RAPPORT_DIR\$source") {
        Copy-Item "$RAPPORT_DIR\$source" "$destination\$newName"
        Write-Host "✅ $newName" -ForegroundColor Green
    } else {
        Write-Host "⚠️  NOT FOUND: $source" -ForegroundColor Yellow
    }
}

# INFRASTRUCTURE
Write-Host "→ Infrastructure screenshots:" -ForegroundColor Cyan
Copy-ScreenShot "PODS EN ETAT RUNNING NAMESPACE EDUCATION.png" "$TARGET_DIR\02_INFRASTRUCTURE" "01_pods_running_education.png"
Copy-ScreenShot "Déploiements namespace education.png" "$TARGET_DIR\02_INFRASTRUCTURE" "02_deployments_education.png"
Copy-ScreenShot "Services du namespace education.png" "$TARGET_DIR\02_INFRASTRUCTURE" "03_services_education.png"
Copy-ScreenShot "service health statut .png" "$TARGET_DIR\02_INFRASTRUCTURE" "04_service_health.png"
Copy-ScreenShot "Logs récents de la gateway tourne.png" "$TARGET_DIR\02_INFRASTRUCTURE" "05_gateway_logs.png"

# MONITORING
Write-Host "→ Monitoring screenshots:" -ForegroundColor Cyan
Copy-ScreenShot "grafana promotheus.png" "$TARGET_DIR\03_MONITORING" "01_grafana_prometheus.png"
Copy-ScreenShot "grafana nodeport.png" "$TARGET_DIR\03_MONITORING" "02_grafana_nodeport.png"
Copy-ScreenShot "partie1 dashbord.png" "$TARGET_DIR\03_MONITORING" "03_dashboard_part1.png"
Copy-ScreenShot "partie2 dashbord.png" "$TARGET_DIR\03_MONITORING" "04_dashboard_part2.png"
Copy-ScreenShot "partie3 dashbord.png" "$TARGET_DIR\03_MONITORING" "05_dashboard_part3.png"
Copy-ScreenShot "CPU USAGE.png" "$TARGET_DIR\03_MONITORING" "06_cpu_usage.png"
Copy-ScreenShot "promotheus memory usage.png" "$TARGET_DIR\03_MONITORING" "07_prometheus_memory.png"
Copy-ScreenShot "l'ID du dashboard 315 - Kubernetes Cluster Monitoring.png" "$TARGET_DIR\03_MONITORING" "08_kubernetes_cluster_monitoring.png"
Copy-ScreenShot "services monitoring exposés.png" "$TARGET_DIR\03_MONITORING" "09_monitoring_services.png"

# LOGGING
Write-Host "→ Logging screenshots:" -ForegroundColor Cyan
Copy-ScreenShot "elastiserchIndices.png" "$TARGET_DIR\04_LOGGING" "01_elasticsearch_indices.png"

# MESSAGE QUEUE
Write-Host "→ Message Queue screenshots:" -ForegroundColor Cyan
Copy-ScreenShot "RABBITMQ AUTISME PALTEFORME.png" "$TARGET_DIR\05_MESSAGE_QUEUE" "01_rabbitmq_overview.png"

# GITOPS
Write-Host "→ GitOps screenshots:" -ForegroundColor Cyan
Copy-ScreenShot "argoCD.png" "$TARGET_DIR\08_GITOPS" "01_argocd_dashboard.png"
Copy-ScreenShot "RGOCD3.png" "$TARGET_DIR\08_GITOPS" "02_argocd_detail.png"
Copy-ScreenShot "ArgoCD (namespace argocd.png" "$TARGET_DIR\08_GITOPS" "03_argocd_namespace.png"
Copy-ScreenShot "argoCD APPS.png" "$TARGET_DIR\08_GITOPS" "04_argocd_applications.png"
Copy-ScreenShot "argoCD PODS.png" "$TARGET_DIR\08_GITOPS" "05_argocd_pods.png"
Copy-ScreenShot "ARGOCD2.png" "$TARGET_DIR\08_GITOPS" "06_argocd_deployment.png"
Copy-ScreenShot "ARGOCDAPP.png" "$TARGET_DIR\08_GITOPS" "07_argocd_app_details.png"

# APPLICATION
Write-Host "→ Application screenshots:" -ForegroundColor Cyan
Copy-ScreenShot "Preuve fonctionnelle réponse du frontend.png" "$TARGET_DIR\09_APPLICATION" "01_frontend_response.png"
Copy-ScreenShot "classroom list.png" "$TARGET_DIR\09_APPLICATION" "02_classroom_list.png"
Copy-ScreenShot "list-classroom.png" "$TARGET_DIR\09_APPLICATION" "03_classroom_management.png"

# ACTIVITIES
Write-Host "→ Activities screenshots:" -ForegroundColor Cyan
Copy-ScreenShot "list intervenants.png" "$TARGET_DIR\10_ACTIVITIES" "01_intervenants_list.png"
Copy-ScreenShot "list activity.png" "$TARGET_DIR\10_ACTIVITIES" "02_activity_list.png"
Copy-ScreenShot "list-user.png" "$TARGET_DIR\10_ACTIVITIES" "03_user_list.png"
Copy-ScreenShot "parent list.png" "$TARGET_DIR\10_ACTIVITIES" "04_parent_list.png"
Copy-ScreenShot "student list.png" "$TARGET_DIR\10_ACTIVITIES" "05_student_list.png"

Write-Host ""
Write-Host "✅ Organization complete!" -ForegroundColor Green
Write-Host ""

Write-Host "📊 Summary:" -ForegroundColor Cyan
$fileCount = (Get-ChildItem -Recurse -Path $TARGET_DIR -File).Count
Write-Host "Files organized: $fileCount" -ForegroundColor Green
Write-Host ""

Write-Host "📁 New structure:" -ForegroundColor Cyan
Get-ChildItem -Path $TARGET_DIR -Directory | ForEach-Object {
    $count = (Get-ChildItem -Path $_.FullName -File).Count
    Write-Host "  📂 $($_.Name): $count files" -ForegroundColor White
}

Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Yellow
Write-Host "1. ✅ Verify organized screenshots in: $TARGET_DIR"
Write-Host "2. 📸 Capture missing screenshots (Kibana, ES, monitoring details)"
Write-Host "3. 📝 Add screenshots to: ./RAPPORT_PFE_FINAL_IMEN_HAMADA_2025.md"
Write-Host "4. 📄 Generate PDF from markdown"
Write-Host ""
Write-Host "✨ Ready for final report! 🚀" -ForegroundColor Green
Write-Host ""

# Open the organized directory
Write-Host "Opening organized screenshots directory..." -ForegroundColor Cyan
Start-Process explorer.exe -ArgumentList $TARGET_DIR
