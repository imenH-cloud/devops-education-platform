#!/bin/bash

SERVICES=("activity-service" "auth-service" "classroom-service" "gateway-backend" "parent-service" "postgres" "prometheus-service" "student-service" "teacher-service" "user-service")

for svc in ${SERVICES[@]}; do
  kubectl patch svc $svc -n education --type='json' -p='[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
done

echo "Done! Checking services:"
kubectl get svc -n education -o wide