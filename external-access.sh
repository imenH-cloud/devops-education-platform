#!/bin/bash

# ==============================================================================
# DevOps Education Platform - External Access Helper Script
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ DevOps Education - External Access     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
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

# Main menu
show_menu() {
    print_header
    
    echo -e "\n${BLUE}Select deployment type:${NC}\n"
    echo "1) Docker Compose (Local Access)"
    echo "2) Kubernetes NodePort (Network Access)"
    echo "3) Show All Access Ports"
    echo "4) Test Connectivity"
    echo "5) Open in Browser"
    echo "6) Exit"
    echo ""
    read -p "Enter choice [1-6]: " choice
}

# Docker Compose Access
docker_compose_access() {
    print_section "Docker Compose - All Services Exposed"
    
    echo -e "${GREEN}=== Backend Services ===${NC}"
    echo "Gateway         → http://localhost:3000"
    echo "Auth Service    → http://localhost:3001"
    echo "User Service    → http://localhost:3002"
    echo "Activity        → http://localhost:3003"
    echo "Parent Service  → http://localhost:3004"
    echo "Student Service → http://localhost:3005"
    echo "Classroom       → http://localhost:3006"
    echo "Teacher Service → http://localhost:3007"
    
    echo -e "\n${GREEN}=== Frontend ===${NC}"
    echo "Frontend        → http://localhost:4200"
    
    echo -e "\n${GREEN}=== Infrastructure ===${NC}"
    echo "PostgreSQL      → localhost:5432 (guest/postgres)"
    echo "Redis           → localhost:6379"
    echo "RabbitMQ AMQP   → localhost:5672 (guest/guest)"
    echo "RabbitMQ UI     → http://localhost:15672 (guest/guest)"
    echo "Elasticsearch   → http://localhost:9200"
    echo "Kibana          → http://localhost:5601"
    echo "MinIO API       → http://localhost:9000"
    echo "MinIO Console   → http://localhost:9001 (minioadmin/minioadmin)"
    echo "Prometheus      → http://localhost:9090"
    echo "Grafana         → http://localhost:3099 (admin/admin)"
    
    echo -e "\n${YELLOW}💡 To start Docker Compose:${NC}"
    echo "docker compose up -d"
    
    echo -e "\n${YELLOW}💡 To check status:${NC}"
    echo "docker compose ps"
}

# Kubernetes NodePort Access
kubernetes_nodeport_access() {
    print_section "Kubernetes NodePort - All Services Exposed"
    
    # Get node IP
    NAMESPACE=${1:-prod}
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}' 2>/dev/null)
    
    if [ -z "$NODE_IP" ]; then
        NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null)
    fi
    
    if [ -z "$NODE_IP" ]; then
        print_error "Could not determine Node IP. Make sure kubectl is configured."
        return 1
    fi
    
    echo -e "${GREEN}Node IP: $NODE_IP${NC}\n"
    
    echo -e "${GREEN}=== Backend Services ===${NC}"
    echo "Gateway         → http://$NODE_IP:30000"
    echo "Auth Service    → http://$NODE_IP:30001"
    echo "User Service    → http://$NODE_IP:30002"
    echo "Activity        → http://$NODE_IP:30003"
    echo "Parent Service  → http://$NODE_IP:30004"
    echo "Student Service → http://$NODE_IP:30005"
    echo "Classroom       → http://$NODE_IP:30006"
    echo "Teacher Service → http://$NODE_IP:30007"
    
    echo -e "\n${GREEN}=== Frontend ===${NC}"
    echo "Frontend        → http://$NODE_IP:30420"
    
    echo -e "\n${GREEN}=== Infrastructure ===${NC}"
    echo "PostgreSQL      → $NODE_IP:30432 (postgres/postgres)"
    echo "Redis           → $NODE_IP:30379"
    echo "RabbitMQ AMQP   → $NODE_IP:30672 (guest/guest)"
    echo "RabbitMQ UI     → http://$NODE_IP:30015 (guest/guest)"
    echo "Elasticsearch   → http://$NODE_IP:30920"
    echo "Kibana          → http://$NODE_IP:30601"
    echo "MinIO API       → http://$NODE_IP:30900"
    echo "MinIO Console   → http://$NODE_IP:30901 (minioadmin/minioadmin)"
    echo "Prometheus      → http://$NODE_IP:30090"
    echo "Grafana         → http://$NODE_IP:30300 (admin/admin)"
    
    echo -e "\n${YELLOW}💡 To deploy with NodePort:${NC}"
    echo "helm install devops-education ./helm/devops-education --namespace prod --values ./helm/devops-education/values-prod.yaml"
    
    echo -e "\n${YELLOW}💡 To check services:${NC}"
    echo "kubectl get svc -n $NAMESPACE -o wide | grep NodePort"
}

# Show all ports
show_all_ports() {
    print_section "All Available Ports & Access Points"
    
    cat << 'EOF'
┌────────────────────────────────────────────────────────────┐
│          DOCKER COMPOSE vs KUBERNETES PORTS               │
├────────────────────────────────────────────────────────────┤
│ Service              │ Docker Compose  │ Kubernetes        │
├─────────────────────┼─────────────────┼──────────────────┤
│ Gateway             │ 3000            │ 30000            │
│ Auth Service        │ 3001            │ 30001            │
│ User Service        │ 3002            │ 30002            │
│ Activity Service    │ 3003            │ 30003            │
│ Parent Service      │ 3004            │ 30004            │
│ Student Service     │ 3005            │ 30005            │
│ Classroom Service   │ 3006            │ 30006            │
│ Teacher Service     │ 3007            │ 30007            │
│ Frontend App        │ 4200            │ 30420            │
│ PostgreSQL          │ 5432            │ 30432            │
│ Redis               │ 6379            │ 30379            │
│ RabbitMQ (AMQP)     │ 5672            │ 30672            │
│ RabbitMQ (UI)       │ 15672           │ 30015            │
│ Elasticsearch       │ 9200            │ 30920            │
│ Kibana              │ 5601            │ 30601            │
│ MinIO API           │ 9000            │ 30900            │
│ MinIO Console       │ 9001            │ 30901            │
│ Prometheus          │ 9090            │ 30090            │
│ Grafana             │ 3099            │ 30300            │
└────────────────────────────────────────────────────────────┘

📊 Total Services Exposed: 20
EOF
}

# Test connectivity
test_connectivity() {
    print_section "Testing Connectivity"
    
    read -p "Test Docker Compose or Kubernetes? (docker/k8s): " type
    
    if [ "$type" = "docker" ]; then
        test_docker_compose
    elif [ "$type" = "k8s" ]; then
        test_kubernetes
    else
        print_error "Invalid choice"
    fi
}

test_docker_compose() {
    echo -e "${YELLOW}Testing Docker Compose Services...${NC}\n"
    
    for port in 3000 3001 3002 3003 3004 3005 3006 3007; do
        if curl -s http://localhost:$port/health > /dev/null; then
            print_success "Service on port $port"
        else
            print_error "Service on port $port"
        fi
    done
    
    # Frontend
    if curl -s http://localhost:4200 > /dev/null 2>&1; then
        print_success "Frontend on port 4200"
    else
        print_error "Frontend on port 4200"
    fi
    
    # Database
    if psql -h localhost -U postgres -d education -c "SELECT 1" > /dev/null 2>&1; then
        print_success "PostgreSQL on port 5432"
    else
        print_error "PostgreSQL on port 5432"
    fi
    
    # Redis
    if redis-cli -h localhost ping > /dev/null 2>&1; then
        print_success "Redis on port 6379"
    else
        print_error "Redis on port 6379"
    fi
    
    # Elasticsearch
    if curl -s http://localhost:9200/_cluster/health > /dev/null; then
        print_success "Elasticsearch on port 9200"
    else
        print_error "Elasticsearch on port 9200"
    fi
}

test_kubernetes() {
    echo -e "${YELLOW}Testing Kubernetes Services...${NC}\n"
    
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null)
    
    if [ -z "$NODE_IP" ]; then
        print_error "Could not determine Node IP"
        return 1
    fi
    
    echo "Using Node IP: $NODE_IP\n"
    
    for port in 30000 30001 30002 30003 30004 30005 30006 30007; do
        if curl -s http://$NODE_IP:$port/health > /dev/null 2>&1; then
            print_success "Service on NodePort $port"
        else
            print_error "Service on NodePort $port"
        fi
    done
    
    # Frontend
    if curl -s http://$NODE_IP:30420 > /dev/null 2>&1; then
        print_success "Frontend on NodePort 30420"
    else
        print_error "Frontend on NodePort 30420"
    fi
}

# Open in browser
open_in_browser() {
    print_section "Opening Services in Browser"
    
    read -p "Select service (gateway/frontend/grafana/kibana/prometheus/minio): " service
    
    case $service in
        gateway)
            open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "http://localhost:3000"
            ;;
        frontend)
            open http://localhost:4200 2>/dev/null || xdg-open http://localhost:4200 2>/dev/null || echo "http://localhost:4200"
            ;;
        grafana)
            open http://localhost:3099 2>/dev/null || xdg-open http://localhost:3099 2>/dev/null || echo "http://localhost:3099"
            ;;
        kibana)
            open http://localhost:5601 2>/dev/null || xdg-open http://localhost:5601 2>/dev/null || echo "http://localhost:5601"
            ;;
        prometheus)
            open http://localhost:9090 2>/dev/null || xdg-open http://localhost:9090 2>/dev/null || echo "http://localhost:9090"
            ;;
        minio)
            open http://localhost:9001 2>/dev/null || xdg-open http://localhost:9001 2>/dev/null || echo "http://localhost:9001"
            ;;
        *)
            print_error "Invalid service"
            ;;
    esac
}

# Main loop
main() {
    while true; do
        show_menu
        
        case $choice in
            1) docker_compose_access ;;
            2) kubernetes_nodeport_access ;;
            3) show_all_ports ;;
            4) test_connectivity ;;
            5) open_in_browser ;;
            6) 
                echo -e "\n${GREEN}Goodbye!${NC}\n"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please select 1-6."
                ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue...${NC}"
        read
        clear
    done
}

# Run
clear
main
