<#
  diag_install_correct.ps1
  Diagnostic de l'environnement BidiBall sur cette machine :
  - Git installé
  - GitHub CLI installé + authentification
  - Depot Git present
  - Remote origin GitHub correct
  - Git LFS actif et fichiers LFS presents
  - Godot 4.x detecte
  - VS Code disponible
  - project.godot present

  Usage :
    .\diag_install_correct.ps1
#>

$ErrorActionPreference = "SilentlyContinue"

function Test-Command($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Check($ok, $label) {
    if ($ok) {
        Write-Host ("[OK]  " + $label) -ForegroundColor Green
    } else {
        Write-Host ("[NOK] " + $label) -ForegroundColor Red
    }
}

Write-Host "==== Diagnostic environnement BidiBall ===="

# 1) Git
$git_ok = Test-Command "git"
Check $git_ok "Git installe"
if ($git_ok) {
    git --version
} else {
    Write-Host "Installer Git : https://git-scm.com/download/win" -ForegroundColor Yellow
}

# 2) GitHub CLI
$gh_ok = Test-Command "gh"
Check $gh_ok "GitHub CLI (gh) installe"
if ($gh_ok) {
    $auth = gh auth status 2>&1
    if ($auth -match "Logged in to github.com") {
        Check $true "Authentification GitHub CLI OK"
    } else {
        Check $false "GitHub CLI pas connecte (gh auth login)"
    }
} else {
    Write-Host "GitHub CLI non installe (optionnel mais pratique)." -ForegroundColor Yellow
    Write-Host "Commande d'installation (winget) : winget install GitHub.cli"
}

# 3) Depot Git
$repo_ok = $false
try {
    git rev-parse --is-inside-work-tree | Out-Null
    $repo_ok = $true
} catch {
    $repo_ok = $false
}
Check $repo_ok "Dans un depot Git"
if (-not $repo_ok) {
    Write-Host "Aller dans le dossier du projet, par exemple:" -ForegroundColor Yellow
    Write-Host "  cd C:\Projets\Godot\BidiBall"
    Write-Host "Puis relancer le script."
    exit
}

# 4) Remote GitHub
$remote = git remote get-url origin 2>$null
$remote_ok = $false
if ($remote) {
    $remote_ok = $remote -match "github.com"
}
Check $remote_ok "Remote origin pointe vers GitHub"
if ($remote_ok) {
    Write-Host "Remote origin : $remote"
} else {
    Write-Host "Verifier/ajouter le remote, par exemple :" -ForegroundColor Yellow
    Write-Host "  git remote add origin https://github.com/DeVoxia/BidiBall.git"
}

# 5) Git LFS
$lfs_ok = $false
try {
    git lfs version | Out-Null
    $lfs_ok = $true
} catch {
    $lfs_ok = $false
}
Check $lfs_ok "Git LFS installe"
if ($lfs_ok) {
    git lfs install | Out-Null
    $lfs_files = git lfs ls-files 2>$null
    $lfs_files_ok = ($lfs_files -and $lfs_files.Length -gt 0)
    Check $lfs_files_ok "Fichiers LFS presentes"
    if (-not $lfs_files_ok) {
        Write-Host "Si besoin, lancer : git lfs pull" -ForegroundColor Yellow
    }
} else {
    Write-Host "Installer Git LFS si des assets sont manquants." -ForegroundColor Yellow
}

# 6) Godot
$godot_ok = Test-Command "godot"
$godot_exe = $null
if (-not $godot_ok) {
    try {
        $godot_exe = Get-ChildItem -Path "C:\" -Filter "Godot_v4*.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    } catch {
        $godot_exe = $null
    }
}

$godot_detecte = $godot_ok -or $godot_exe
Check $godot_detecte "Godot 4.x detecte"
if ($godot_ok) {
    godot --version
} elseif ($godot_exe) {
    Write-Host ("Godot trouve a : " + $godot_exe.FullName) -ForegroundColor Yellow
} else {
    Write-Host "Godot non trouve. Placer l'exe dans un dossier fixe (ex: C:\Tools\Godot) et/ou ajouter au PATH." -ForegroundColor Yellow
}

# 7) project.godot
$proj_ok = Test-Path "./project.godot"
Check $proj_ok "Fichier project.godot present"
if (-not $proj_ok) {
    Write-Host "Verifier que vous etes bien dans le dossier racine du projet Godot." -ForegroundColor Yellow
}

# 8) VS Code
$code_ok = Test-Command "code"
Check $code_ok "VS Code installe"
if ($code_ok) {
    Write-Host "Pour ouvrir le projet dans VS Code : code ." -ForegroundColor Cyan
} else {
    Write-Host "Installer VS Code : https://code.visualstudio.com" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==== Diagnostic termine ====" -ForegroundColor Cyan
