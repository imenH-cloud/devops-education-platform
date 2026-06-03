# Elasticsearch Setup - PowerShell

Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🔍 ELASTICSEARCH - AUTO SETUP" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

$ES_URL = "http://localhost:30920"
$headers = @{"Content-Type" = "application/json"}

# 1. Create Index
Write-Host "`n1️⃣ Creating INDEX: education-logs-2026.05.29" -ForegroundColor Green

$indexMapping = @{
    settings = @{
        number_of_shards = 1
        number_of_replicas = 0
    }
    mappings = @{
        properties = @{
            timestamp = @{type = "date"}
            service = @{type = "keyword"}
            level = @{type = "keyword"}
            message = @{type = "text"}
            user_id = @{type = "keyword"}
        }
    }
} | ConvertTo-Json

Invoke-WebRequest -Uri "$ES_URL/education-logs-2026.05.29" -Method PUT -Headers $headers -Body $indexMapping | Out-Null
Write-Host "✅ Index created" -ForegroundColor Green

# 2. Index Logs
Write-Host "`n2️⃣ Indexing 5 LOGS" -ForegroundColor Green

$logs = @(
    @{timestamp="2026-05-29T11:30:00Z"; service="user-service"; level="INFO"; message="User login successful"; user_id="user-456"},
    @{timestamp="2026-05-29T11:31:00Z"; service="auth-service"; level="INFO"; message="JWT token generated"; user_id="user-456"},
    @{timestamp="2026-05-29T11:32:00Z"; service="classroom-service"; level="ERROR"; message="Classroom not found"; user_id="user-456"},
    @{timestamp="2026-05-29T11:33:00Z"; service="activity-service"; level="INFO"; message="Activity logged: user viewed lesson"; user_id="user-456"},
    @{timestamp="2026-05-29T11:34:00Z"; service="student-service"; level="INFO"; message="Student profile updated"; user_id="user-456"}
)

$services = @("user-service", "auth-service", "classroom-service", "activity-service", "student-service")

for ($i = 0; $i -lt $logs.Count; $i++) {
    $logBody = $logs[$i] | ConvertTo-Json
    Write-Host "   • Log $($i+1): $($services[$i])" -ForegroundColor Yellow
    Invoke-WebRequest -Uri "$ES_URL/education-logs-2026.05.29/_doc" -Method POST -Headers $headers -Body $logBody | Out-Null
}

Write-Host "✅ 5 logs indexed" -ForegroundColor Green

# 3. Verify
Write-Host "`n3️⃣ Verifying logs" -ForegroundColor Green

$searchBody = @{query = @{match_all = @{}}} | ConvertTo-Json
$response = Invoke-WebRequest -Uri "$ES_URL/education-logs-2026.05.29/_search" -Method GET -Headers $headers -Body $searchBody
$total = ($response.Content | ConvertFrom-Json).hits.total.value

Write-Host "✅ Total logs: $total" -ForegroundColor Green

# 4. Search Errors
Write-Host "`n4️⃣ Searching for ERRORS" -ForegroundColor Green

$errorBody = @{query = @{match = @{level = "ERROR"}}} | ConvertTo-Json
$errorResponse = Invoke-WebRequest -Uri "$ES_URL/education-logs-2026.05.29/_search" -Method GET -Headers $headers -Body $errorBody
$errors = ($errorResponse.Content | ConvertFrom-Json).hits.total.value

Write-Host "✅ Errors found: $errors" -ForegroundColor Green

Write-Host "`n════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✅ ELASTICSEARCH SETUP COMPLETE" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`nNEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Go to http://localhost:30561 (Kibana)" -ForegroundColor White
Write-Host "2. Stack Management > Index Patterns" -ForegroundColor White
Write-Host "3. Create pattern: 'education-logs-*'" -ForegroundColor White
Write-Host "4. Go to Discover to see the logs"
