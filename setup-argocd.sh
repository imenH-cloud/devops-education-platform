#!/bin/bash

# ==============================================================================
# Setup ArgoCD + DevOps Education Deployment
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
ARGOCD_NAMESPACE="argocd"
ARGOCD_SERVER="localhost:31961"
APP_NAMESPACE="prod"
APP_NAME="devops-education"
GIT_REPO="${1:-https://github.com/your-repo/devops-education}"
GIT_BRANCH="${2:-main}"

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   ArgoCD + DevOps Education Setup      ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"
}

print_section() {
    echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_section "Checking Prerequisites"
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl not found. Please install kubectl."
        exit 1
    fi
    print_success "kubectl found"
    
    # Check argocd CLI
    if ! command -v argocd &> /dev/null; then
        print_info "argocd CLI not found. Installing..."
        # Installation depends on OS
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install argocd
        else
            curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
            chmod +x /usr/local/bin/argocd
        fi
        print_success "argocd CLI installed"
    else
        print_success "argocd CLI found"
    fi
    
    # Check kubectl access
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot access Kubernetes cluster"
        exit 1
    fi
    print_success "Kubernetes cluster accessible"
}

# Create namespace
create_namespace() {
    print_section "Creating Namespace"
    
    if kubectl get namespace $APP_NAMESPACE &> /dev/null; then
        print_info "Namespace '$APP_NAMESPACE' already exists"
    else
        kubectl create namespace $APP_NAMESPACE
        print_success "Namespace '$APP_NAMESPACE' created"
    fi
}

# Get ArgoCD password
get_argocd_password() {
    print_section "Getting ArgoCD Credentials"
    
    # Try to get initial password
    ARGOCD_PASSWORD=$(kubectl -n $ARGOCD_NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 2>/dev/null || echo "")
    
    if [ -z "$ARGOCD_PASSWORD" ]; then
        print_info "Initial password not found. You may need to set a new password."
        print_info "Run: argocd account update-password"
        ARGOCD_PASSWORD="admin"
    fi
    
    print_success "ArgoCD Credentials Retrieved"
    print_info "Username: admin"
    print_info "Password: $ARGOCD_PASSWORD"
}

# Login to ArgoCD
login_argocd() {
    print_section "Logging in to ArgoCD"
    
    echo -n "Trying to login to ArgoCD..."
    
    # Wait for ArgoCD to be ready
    for i in {1..30}; do
        if argocd login $ARGOCD_SERVER --insecure --username admin --password "$ARGOCD_PASSWORD" 2>/dev/null; then
            print_success "Logged in to ArgoCD"
            return 0
        fi
        echo -n "."
        sleep 1
    done
    
    print_error "Could not login to ArgoCD. Make sure it's running on $ARGOCD_SERVER"
    exit 1
}

# Add Git repository
add_git_repo() {
    print_section "Adding Git Repository"
    
    print_info "Repository: $GIT_REPO"
    print_info "Branch: $GIT_BRANCH"
    
    read -p "Enter GitHub username (or press Enter to skip): " GH_USER
    read -sp "Enter GitHub token/password (or press Enter to skip): " GH_TOKEN
    echo ""
    
    if [ -n "$GH_USER" ] && [ -n "$GH_TOKEN" ]; then
        argocd repo add $GIT_REPO \
            --username $GH_USER \
            --password "$GH_TOKEN" \
            --insecure-skip-server-verification
        print_success "Git repository added"
    else
        print_info "Skipping authentication (using public repo)"
        argocd repo add $GIT_REPO \
            --insecure-skip-server-verification
        print_success "Git repository added (public)"
    fi
}

# Create ArgoCD Application
create_app() {
    print_section "Creating ArgoCD Application"
    
    # Check if app already exists
    if argocd app get $APP_NAME 2>/dev/null; then
        print_info "Application '$APP_NAME' already exists"
        read -p "Delete and recreate? (y/n): " confirm
        if [ "$confirm" = "y" ]; then
            argocd app delete $APP_NAME --yes
        else
            return
        fi
    fi
    
    argocd app create $APP_NAME \
        --repo $GIT_REPO \
        --path helm/devops-education \
        --dest-server https://kubernetes.default.svc \
        --dest-namespace $APP_NAMESPACE \
        --auto-prune \
        --self-heal \
        --sync-policy automated
    
    print_success "Application '$APP_NAME' created"
}

# Sync application
sync_app() {
    print_section "Syncing Application"
    
    argocd app sync $APP_NAME --force
    print_success "Application synced"
    
    # Wait for sync
    print_info "Waiting for sync to complete..."
    argocd app wait $APP_NAME --sync
    print_success "Sync complete"
}

# Display application status
show_status() {
    print_section "Application Status"
    
    argocd app get $APP_NAME
    
    echo -e "\n${YELLOW}Pod Status:${NC}"
    kubectl get pods -n $APP_NAMESPACE
    
    echo -e "\n${YELLOW}Service Status:${NC}"
    kubectl get svc -n $APP_NAMESPACE
}

# Display access information
show_access_info() {
    print_section "Access Information"
    
    FRONTEND_NODEPORT=$(kubectl get svc -n $APP_NAMESPACE frontend-nodeport -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "30420")
    GATEWAY_NODEPORT=$(kubectl get svc -n $APP_NAMESPACE gateway-nodeport -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "30000")
    
    echo -e "${GREEN}=== Application URLs ===${NC}"
    echo "ArgoCD:        https://localhost:31961/"
    echo "Frontend:      http://localhost:31927/"
    echo "API Gateway:   http://localhost:$GATEWAY_NODEPORT"
    echo "Grafana:       http://localhost:30300 (admin/admin)"
    echo "Kibana:        http://localhost:30601"
    echo "Prometheus:    http://localhost:30090"
    
    echo -e "\n${GREEN}=== Credentials ===${NC}"
    echo "ArgoCD User:   admin"
    echo "ArgoCD Pass:   $ARGOCD_PASSWORD"
    echo "Grafana:       admin/admin"
    echo "MinIO:         minioadmin/minioadmin"
    echo "RabbitMQ:      guest/guest"
}

# Cleanup function
cleanup() {
    read -p "Do you want to delete the ArgoCD application? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        argocd app delete $APP_NAME --yes
        kubectl delete namespace $APP_NAMESPACE
        print_success "Application deleted"
    fi
}

# Main menu
show_menu() {
    echo -e "\n${BLUE}Options:${NC}"
    echo "1) Full Setup (everything)"
    echo "2) Check Status"
    echo "3) Sync Application"
    echo "4) Show Access Info"
    echo "5) Cleanup"
    echo "6) Exit"
    read -p "Choose option [1-6]: " option
}

# Main execution
main() {
    print_header
    
    while true; do
        show_menu
        
        case $option in
            1)
                check_prerequisites
                create_namespace
                get_argocd_password
                login_argocd
                add_git_repo
                create_app
                sync_app
                show_status
                show_access_info
                ;;
            2)
                show_status
                ;;
            3)
                get_argocd_password
                login_argocd
                sync_app
                ;;
            4)
                show_access_info
                ;;
            5)
                cleanup
                ;;
            6)
                echo -e "\n${GREEN}Goodbye!${NC}\n"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                ;;
        esac
    done
}

# Run
main
