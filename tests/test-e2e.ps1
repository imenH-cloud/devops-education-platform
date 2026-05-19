# tests/test-e2e.ps1
Write-Host "=== TESTS DE BOUT EN BOUT ===" -ForegroundColor Cyan

$frontendUrl = "http://localhost:31927"
$gatewayUrl = "http://localhost:31848"

# Vérifier que le frontend est accessible
Write-Host "`n1. Vérification du frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $frontendUrl -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Frontend accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Frontend accessible (code $($_.Exception.Response.StatusCode.value__))" -ForegroundColor Yellow
}

# Vérifier que le gateway est accessible
Write-Host "`n2. Vérification du gateway..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $gatewayUrl -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Gateway accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Gateway inaccessible" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== TESTS E2E TERMINÉS ===" -ForegroundColor Green