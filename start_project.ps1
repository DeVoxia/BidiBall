<#
  start_bidiball.ps1
  Script de démarrage pour BidiBall :
  - détecte automatiquement le dossier du projet
  - charge une config locale machine.local.ps1 si présente
  - fait un git pull si aucun changement local
  - ouvre VS Code
  - ouvre Godot si configuré
#>

# Dossier du projet = dossier du script
$ProjectPath = $PSScriptRoot

# Valeur par défaut : on utilise la commande "godot" si disponible
$GodotExe = $null   # sera éventuellement surchargé par machine.local.ps1

# Charger config locale si présente (non versionnée)
$LocalConfig = Join-Path $ProjectPath "machine.local.ps1"
if (Test-Path $LocalConfig) {
    . $LocalConfig
}

Set-Location $ProjectPath

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git n'est pas installé ou pas dans le PATH." -ForegroundColor Red
    exit 1
}

Write-Host "=== BidiBall - start script ===" -ForegroundColor Cyan
Write-Host "Dossier : $ProjectPath"
Write-Host ""

$status = git status --porcelain

if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "[OK] Aucun changement local. Pull depuis GitHub..." -ForegroundColor Green
    try {
        git pull
    } catch {
        Write-Host "Erreur lors du git pull. Vérifie ta connexion." -ForegroundColor Red
    }
} else {
    Write-Host "[ATTENTION] Des changements locaux existent déjà :" -ForegroundColor Yellow
    git status
    Write-Host ""
    Write-Host "Pas de git pull automatique pour ne pas écraser ton travail." -ForegroundColor Yellow
}

Write-Host ""
# Ouvrir VS Code
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "Ouverture de VS Code..."
    Start-Process code -ArgumentList "."
} else {
    Write-Host "VS Code n'est pas dans le PATH (commande 'code' introuvable)." -ForegroundColor Yellow
}

# Ouvrir Godot
if ($GodotExe -and (Test-Path $GodotExe)) {
    Write-Host "Ouverture de Godot (via GodotExe)..."
    Start-Process $GodotExe -ArgumentList "--path `"$ProjectPath`""
} elseif (Get-Command godot -ErrorAction SilentlyContinue) {
    Write-Host "Ouverture de Godot (via commande 'godot')..."
    Start-Process godot -ArgumentList "--path `"$ProjectPath`""
} else {
    Write-Host "Godot non lancé (ni GodotExe défini, ni commande 'godot')." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Script terminé ===" -ForegroundColor Cyan
