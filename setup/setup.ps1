# Exit on error
$ErrorActionPreference = "Stop"

Write-Host "Installing system dependencies..." -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Please run this script as Administrator" -ForegroundColor Red
    exit 1
}

# Install Make using Chocolatey
Write-Host "Installing Make..." -ForegroundColor Green
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
choco install make -y

# Install Python 3.12
Write-Host "Installing Python 3.12..." -ForegroundColor Green
$pythonUrl = "https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe"
$pythonInstaller = "$env:TEMP\python-3.12.2-amd64.exe"
Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller
Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=1" -Wait
Remove-Item $pythonInstaller

# Install Node.js
Write-Host "Installing Node.js..." -ForegroundColor Green
$nodeUrl = "https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi"
$nodeInstaller = "$env:TEMP\node-v20.11.1-x64.msi"
Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $nodeInstaller, "/quiet", "/norestart" -Wait
Remove-Item $nodeInstaller

# Install Docker Desktop
Write-Host "Installing Docker Desktop..." -ForegroundColor Green
$dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
$dockerInstaller = "$env:TEMP\DockerDesktopInstaller.exe"
Invoke-WebRequest -Uri $dockerUrl -OutFile $dockerInstaller
Start-Process -FilePath $dockerInstaller -ArgumentList "install", "--quiet" -Wait
Remove-Item $dockerInstaller

# Install Vercel CLI
Write-Host "Installing Vercel CLI..." -ForegroundColor Green
npm install -g vercel

Write-Host "System dependencies installed successfully!" -ForegroundColor Green
Write-Host "You can now proceed with setting up the project environment." -ForegroundColor Green

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 