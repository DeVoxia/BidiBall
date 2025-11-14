<#
  fix_git_files.ps1
  Nettoie et sécurise .gitattributes / .gitignore dans un dépôt Git (Windows).
  - Supprime les marqueurs PowerShell type @' … '@ et les pipes accidentels
  - Réécrit un .gitattributes propre (LFS)
  - Complète .gitignore pour Godot/VS Code
  - Configure core.autocrlf=true
  - (Ré)active Git LFS et retrack les extensions clefs
  - Option: commit auto

  Usage :
    .\fix_git_files.ps1                     # sur le repo courant
    .\fix_git_files.ps1 -RepoPath "C:\...\BidiBall" -AutoCommit

#>

param(
  [string]$RepoPath = ".",
  [switch]$AutoCommit
)

$ErrorActionPreference = "Stop"

function Assert-GitRepo {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git n'est pas installé ou pas dans le PATH."
  }
  Push-Location $RepoPath
  try {
    git rev-parse --is-inside-work-tree | Out-Null
  } catch {
    Pop-Location
    throw "Le chemin '$RepoPath' n'est pas un dépôt Git."
  }
}

function Backup-IfExists($path) {
  if (Test-Path $path) {
    $bak = "$path.bak_$(Get-Date -Format yyyyMMdd_HHmmss)"
    Copy-Item $path $bak -Force
    Write-Host "Backup -> $bak"
  }
}

function Clean-Content($text) {
  # Enlève les lignes parasites dues au copier/coller PS :
  #   @'
  #   '@ | Out-File -Encoding ...
  #   tout ce qui contient "Out-File -Encoding"
  $lines = $text -split "`r?`n"
  $lines = $lines | Where-Object {
    $_.Trim() -ne "@'" -and
    (-not $_.Trim().StartsWith("'@")) -and
    ($_.IndexOf("Out-File -Encoding", [System.StringComparison]::OrdinalIgnoreCase) -lt 0)
  }
  # Retour propre (LF normal, Git gère CRLF)
  ($lines -join "`n")
}

function Ensure-GitAttributes {
  $path = ".gitattributes"
  $template = @"
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.jpeg filter=lfs diff=lfs merge=lfs -text
*.webp filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.ttf filter=lfs diff=lfs merge=lfs -text
*.otf filter=lfs diff=lfs merge=lfs -text
*.glb filter=lfs diff=lfs merge=lfs -text
*.gltf filter=lfs diff=lfs merge=lfs -text
"@

  if (Test-Path $path) {
    Backup-IfExists $path
    $raw = Get-Content $path -Raw -ErrorAction Stop
    $clean = Clean-Content $raw
    # Si après nettoyage il reste du bruit (ex: lignes vides ou '|' etc.), on écrase.
    if ($clean -match "\|" -or $clean -match "Out-File" -or $clean -match "@'") {
      $clean = $template
    } elseif ([string]::IsNullOrWhiteSpace($clean)) {
      $clean = $template
    }
    Set-Content -Path $path -Value $clean -Encoding ascii
  } else {
    Set-Content -Path $path -Value $template -Encoding ascii
  }
  Write-Host ".gitattributes OK"
}

function Ensure-GitIgnore {
  $path = ".gitignore"
  $needed = @(
    ".export/",
    ".import/",
    "mono/",
    "*.godot/editor/*",
    ".vscode/",
    ".idea/",
    "bin/",
    "release/",
    "dist/",
    "*.log"
  )
  $current = @()
  if (Test-Path $path) {
    Backup-IfExists $path
    $raw = Get-Content $path -Raw
    $clean = Clean-Content $raw
    Set-Content -Path $path -Value $clean -Encoding ascii
    $current = (Get-Content $path)
  }
  $toAdd = @()
  foreach ($line in $needed) {
    if ($current -notcontains $line) { $toAdd += $line }
  }
  if ($toAdd.Count -gt 0) {
    Add-Content -Path $path -Value ($toAdd -join "`n")
  } elseif (-not (Test-Path $path)) {
    Set-Content -Path $path -Value ($needed -join "`n") -Encoding ascii
  }
  Write-Host ".gitignore OK"
}

function Ensure-GitConfig {
  git config core.autocrlf true | Out-Null
  Write-Host "Git core.autocrlf=true"
}

function Ensure-LFS {
  try { git lfs install | Out-Null } catch { }
  # retrack pour s'assurer que les patterns LFS sont actifs
  $patterns = @("*.png","*.jpg","*.jpeg","*.webp","*.ogg","*.wav","*.mp3","*.ttf","*.otf","*.glb","*.gltf")
  foreach ($p in $patterns) {
    git lfs track $p | Out-Null
  }
  # s'assure que .gitattributes est pris en compte
  git add .gitattributes | Out-Null
  Write-Host "Git LFS OK"
}

function Do-CommitIfNeeded {
  $status = git status --porcelain
  if (-not [string]::IsNullOrWhiteSpace($status)) {
    git add .gitignore .gitattributes | Out-Null
    if ($AutoCommit) {
      git commit -m "chore: normalize .gitattributes/.gitignore + LFS + CRLF" | Out-Null
      Write-Host "Commit effectué."
    } else {
      Write-Host "Modifs en staging (non commitées). Lance: git commit -m \"chore: normalize git attrs/ignore\""
    }
  } else {
    Write-Host "Aucun changement à committer."
  }
}

# -------- MAIN --------
try {
  Assert-GitRepo
  Ensure-GitAttributes
  Ensure-GitIgnore
  Ensure-GitConfig
  Ensure-LFS
  Do-CommitIfNeeded
} finally {
  Pop-Location | Out-Null
}
