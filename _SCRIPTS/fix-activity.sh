#!/bin/bash

# Get postgres pod name
POD=$(kubectl get pods -n education -l app=postgres -o jsonpath='{.items[0].metadata.name}')

# Execute the fix
kubectl exec -n education $POD -- bash -c 'PGPASSWORD=postgres psql -U postgres -d education << SQL
ALTER TABLE activity ADD COLUMN IF NOT EXISTS classroomId INTEGER;
ALTER TABLE activity ADD CONSTRAINT fk_activity_classroom FOREIGN KEY (classroomId) REFERENCES classroom(id) ON DELETE SET NULL;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '"'"'activity'"'"' ORDER BY ordinal_position;
SQL
'

echo "✅ Activity table schema fixed!"
