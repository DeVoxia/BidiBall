<#
  save_bidiball.ps1
  Sauvegarde le travail courant :
  - git status
  - si des changements -> git add -A + commit + push
#>

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
    Write-Host "Erreur lors du git push. Vérifie la connexion ou les droits." -ForegroundColor Red
}

Write-Host "=== Script terminé ===" -ForegroundColor Cyan
