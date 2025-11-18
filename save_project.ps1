<#
  save_project.ps1
  Sauvegarde le travail courant de BidiBall :
  - vérifie ExecutionPolicy
  - se place dans le dossier du projet
  - si des changements -> git add -A + commit + push
#>

# 1) ExecutionPolicy pour l'utilisateur
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -ne "RemoteSigned") {
    try {
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
        Write-Host "[INFO] ExecutionPolicy ajusté à RemoteSigned pour CurrentUser." -ForegroundColor Yellow
    } catch {
        Write-Host "[WARN] Impossible de changer ExecutionPolicy automatiquement." -ForegroundColor Red
    }
}

# 2) Projet = dossier du script
$ProjectPath = $PSScriptRoot
Set-Location $ProjectPath

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git n'est pas installé ou pas dans le PATH." -ForegroundColor Red
    exit 1
}

Write-Host "=== BidiBall - save script ===" -ForegroundColor Cyan
git status

$status = git status --porcelain

if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "Aucun changement à sauvegarder." -ForegroundColor Green
    exit 0
}

$msg = Read-Host "Message de commit"
if ([string]::IsNullOrWhiteSpace($msg)) {
    $msg = "chore: save work in progress"
}

git add -A
git commit -m "$msg"

try {
    git push
    Write-Host "Modifications poussées sur GitHub." -ForegroundColor Green
} catch {
    Write-Host "Erreur lors du git push. Vérifie ta connexion ou tes droits." -ForegroundColor Red
}

Write-Host "=== Script terminé ===" -ForegroundColor Cyan
