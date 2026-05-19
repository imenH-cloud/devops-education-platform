#!/bin/bash

# ==============================================================================
# DevOps Education Platform - Interactive Deployment Script
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

print_banner() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  DevOps Education Platform Deployment      ║${NC}"
    echo -e "${BLUE}║  v2.1 - ArgoCD + Kubernetes                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"
}

print_section() {
    echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

step_complete() {
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}Step Complete! ✅${NC}\n"
    read -p "Press Enter to continue..."
}

# Check cluster
check_cluster() {
    print_section "Step 1: Checking Kubernetes Cluster"
    
    print_info "Checking kubectl connection..."
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    print_success "Kubernetes cluster is running"
    
    print_info "Checking kubectl version..."
    KUBE_VERSION=$(kubectl version --client -o json 2>/dev/null | jq -r '.clientVersion.gitVersion')
    print_success "kubectl version: $KUBE_VERSION"
    
    print_info "Checking namespaces..."
    if kubectl get namespace $ARGOCD_NAMESPACE &> /dev/null; then
        print_success "ArgoCD namespace exists"
    else
        print_error "ArgoCD namespace not found. Please install ArgoCD first."
        exit 1
    fi
    
    print_info "Checking ArgoCD server..."
    if kubectl get svc -n $ARGOCD_NAMESPACE argocd-server &> /dev/null; then
        print_success "ArgoCD server is available"
        ARGOCD_NODEPORT=$(kubectl get svc argocd-server -n $ARGOCD_NAMESPACE -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
        ARGOCD_SERVER="localhost:$ARGOCD_NODEPORT"
        print_info "ArgoCD Server: $ARGOCD_SERVER"
    else
        print_error "ArgoCD server not found"
        exit 1
    fi
    
    step_complete
}

# Get credentials
get_credentials() {
    print_section "Step 2: Getting ArgoCD Credentials"
    
    print_info "Retrieving ArgoCD admin password..."
    ARGOCD_PASSWORD=$(kubectl -n $ARGOCD_NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 2>/dev/null || echo "")
    
    if [ -z "$ARGOCD_PASSWORD" ]; then
        print_warning "Initial password not found. Trying to use 'admin' as password."
        print_warning "If this doesn't work, you may need to reset ArgoCD password:"
        echo "  kubectl patch secret argocd-secret -n argocd -p '{\"stringData\": {\"admin.password\": \"<new-password>\"}}'"
        ARGOCD_PASSWORD="admin"
    fi
    
    print_success "ArgoCD Username: admin"
    print_success "ArgoCD Password: $ARGOCD_PASSWORD"
    
    step_complete
}

# Prepare Git repository
prepare_git() {
    print_section "Step 3: Configuring Git Repository"
    
    read -p "Enter Git repository URL (e.g., https://github.com/user/repo): " GIT_REPO
    
    if [ -z "$GIT_REPO" ]; then
        print_error "Repository URL is required"
        exit 1
    fi
    
    print_info "Repository: $GIT_REPO"
    
    # Check if private repo
    read -p "Is this a private repository? (y/n): " IS_PRIVATE
    
    if [ "$IS_PRIVATE" = "y" ]; then
        read -p "Enter GitHub username: " GIT_USER
        read -sp "Enter GitHub token/password: " GIT_TOKEN
        echo ""
        GIT_AUTH="--username $GIT_USER --password $GIT_TOKEN"
        print_success "GitHub credentials configured"
    else
        GIT_AUTH=""
        print_success "Using public repository"
    fi
    
    step_complete
}

# Create namespace
create_namespace() {
    print_section "Step 4: Creating Namespace"
    
    if kubectl get namespace $APP_NAMESPACE &> /dev/null; then
        print_warning "Namespace '$APP_NAMESPACE' already exists"
    else
        print_info "Creating namespace '$APP_NAMESPACE'..."
        kubectl create namespace $APP_NAMESPACE
        print_success "Namespace created"
    fi
    
    step_complete
}

# Login to ArgoCD
login_argocd() {
    print_section "Step 5: Logging in to ArgoCD"
    
    print_info "Attempting to login to ArgoCD at $ARGOCD_SERVER..."
    
    if argocd login $ARGOCD_SERVER --insecure --username admin --password "$ARGOCD_PASSWORD" 2>/dev/null; then
        print_success "Successfully logged in to ArgoCD"
    else
        print_error "Failed to login to ArgoCD"
        print_warning "Make sure ArgoCD is running and accessible at $ARGOCD_SERVER"
        exit 1
    fi
    
    step_complete
}

# Add Git repository
add_git_repo() {
    print_section "Step 6: Adding Git Repository to ArgoCD"
    
    print_info "Adding repository: $GIT_REPO"
    
    # Check if repo already exists
    if argocd repo list 2>/dev/null | grep -q "$GIT_REPO"; then
        print_warning "Repository already exists in ArgoCD"
    else
        if argocd repo add $GIT_REPO $GIT_AUTH --insecure-skip-server-verification 2>/dev/null; then
            print_success "Repository added successfully"
        else
            print_error "Failed to add repository"
            exit 1
        fi
    fi
    
    step_complete
}

# Create application
create_app() {
    print_section "Step 7: Creating ArgoCD Application"
    
    print_info "Application Name: $APP_NAME"
    print_info "Repository: $GIT_REPO"
    print_info "Path: helm/devops-education"
    print_info "Destination: $APP_NAMESPACE"
    
    # Check if app already exists
    if argocd app get $APP_NAME 2>/dev/null | grep -q "Name:"; then
        print_warning "Application already exists"
        read -p "Do you want to recreate it? (y/n): " RECREATE
        if [ "$RECREATE" = "y" ]; then
            print_info "Deleting existing application..."
            argocd app delete $APP_NAME --yes 2>/dev/null || true
            sleep 5
        else
            step_complete
            return
        fi
    fi
    
    print_info "Creating application..."
    argocd app create $APP_NAME \
        --repo $GIT_REPO \
        --path helm/devops-education \
        --dest-server https://kubernetes.default.svc \
        --dest-namespace $APP_NAMESPACE \
        --auto-prune \
        --self-heal \
        --sync-policy automated \
        2>/dev/null
    
    print_success "Application created successfully"
    
    step_complete
}

# Sync application
sync_app() {
    print_section "Step 8: Synchronizing Application"
    
    print_info "Syncing application..."
    argocd app sync $APP_NAME --force 2>/dev/null
    
    print_success "Sync initiated"
    print_info "Waiting for sync to complete (this may take a few minutes)..."
    
    # Wait with progress
    for i in {1..60}; do
        STATUS=$(argocd app get $APP_NAME --refresh 2>/dev/null | grep "Sync Status" | awk '{print $3}' || echo "Syncing")
        if [ "$STATUS" = "Synced" ]; then
            print_success "Application fully synced"
            break
        fi
        echo -n "."
        sleep 2
    done
    echo ""
    
    step_complete
}

# Verify deployment
verify_deployment() {
    print_section "Step 9: Verifying Deployment"
    
    print_info "Checking pods..."
    POD_COUNT=$(kubectl get pods -n $APP_NAMESPACE --no-headers 2>/dev/null | wc -l)
    print_success "Pods created: $POD_COUNT"
    
    kubectl get pods -n $APP_NAMESPACE
    
    echo ""
    print_info "Checking services..."
    kubectl get svc -n $APP_NAMESPACE
    
    echo ""
    print_info "Checking application status..."
    argocd app get $APP_NAME
    
    step_complete
}

# Show access information
show_access() {
    print_section "Step 10: Access Information"
    
    echo -e "${GREEN}=== Your Application URLs ===${NC}\n"
    
    FRONTEND_NODEPORT=$(kubectl get svc -n $APP_NAMESPACE frontend-nodeport -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "31927")
    
    echo "ArgoCD Dashboard:"
    echo "  URL:      https://$ARGOCD_SERVER/"
    echo "  Username: admin"
    echo "  Password: $ARGOCD_PASSWORD"
    echo ""
    
    echo "Application Frontend:"
    echo "  URL:      http://localhost:$FRONTEND_NODEPORT/"
    echo ""
    
    echo "Monitoring:"
    echo "  Grafana:    http://localhost:30300 (admin/admin)"
    echo "  Prometheus: http://localhost:30090"
    echo "  Kibana:     http://localhost:30601"
    echo ""
    
    echo "Infrastructure:"
    echo "  MinIO:        http://localhost:30901 (minioadmin/minioadmin)"
    echo "  RabbitMQ:     http://localhost:30015 (guest/guest)"
    echo "  Elasticsearch:http://localhost:30920"
    echo ""
    
    step_complete
}

# Main menu
main_menu() {
    print_banner
    
    echo -e "${BLUE}Select deployment option:${NC}\n"
    echo "1) Full Deployment (all steps)"
    echo "2) Check Status"
    echo "3) View Logs"
    echo "4) Show Access Info"
    echo "5) Exit"
    echo ""
    read -p "Enter choice [1-5]: " choice
    
    case $choice in
        1)
            check_cluster
            get_credentials
            prepare_git
            create_namespace
            login_argocd
            add_git_repo
            create_app
            sync_app
            verify_deployment
            show_access
            echo -e "\n${GREEN}╔════════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║     Deployment Completed Successfully! ✅   ║${NC}"
            echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}\n"
            ;;
        2)
            kubectl get all -n $APP_NAMESPACE
            kubectl get all -n $ARGOCD_NAMESPACE
            ;;
        3)
            kubectl logs -n $APP_NAMESPACE deployment/gateway-backend -f
            ;;
        4)
            show_access
            ;;
        5)
            echo -e "\n${GREEN}Goodbye! 👋${NC}\n"
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
}

# Run
main_menu
