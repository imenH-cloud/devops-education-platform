-- Fix Activity table schema
-- Add missing classroomId column if it doesn't exist

ALTER TABLE activity
ADD COLUMN IF NOT EXISTS classroomId INTEGER;

-- Add foreign key constraint if it doesn't exist
ALTER TABLE activity
ADD CONSTRAINT fk_activity_classroom FOREIGN KEY (classroomId) 
REFERENCES classroom(id) ON DELETE SET NULL;

-- Verify the fix
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'activity'
ORDER BY ordinal_position;
