# HireHub Build & Deployment Script for Apache Tomcat 9
$ErrorActionPreference = "Stop"

$workspaceDir = "f:\HireHub"
$tomcatPath = "C:\Users\ANUJ KANDALKAR\Downloads\apache-tomcat-9.0.117-windows-x64\apache-tomcat-9.0.117"
$deployDir = Join-Path $tomcatPath "webapps\HireHub"

Write-Host "==> 1. Ensuring compilation output directories..."
if (-not (Test-Path "$workspaceDir\WebContent\WEB-INF\classes")) {
    New-Item -ItemType Directory -Path "$workspaceDir\WebContent\WEB-INF\classes" -Force | Out-Null
}
if (-not (Test-Path "$workspaceDir\src\main\webapp\WEB-INF\classes")) {
    New-Item -ItemType Directory -Path "$workspaceDir\src\main\webapp\WEB-INF\classes" -Force | Out-Null
}

Write-Host "==> 2. Compiling Java Source Files..."
Set-Location $workspaceDir
cmd /c "dir /s /b src\main\java\*.java > sources.txt && javac -encoding UTF-8 -d WebContent\WEB-INF\classes -cp WebContent\WEB-INF\lib\* @sources.txt"

Write-Host "==> 3. Synchronizing classes between WebContent and src/main/webapp..."
Copy-Item -Path "$workspaceDir\WebContent\WEB-INF\classes\*" -Destination "$workspaceDir\src\main\webapp\WEB-INF\classes" -Recurse -Force

Write-Host "==> 4. Deploying to Tomcat webapps/HireHub..."
if (-not (Test-Path $deployDir)) {
    New-Item -ItemType Directory -Path $deployDir -Force | Out-Null
}
Copy-Item -Path "$workspaceDir\WebContent\*" -Destination $deployDir -Recurse -Force

Write-Host "==> Deployment Complete! Target: $deployDir"
