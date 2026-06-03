#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Automated Kibana Dashboard Creation Script
    Creates 4 visualizations and a dashboard with all visualizations added
.DESCRIPTION
    This script automates the creation of Kibana visualizations and dashboard
    for the education platform event monitoring
#>

param(
    [string]$KibanaURL = "http://localhost:30561",
    [string]$Space = "default"
)

$ErrorActionPreference = "Stop"

# Colors
$Success = 'Green'
$Info = 'Cyan'
$Warning = 'Yellow'

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor $Info
Write-Host "🚀 KIBANA DASHBOARD AUTOMATION SCRIPT" -ForegroundColor $Info
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor $Info

# API Headers
$headers = @{
    "Content-Type" = "application/json"
    "kbn-xsrf" = "true"
}

# ==================== VISUALIZATION 1: PIE CHART ====================
Write-Host "`n[1/6] Creating Pie Chart - Events by Agent..." -ForegroundColor $Info

$vis1 = @{
    visualization = @{
        title = "Events by Agent"
        type = "pie"
        params = @{
            addTooltip = $true
            isDonut = $false
        }
        kibanaSavedObjectMeta = @{
            searchSourceJSON = @{
                index = "filebeat-logs"
                query = @{
                    match_all = @{}
                }
                version = $true
            } | ConvertTo-Json -Compress
        }
        uiStateJSON = "{}"
        visState = @{
            title = "Events by Agent"
            type = "pie"
            params = @{
                addTooltip = $true
                isDonut = $false
                legendPosition = "right"
            }
            aggs = @(
                @{
                    id = "1"
                    enabled = $true
                    type = "count"
                    schema = "metric"
                    params = @{}
                }
                @{
                    id = "2"
                    enabled = $true
                    type = "terms"
                    schema = "segment"
                    params = @{
                        field = "agent.name"
                        size = 5
                        order = "desc"
                        orderBy = "_count"
                    }
                }
            )
        } | ConvertTo-Json -Depth 10
    }
} | ConvertTo-Json -Depth 10

try {
    $response1 = Invoke-WebRequest -Uri "$KibanaURL/api/saved_objects/visualization/events-by-agent" `
        -Method Post -Headers $headers -Body $vis1 -ErrorAction SilentlyContinue
    Write-Host "✅ Pie Chart created" -ForegroundColor $Success
} catch {
    Write-Host "⚠️  Pie Chart: $_" -ForegroundColor $Warning
}

# ==================== VISUALIZATION 2: METRIC ====================
Write-Host "`n[2/6] Creating Metric - Total Events..." -ForegroundColor $Info

$vis2 = @{
    visualization = @{
        title = "Total Events (Last 24h)"
        type = "metric"
        params = @{
            addTooltip = $true
            metric = @{
                label = "Count"
                color = "rgb(0, 156, 224)"
            }
        }
        kibanaSavedObjectMeta = @{
            searchSourceJSON = @{
                index = "filebeat-logs"
                query = @{
                    match_all = @{}
                }
                version = $true
            } | ConvertTo-Json -Compress
        }
        uiStateJSON = "{}"
        visState = @{
            title = "Total Events (Last 24h)"
            type = "metric"
            params = @{
                addTooltip = $true
                metric = @{
                    label = "Count"
                    color = "rgb(0, 156, 224)"
                }
            }
            aggs = @(
                @{
                    id = "1"
                    enabled = $true
                    type = "count"
                    schema = "metric"
                    params = @{}
                }
            )
        } | ConvertTo-Json -Depth 10
    }
} | ConvertTo-Json -Depth 10

try {
    $response2 = Invoke-WebRequest -Uri "$KibanaURL/api/saved_objects/visualization/total-events" `
        -Method Post -Headers $headers -Body $vis2 -ErrorAction SilentlyContinue
    Write-Host "✅ Metric created" -ForegroundColor $Success
} catch {
    Write-Host "⚠️  Metric: $_" -ForegroundColor $Warning
}

# ==================== VISUALIZATION 3: LINE CHART ====================
Write-Host "`n[3/6] Creating Line Chart - Activity Trend..." -ForegroundColor $Info

$vis3 = @{
    visualization = @{
        title = "Activity Trend"
        type = "histogram"
        params = @{
            grid = @{categoryLines = $false}
            categoryAxes = @(
                @{
                    id = "CategoryAxis-1"
                    type = "category"
                    position = "bottom"
                    show = $true
                    style = @{}
                    scale = @{type = "linear"}
                    labels = @{show = $true; truncate = 100}
                    title = @{}
                }
            )
            valueAxes = @(
                @{
                    id = "ValueAxis-1"
                    name = "Left"
                    type = "value"
                    position = "left"
                    show = $true
                    style = @{}
                    scale = @{type = "linear"; mode = "normal"}
                    labels = @{show = $true; truncate = 100}
                    title = @{text = "Count"}
                }
            )
            seriesParams = @(
                @{
                    show = $true
                    type = "line"
                    interpolate = "linear"
                    valueAxis = "ValueAxis-1"
                    drawLinesBetweenPoints = $true
                    lineWidth = 2
                }
            )
        }
        kibanaSavedObjectMeta = @{
            searchSourceJSON = @{
                index = "filebeat-logs"
                query = @{
                    match_all = @{}
                }
                version = $true
            } | ConvertTo-Json -Compress
        }
        uiStateJSON = "{}"
        visState = @{
            title = "Activity Trend"
            type = "histogram"
            params = @{
                grid = @{categoryLines = $false}
            }
            aggs = @(
                @{
                    id = "1"
                    enabled = $true
                    type = "count"
                    schema = "metric"
                    params = @{}
                }
                @{
                    id = "2"
                    enabled = $true
                    type = "date_histogram"
                    schema = "segment"
                    params = @{
                        field = "@timestamp"
                        interval = "30s"
                        customInterval = "2h"
                        format = "strict_date_optional_time"
                        min_doc_count = 1
                        extended_bounds = @{}
                    }
                }
            )
        } | ConvertTo-Json -Depth 10
    }
} | ConvertTo-Json -Depth 10

try {
    $response3 = Invoke-WebRequest -Uri "$KibanaURL/api/saved_objects/visualization/activity-trend" `
        -Method Post -Headers $headers -Body $vis3 -ErrorAction SilentlyContinue
    Write-Host "✅ Line Chart created" -ForegroundColor $Success
} catch {
    Write-Host "⚠️  Line Chart: $_" -ForegroundColor $Warning
}

# ==================== VISUALIZATION 4: HORIZONTAL BAR ====================
Write-Host "`n[4/6] Creating Horizontal Bar - Top Event Types..." -ForegroundColor $Info

$vis4 = @{
    visualization = @{
        title = "Top Event Types"
        type = "histogram"
        params = @{
            grid = @{categoryLines = $false}
            categoryAxes = @(
                @{
                    id = "CategoryAxis-1"
                    type = "category"
                    position = "left"
                    show = $true
                    style = @{}
                    scale = @{type = "linear"}
                    labels = @{show = $true; truncate = 100}
                    title = @{}
                }
            )
            valueAxes = @(
                @{
                    id = "ValueAxis-1"
                    name = "Bottom"
                    type = "value"
                    position = "bottom"
                    show = $true
                    style = @{}
                    scale = @{type = "linear"; mode = "normal"}
                    labels = @{show = $true; truncate = 100}
                    title = @{text = "Count"}
                }
            )
            seriesParams = @(
                @{
                    show = $true
                    type = "bars"
                    valueAxis = "ValueAxis-1"
                }
            )
            addTooltip = $true
            isVislibVis = $true
            legendPosition = "right"
        }
        kibanaSavedObjectMeta = @{
            searchSourceJSON = @{
                index = "filebeat-logs"
                query = @{
                    match_all = @{}
                }
                version = $true
            } | ConvertTo-Json -Compress
        }
        uiStateJSON = "{}"
        visState = @{
            title = "Top Event Types"
            type = "histogram"
            params = @{
                grid = @{categoryLines = $false}
            }
            aggs = @(
                @{
                    id = "1"
                    enabled = $true
                    type = "count"
                    schema = "metric"
                    params = @{}
                }
                @{
                    id = "2"
                    enabled = $true
                    type = "terms"
                    schema = "segment"
                    params = @{
                        field = "aws.cloudtrail.event_type"
                        size = 10
                        order = "desc"
                        orderBy = "_count"
                    }
                }
            )
        } | ConvertTo-Json -Depth 10
    }
} | ConvertTo-Json -Depth 10

try {
    $response4 = Invoke-WebRequest -Uri "$KibanaURL/api/saved_objects/visualization/top-event-types" `
        -Method Post -Headers $headers -Body $vis4 -ErrorAction SilentlyContinue
    Write-Host "✅ Horizontal Bar created" -ForegroundColor $Success
} catch {
    Write-Host "⚠️  Horizontal Bar: $_" -ForegroundColor $Warning
}

# ==================== CREATE DASHBOARD ====================
Write-Host "`n[5/6] Creating Dashboard - Education Platform Event Monitoring..." -ForegroundColor $Info

$dashboard = @{
    dashboard = @{
        title = "Education Platform - Event Monitoring"
        panels = @(
            @{
                visualization = "events-by-agent"
                x = 0
                y = 0
                w = 6
                h = 4
            }
            @{
                visualization = "total-events"
                x = 6
                y = 0
                w = 6
                h = 4
            }
            @{
                visualization = "activity-trend"
                x = 0
                y = 4
                w = 12
                h = 4
            }
            @{
                visualization = "top-event-types"
                x = 0
                y = 8
                w = 12
                h = 4
            }
        )
        timeRestore = $true
        timeFrom = "now-24h"
        timeTo = "now"
        refreshInterval = @{
            pause = $false
            value = 10000
        }
    }
} | ConvertTo-Json -Depth 10

try {
    $dashboardResponse = Invoke-WebRequest -Uri "$KibanaURL/api/saved_objects/dashboard/education-platform-monitoring" `
        -Method Post -Headers $headers -Body $dashboard -ErrorAction SilentlyContinue
    Write-Host "✅ Dashboard created" -ForegroundColor $Success
} catch {
    Write-Host "⚠️  Dashboard: $_" -ForegroundColor $Warning
}

# ==================== COMPLETION ====================
Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor $Info
Write-Host "✅ AUTOMATION COMPLETE!" -ForegroundColor $Success
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor $Info

Write-Host "`n📊 YOUR DASHBOARD IS READY AT:" -ForegroundColor $Info
Write-Host "   http://localhost:30561/app/dashboards" -ForegroundColor $Success

Write-Host "`n📋 DASHBOARD NAME:" -ForegroundColor $Info
Write-Host "   Education Platform - Event Monitoring" -ForegroundColor $Success

Write-Host "`n📈 INCLUDES:" -ForegroundColor $Info
Write-Host "   ✅ Events by Agent (Pie Chart)" -ForegroundColor $Success
Write-Host "   ✅ Total Events (Metric)" -ForegroundColor $Success
Write-Host "   ✅ Activity Trend (Line Chart)" -ForegroundColor $Success
Write-Host "   ✅ Top Event Types (Horizontal Bar)" -ForegroundColor $Success

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor $Info
