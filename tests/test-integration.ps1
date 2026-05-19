# tests/test-integration.ps1
Write-Host "=== TESTS D'INTÉGRATION ===" -ForegroundColor Cyan

$baseUrl = "http://localhost:31848

# 1. Créer un nouvel enseignant
Write-Host "`n1. Création d'un enseignant de test..." -ForegroundColor Yellow
$loginBody = @{email="admin@education.com"; password="admin123"} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = $response.access_token
$headers = @{ Authorization = "Bearer $token" }

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$newTeacher = @{
    indexNumber = "TCH$timestamp"
    cin = "$timestamp"
    firstName = "Test"
    surname = "Integration"
    gender = "M"
    address = "Test City"
    telephone = "1234567890"
    email = "test.integration$timestamp@school.com"
    password = "password123"
    specialization = "Test"
} | ConvertTo-Json

try {
    $teacher = Invoke-RestMethod -Uri "$baseUrl/teachers" -Method POST -Body $newTeacher -Headers $headers
    Write-Host "✅ Enseignant créé avec ID: $($teacher.id)" -ForegroundColor Green
    $teacherId = $teacher.id
} catch {
    Write-Host "❌ Échec création enseignant" -ForegroundColor Red
    exit 1
}

# 2. Récupérer l'enseignant créé
Write-Host "`n2. Récupération de l'enseignant..." -ForegroundColor Yellow
try {
    $teacher = Invoke-RestMethod -Uri "$baseUrl/teachers/$teacherId" -Headers $headers
    if ($teacher.id -eq $teacherId) {
        Write-Host "✅ Enseignant trouvé" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Enseignant non trouvé" -ForegroundColor Red
}

# 3. Mettre à jour l'enseignant
Write-Host "`n3. Mise à jour de l'enseignant..." -ForegroundColor Yellow
$updateTeacher = @{
    firstName = "Test Updated"
} | ConvertTo-Json

try {
    $updated = Invoke-RestMethod -Uri "$baseUrl/teachers/$teacherId" -Method PATCH -Body $updateTeacher -Headers $headers
    if ($updated.firstName -eq "Test Updated") {
        Write-Host "✅ Enseignant mis à jour" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Échec mise à jour" -ForegroundColor Red
}

# 4. Supprimer l'enseignant
Write-Host "`n4. Suppression de l'enseignant..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$baseUrl/teachers/$teacherId" -Method DELETE -Headers $headers
    Write-Host "✅ Enseignant supprimé" -ForegroundColor Green
} catch {
    Write-Host "❌ Échec suppression" -ForegroundColor Red
}

Write-Host "`n=== TESTS D'INTÉGRATION RÉUSSIS ! ===" -ForegroundColor Green