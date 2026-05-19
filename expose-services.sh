#!/bin/bash

# Expose services in education namespace with NodePort

NAMESPACE="education"
SERVICES=$(kubectl get svc -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}')

echo "Exposing services in namespace: $NAMESPACE"

for service in $SERVICES; do
  echo "Processing service: $service"
  
  # Get current service type and port
  CURRENT_TYPE=$(kubectl get svc $service -n $NAMESPACE -o jsonpath='{.spec.type}')
  PORT=$(kubectl get svc $service -n $NAMESPACE -o jsonpath='{.spec.ports[0].port}')
  
  echo "  Current type: $CURRENT_TYPE, Port: $PORT"
  
  if [ "$CURRENT_TYPE" != "NodePort" ]; then
    # Patch service to NodePort
    kubectl patch svc $service -n $NAMESPACE -p '{"spec":{"type":"NodePort"}}'
    echo "  ✓ Changed to NodePort"
    
    # Get assigned NodePort
    NODE_PORT=$(kubectl get svc $service -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
    echo "  ✓ Assigned NodePort: $NODE_PORT"
  else
    NODE_PORT=$(kubectl get svc $service -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
    echo "  ✓ Already NodePort: $NODE_PORT"
  fi
done

echo ""
echo "Services exposed. Access them via:"
kubectl get svc -n $NAMESPACE -o wide
