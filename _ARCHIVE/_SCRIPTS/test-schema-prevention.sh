#!/bin/bash

# Test script pour vérifier que la prévention des erreurs fonctionne

echo "🧪 Testing Schema Prevention System"
echo "===================================="
echo ""

# Get activity pod
POD=$(kubectl get pods -n education -l app=activity-service -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD" ]; then
  echo "❌ Activity service pod not found!"
  exit 1
fi

echo "Pod: $POD"
echo ""

# Test 1: Health endpoint
echo "Test 1: Health Endpoint"
HEALTH=$(kubectl exec $POD -n education -- curl -s http://localhost:3003/health)
echo "Response: $HEALTH"

if echo "$HEALTH" | grep -q '"status":"UP"'; then
  echo "✅ Health check PASSED"
else
  echo "❌ Health check FAILED"
fi

echo ""

# Test 2: Readiness endpoint
echo "Test 2: Readiness Endpoint"
READY=$(kubectl exec $POD -n education -- curl -s http://localhost:3003/health/ready)
echo "Response: $READY"

if echo "$READY" | grep -q '"status":"READY"'; then
  echo "✅ Readiness check PASSED"
else
  echo "❌ Readiness check FAILED"
fi

echo ""

# Test 3: Database connectivity
echo "Test 3: Database Connectivity"
LOGS=$(kubectl logs $POD -n education --tail=20)

if echo "$LOGS" | grep -q "successfully started"; then
  echo "✅ Application started successfully"
else
  echo "❌ Application failed to start"
fi

echo ""

# Test 4: Get activities (functional test)
echo "Test 4: Functional Test - Get Activities"
ACTIVITIES=$(kubectl exec $POD -n education -- curl -s http://localhost:3003/activities)
echo "Response: $ACTIVITIES"

if echo "$ACTIVITIES" | grep -q "id"; then
  echo "✅ Activities endpoint working"
else
  echo "❌ Activities endpoint failed"
fi

echo ""
echo "===================================="
echo "✅ All tests completed!"
