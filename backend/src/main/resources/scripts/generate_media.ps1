# Media Assets Generator for LeEnglish TOEIC Platform - PowerShell Script
# Run this script to generate sample images and audio files

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [switch]$InstallDeps
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "MEDIA ASSETS GENERATOR FOR LEENGLISH TOEIC PLATFORM - BACKEND" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
try {
    $pythonVersion = python --version 2>$null
    Write-Host "✅ Python found: $pythonVersion" -ForegroundColor Green
}
catch {
    Write-Host "❌ Python not found. Please install Python 3.7+ from:" -ForegroundColor Red
    Write-Host "   https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Install dependencies if requested
if ($InstallDeps) {
    Write-Host "📦 Installing Python dependencies..." -ForegroundColor Yellow
    pip install -r requirements.txt
    Write-Host ""
}

# Check dependencies
Write-Host "📦 Checking dependencies..." -ForegroundColor Yellow

$dependencies = @("PIL", "gtts", "pydub")
$missing = @()

foreach ($dep in $dependencies) {
    try {
        python -c "import $dep" 2>$null
        Write-Host "✅ $dep installed" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  $dep not installed" -ForegroundColor Yellow
        $missing += $dep
    }
}

if ($missing.Count -gt 0) {
    Write-Host ""
    Write-Host "Missing dependencies detected. Install with:" -ForegroundColor Yellow
    Write-Host "  pip install Pillow gtts pydub" -ForegroundColor Cyan
    Write-Host ""
    $response = Read-Host "Install now? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        pip install Pillow gtts pydub
    }
    else {
        Write-Host "⚠️  Some features may not work without dependencies" -ForegroundColor Yellow
    }
}

Write-Host ""

# Build command arguments
$scriptArgs = @()
if ($DryRun) {
    $scriptArgs += "--dry-run"
    Write-Host "🔍 Running in DRY RUN mode - no files will be created" -ForegroundColor Yellow
}
if ($Verbose) {
    $scriptArgs += "--verbose"
}

# Run the generator
Write-Host "🚀 Starting media assets generation..." -ForegroundColor Cyan
Write-Host ""

try {
    if ($scriptArgs.Count -gt 0) {
        python generate_media_assets.py @scriptArgs
    }
    else {
        python generate_media_assets.py
    }
    
    Write-Host ""
    Write-Host "✅ Generation complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Check the following directories for generated files:" -ForegroundColor Cyan
    Write-Host "   - backend/src/main/resources/static/" -ForegroundColor Gray
    Write-Host "   - frontend/public/" -ForegroundColor Gray
    Write-Host "   - mobile/assets/" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📄 See media_generation_report.md for details" -ForegroundColor Cyan
    
}
catch {
    Write-Host "❌ Error during generation: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Try running with -Verbose for more details" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"
