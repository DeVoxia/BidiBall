<#
  start_project.ps1
  Script de démarrage pour BidiBall :
  - vérifie/explique ExecutionPolicy
  - détecte automatiquement le dossier du projet
  - charge une config locale machine.local.ps1 si présente
  - fait un git pull si aucun changement local
  - ouvre VS Code
  - ouvre Godot si possible
#>

# --- 1) ExecutionPolicy pour l'utilisateur courant ---
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -ne "RemoteSigned") {
    try {
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
        Write-Host "[INFO] ExecutionPolicy ajusté à RemoteSigned pour CurrentUser." -ForegroundColor Yellow
    } catch {
        Write-Host "[WARN] Impossible de changer ExecutionPolicy automatiquement." -ForegroundColor Red
        Write-Host "      Si besoin, lancer manuellement :" -ForegroundColor Red
        Write-Host "      Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned" -ForegroundColor Red
    }
}

# --- 2) Dossier du projet = dossier du script ---
$ProjectPath = $PSScriptRoot

# Par défaut, on essaiera d'utiliser la commande 'godot'
$GodotExe = $null    # pourra être surchargé par machine.local.ps1

# --- 3) Charger la config locale éventuelle ---
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

# --- 4) Git status + éventuel pull ---
$status = git status --porcelain

if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "[OK] Aucun changement local. Pull depuis GitHub..." -ForegroundColor Green
    try {
        git pull
    } catch {
        Write-Host "Erreur lors du git pull. Vérifie ta connexion ou ton auth GitHub." -ForegroundColor Red
    }
} else {
    Write-Host "[ATTENTION] Des changements locaux existent déjà :" -ForegroundColor Yellow
    git status
    Write-Host ""
    Write-Host "Le script NE fait PAS de git pull pour ne pas écraser ton travail." -ForegroundColor Yellow
    Write-Host "Avant de mettre à jour depuis GitHub, tu dois :" -ForegroundColor Yellow
    Write-Host "  - soit git add / commit / push" -ForegroundColor Yellow
    Write-Host "  - soit git stash" -ForegroundColor Yellow
    Write-Host "  - soit git reset --hard si tu veux tout annuler" -ForegroundColor Yellow
}

Write-Host ""

# --- 5) VS Code ---
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "Ouverture de VS Code..."
    Start-Process code -ArgumentList "."
} else {
    Write-Host "VS Code n'est pas dans le PATH (commande 'code' introuvable)." -ForegroundColor Yellow
}

# --- 6) Godot ---
if ($GodotExe -and (Test-Path $GodotExe)) {
    Write-Host "Ouverture de Godot via GodotExe..."
    Start-Process $GodotExe -ArgumentList "--path `"$ProjectPath`""
} elseif (Get-Command godot -ErrorAction SilentlyContinue) {
    Write-Host "Ouverture de Godot via la commande 'godot'..."
    Start-Process godot -ArgumentList "--path `"$ProjectPath`""
} else {
    Write-Host "Godot non lancé : ni GodotExe défini, ni commande 'godot' disponible." -ForegroundColor Yellow
    Write-Host "  -> Soit ajoute Godot au PATH, soit crée un machine.local.ps1 avec la variable `$GodotExe." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Script terminé ===" -ForegroundColor Cyan
