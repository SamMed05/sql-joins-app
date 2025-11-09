# Quick Start - Generate Manim Animations
# PowerShell script for Windows users

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  SQL Joins Manim Animation Generator" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
Write-Host "Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python not found!" -ForegroundColor Red
    Write-Host "  Please install Python from https://www.python.org/downloads/" -ForegroundColor Red
    exit 1
}

# Check if pip is available
Write-Host "Checking pip..." -ForegroundColor Yellow
try {
    $pipVersion = pip --version 2>&1
    Write-Host "✓ pip is available" -ForegroundColor Green
} catch {
    Write-Host "✗ pip not found!" -ForegroundColor Red
    exit 1
}

# Navigate to manim_scripts directory
Write-Host ""
Write-Host "Navigating to manim_scripts directory..." -ForegroundColor Yellow
Set-Location -Path ".\manim_scripts"

# Install requirements
Write-Host ""
Write-Host "Installing Manim and dependencies..." -ForegroundColor Yellow
Write-Host "(This may take a few minutes on first run)" -ForegroundColor Gray
try {
    pip install -r requirements.txt
    Write-Host "✓ Dependencies installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Generate animations
Write-Host ""
Write-Host "Generating animations..." -ForegroundColor Yellow
Write-Host "(This will take several minutes)" -ForegroundColor Gray
try {
    python generate_all.py
    Write-Host "✓ Animations generated successfully!" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to generate animations" -ForegroundColor Red
    Write-Host "  See MANIM_SETUP.md for troubleshooting" -ForegroundColor Yellow
    exit 1
}

# Return to project root
Set-Location -Path ".."

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  ✓ Setup Complete!" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run the application:" -ForegroundColor Yellow
Write-Host "  pnpm install" -ForegroundColor White
Write-Host "  pnpm run dev" -ForegroundColor White
Write-Host ""
Write-Host "Then visit http://localhost:5173 and click on join types to see animations!" -ForegroundColor Cyan
Write-Host ""
