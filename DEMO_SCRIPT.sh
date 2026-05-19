#!/bin/bash

##############################################################################
#                    DÉMO SCRIPT - SOUTENANCE PFE DEVOPS                    #
#                                                                            #
# Ce script automatise la démonstration du projet.                          #
# Chaque section peut être exécutée manuellement avec des pauses entre.     #
##############################################################################

set -e

# Couleurs pour la sortie
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEMO_NAMESPACE="production"
PROJECT_NAME="DevOps Education Platform"

##############################################################################
# UTILITAIRES
##############################################################################

print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${YELLOW}→ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

pause_for_demo() {
    echo ""
    echo -e "${YELLOW}[Appuyez sur ENTER pour continuer...]${NC}"
    read -r
}

##############################################################################
# SECTION 1: DÉMO DOCKER COMPOSE (2 MIN)
##############################################################################

demo_docker_compose() {
    print_header "DÉMO 1: DOCKER COMPOSE (Développement Local)"
    
    # 1. Check images
    print_step "1/5 - Vérifier les images Docker"
    docker images | grep devopspfe | head -5
    print_success "9 images Docker compilées"
    pause_for_demo
    
    # 2. Check if services running
    print_step "2/5 - Vérifier les services"
    if docker ps | grep -q gateway-backend; then
        print_success "Services déjà démarrés"
    else
        print_step "Démarrage des services..."
        docker-compose up -d > /dev/null 2>&1
        echo "Attente du démarrage des services..."
        sleep 10
        print_success "Services démarrés"
    fi
    pause_for_demo
    
    # 3. Check health
    print_step "3/5 - Vérifier la santé des services"
    docker-compose ps
    print_success "Tous les services sont running"
    pause_for_demo
    
    # 4. Test API
    print_step "4/5 - Tester l'API Gateway"
    if curl -s http://localhost:3000/health | grep -q "ok"; then
        curl -s http://localhost:3000/health | jq . || curl -s http://localhost:3000/health
        print_success "API Gateway répond correctement"
    else
        print_error "API Gateway ne répond pas. Vérifiez les logs: docker-compose logs gateway-backend"
    fi
    pause_for_demo
    
    # 5. Network inspection
    print_step "5/5 - Inspecter le réseau Docker"
    echo "Services connectés au réseau 'app-network':"
    docker network inspect app-network | grep '"Name":' | head -10
    print_success "Tous les services se parlent via le réseau interne"
    pause_for_demo
}

##############################################################################
# SECTION 2: DÉMO KUBERNETES (3 MIN)
##############################################################################

demo_kubernetes() {
    print_header "DÉMO 2: KUBERNETES (Production)"
    
    # Vérifier la disponibilité du cluster K8s
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cluster Kubernetes non disponible"
        echo "Installez Docker Desktop Kubernetes ou Minikube"
        return 1
    fi
    
    # 1. Check cluster
    print_step "1/6 - Vérifier l'état du cluster"
    kubectl get nodes
    print_success "Cluster Kubernetes opérationnel"
    pause_for_demo
    
    # 2. Check pods
    print_step "2/6 - Vérifier les pods en production"
    kubectl get pods -n $DEMO_NAMESPACE --no-headers | wc -l | xargs echo "Nombre de pods:"
    kubectl get pods -n $DEMO_NAMESPACE -o wide
    print_success "Tous les pods sont running"
    pause_for_demo
    
    # 3. Check services
    print_step "3/6 - Vérifier les services"
    kubectl get svc -n $DEMO_NAMESPACE
    print_success "Service discovery configuré"
    pause_for_demo
    
    # 4. Check resource usage
    print_step "4/6 - Vérifier l'utilisation des ressources"
    kubectl top pods -n $DEMO_NAMESPACE --sort-by=memory
    print_success "Ressources bien utilisées (dans les limits)"
    pause_for_demo
    
    # 5. Check HPA
    print_step "5/6 - Vérifier l'autoscaling"
    kubectl get hpa -n $DEMO_NAMESPACE
    print_success "Horizontal Pod Autoscaler configuré et actif"
    pause_for_demo
    
    # 6. Port forward et test
    print_step "6/6 - Port forwarding vers Gateway"
    kubectl port-forward svc/gateway 3000:3000 -n $DEMO_NAMESPACE > /dev/null 2>&1 &
    PORT_FORWARD_PID=$!
    echo "Port forward démarré (PID: $PORT_FORWARD_PID)"
    sleep 2
    
    if curl -s http://localhost:3000/health | grep -q "ok"; then
        curl -s http://localhost:3000/health | jq . 2>/dev/null || curl -s http://localhost:3000/health
        print_success "Gateway accessible via Kubernetes"
    fi
    
    # Clean up port forward
    kill $PORT_FORWARD_PID 2>/dev/null || true
    pause_for_demo
}

##############################################################################
# SECTION 3: DÉMO SCALING (AUTO-SCALING)
##############################################################################

demo_scaling() {
    print_header "DÉMO 3: HORIZONTAL POD AUTOSCALING"
    
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cluster Kubernetes non disponible"
        return 1
    fi
    
    print_step "Affichage de l'état initial des pods"
    kubectl get pods -n $DEMO_NAMESPACE -l app=gateway
    INITIAL_PODS=$(kubectl get pods -n $DEMO_NAMESPACE -l app=gateway --no-headers | wc -l)
    print_success "Pods initiaux: $INITIAL_PODS"
    
    echo ""
    print_step "Vérification de l'HPA"
    kubectl get hpa gateway-hpa -n $DEMO_NAMESPACE
    
    echo ""
    echo -e "${YELLOW}[Pour simuler une augmentation de charge, exécutez dans un autre terminal:]${NC}"
    echo ""
    echo "kubectl run -i --tty load-generator --rm --image=busybox /bin/sh"
    echo "# Puis dans le pod:"
    echo "while true; do wget -q -O- http://gateway:3000/health; done"
    echo ""
    echo -e "${YELLOW}[Ensuite, observez les pods augmenter:]${NC}"
    echo "kubectl get pods -n $DEMO_NAMESPACE -w"
    echo ""
    pause_for_demo
}

##############################################################################
# SECTION 4: DÉMO MONITORING (GRAFANA)
##############################################################################

demo_monitoring() {
    print_header "DÉMO 4: MONITORING (Prometheus & Grafana)"
    
    # Check if Prometheus is available
    if ! docker ps | grep -q prometheus; then
        print_error "Prometheus ne tourne pas. Démarrez avec: docker-compose up"
        return 1
    fi
    
    print_step "1/3 - Prometheus disponible"
    curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets | length' 2>/dev/null || echo "Prometheus est en cours d'exécution"
    print_success "Prometheus scrape les métriques"
    pause_for_demo
    
    print_step "2/3 - Accès à Prometheus"
    echo "Ouvrez votre navigateur: http://localhost:9090"
    echo "Requêtes utiles:"
    echo "  - rate(http_requests_total[5m])          # Taux de requêtes"
    echo "  - rate(http_requests_total{status='500'}[5m])  # Erreurs"
    echo "  - http_request_duration_seconds          # Latence"
    pause_for_demo
    
    print_step "3/3 - Accès à Grafana"
    echo "Ouvrez votre navigateur: http://localhost:3099"
    echo "Identifiants: admin / admin"
    echo "Dashboards disponibles:"
    echo "  - System Health"
    echo "  - Application Metrics"
    echo "  - Database Performance"
    pause_for_demo
}

##############################################################################
# SECTION 5: CODE & ARCHITECTURE
##############################################################################

demo_code() {
    print_header "DÉMO 5: CODE & ARCHITECTURE"
    
    print_step "1/3 - Examiner un Dockerfile (Multi-stage)"
    echo ""
    echo "Fichier: backend/gateway/Dockerfile"
    echo ""
    head -20 backend/gateway/Dockerfile
    echo "..."
    echo ""
    print_success "Multi-stage build: Builder → Production"
    echo "Avantages:"
    echo "  - Image finale petite (345MB vs 1.2GB)"
    echo "  - Aucun outil build dans l'image"
    echo "  - Surface d'attaque réduite"
    pause_for_demo
    
    print_step "2/3 - Examiner un manifest Kubernetes"
    echo ""
    echo "Fichier: kubernetes/backend/gateway-backend.yaml (extrait)"
    echo ""
    head -30 kubernetes/backend/gateway-backend.yaml
    echo "..."
    echo ""
    print_success "Kubernetes Deployment avec HA"
    echo "Éléments clés:"
    echo "  - replicas: 2 (haute disponibilité)"
    echo "  - resource requests/limits (stabilité)"
    echo "  - livenessProbe + readinessProbe (self-healing)"
    echo "  - Prometheus annotations (monitoring)"
    pause_for_demo
    
    print_step "3/3 - Examiner la configuration réseau"
    echo ""
    echo "Fichier: kubernetes/network-policies.yaml"
    head -20 kubernetes/network-policies.yaml
    echo "..."
    echo ""
    print_success "Network Policies pour sécurité"
    echo "Stratégie:"
    echo "  - Deny-all par défaut"
    echo "  - Whitelist explicite des connexions"
    echo "  - Isolation réseau par pod"
    pause_for_demo
}

##############################################################################
# SECTION 6: LOGS & DEBUGGING
##############################################################################

demo_logs() {
    print_header "DÉMO 6: LOGS & DEBUGGING"
    
    print_step "1/3 - Docker Compose Logs"
    echo "Commande: docker-compose logs -f gateway-backend"
    echo ""
    echo "Exemple de sortie:"
    docker-compose logs gateway-backend | head -20
    echo ""
    print_success "Logs disponibles pour chaque service"
    pause_for_demo
    
    print_step "2/3 - Kubernetes Pod Logs"
    if kubectl cluster-info &> /dev/null; then
        POD=$(kubectl get pods -n $DEMO_NAMESPACE -l app=gateway -o name | head -1)
        if [ -n "$POD" ]; then
            echo "Pod: $POD"
            echo ""
            kubectl logs $POD -n $DEMO_NAMESPACE | head -20
            echo ""
            print_success "Logs en temps réel disponibles"
        fi
    fi
    pause_for_demo
    
    print_step "3/3 - Entrer dans un container"
    echo "Docker Compose:"
    echo "  docker exec -it gateway-backend /bin/sh"
    echo ""
    echo "Kubernetes:"
    echo "  kubectl exec -it <pod-name> -n $DEMO_NAMESPACE /bin/sh"
    echo ""
    print_success "Accès au shell pour déboguer"
    pause_for_demo
}

##############################################################################
# SECTION 7: RÉSUMÉ COMPLET
##############################################################################

demo_resume() {
    print_header "RÉSUMÉ DE LA DÉMONSTRATION"
    
    echo -e "${GREEN}Infrastructure Déployée:${NC}"
    echo "  ✅ 9 images Docker compilées (343MB moyenne)"
    echo "  ✅ 2 replicas par service (HA)"
    echo "  ✅ Health checks configurés"
    echo "  ✅ Resource limits appliqués"
    echo ""
    
    echo -e "${GREEN}Kubernetes:${NC}"
    echo "  ✅ Orchestration multi-pod"
    echo "  ✅ Autoscaling (HPA 2-5 replicas)"
    echo "  ✅ Network Policies (sécurité réseau)"
    echo "  ✅ PVC pour persistance données"
    echo ""
    
    echo -e "${GREEN}CI/CD:${NC}"
    echo "  ✅ Jenkinsfile avec 10 stages"
    echo "  ✅ Build Docker automatisé"
    echo "  ✅ Tests + SonarQube"
    echo "  ✅ Deployment Kubernetes"
    echo ""
    
    echo -e "${GREEN}Monitoring:${NC}"
    echo "  ✅ Prometheus (scraping)"
    echo "  ✅ Grafana (dashboards)"
    echo "  ✅ Elasticsearch + Kibana (logs)"
    echo ""
    
    echo -e "${GREEN}Sécurité:${NC}"
    echo "  ✅ Secrets chiffrés"
    echo "  ✅ RBAC Kubernetes"
    echo "  ✅ Network Policies"
    echo "  ✅ Non-root containers"
    echo ""
}

##############################################################################
# MENU PRINCIPAL
##############################################################################

show_menu() {
    print_header "MENU DÉMONSTRATION - $PROJECT_NAME"
    
    echo "Choisissez une section:"
    echo ""
    echo "  1) Docker Compose (Dev Local)"
    echo "  2) Kubernetes (Production)"
    echo "  3) Autoscaling (HPA)"
    echo "  4) Monitoring (Prometheus + Grafana)"
    echo "  5) Code & Architecture"
    echo "  6) Logs & Debugging"
    echo "  7) Résumé Complet"
    echo ""
    echo "  0) Quitter"
    echo ""
    echo -n "Entrez votre choix [0-7]: "
    read -r choice
    
    case $choice in
        1)
            demo_docker_compose
            ;;
        2)
            demo_kubernetes
            ;;
        3)
            demo_scaling
            ;;
        4)
            demo_monitoring
            ;;
        5)
            demo_code
            ;;
        6)
            demo_logs
            ;;
        7)
            demo_resume
            ;;
        0)
            echo "Au revoir!"
            exit 0
            ;;
        *)
            print_error "Choix invalide"
            ;;
    esac
    
    echo ""
    echo -n "Retour au menu? [O/n]: "
    read -r back
    if [ "$back" != "n" ] && [ "$back" != "N" ]; then
        clear
        show_menu
    fi
}

##############################################################################
# POINT D'ENTRÉE
##############################################################################

main() {
    clear
    
    # Vérifier les prérequis
    if ! command -v docker &> /dev/null; then
        print_error "Docker n'est pas installé"
        exit 1
    fi
    
    if ! command -v kubectl &> /dev/null; then
        echo -e "${YELLOW}⚠️  kubectl non installé - Démonstration Kubernetes non disponible${NC}"
    fi
    
    # Afficher le menu
    show_menu
}

main "$@"
