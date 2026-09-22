<#
.SYNOPSIS
  Install claude-resume-skills into Claude Code's skills folder on Windows.

.EXAMPLE
  .\install.ps1                      # all skills -> $HOME\.claude\skills (every project)
  .\install.ps1 -Project             # all skills -> .\.claude\skills   (this project only)
  .\install.ps1 ats-beater           # one skill
  .\install.ps1 -Target C:\some\dir  # custom destination
  .\install.ps1 -List                # show the skills this repo ships

  Without cloning:
  irm https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.ps1 | iex

  Re-running overwrites an installed skill with the repo's version (that is how you upgrade).
#>
param(
  [switch]$Project,
  [string]$Target,
  [switch]$List,
  [Parameter(ValueFromRemainingArguments = $true)][string[]]$Skills
)
$ErrorActionPreference = "Stop"
$RepoZip = "https://github.com/Karangarha/claude-resume-skills/archive/refs/heads/main.zip"

if (-not $Target) {
  $Target = if ($Project) { Join-Path (Get-Location) ".claude\skills" } else { Join-Path $HOME ".claude\skills" }
}

# Skills live next to this script in a clone; otherwise download the latest main branch.
$src = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "skills"))) {
  $src = Join-Path $PSScriptRoot "skills"
} else {
  $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("claude-resume-skills-" + [guid]::NewGuid())
  New-Item -ItemType Directory -Path $tmp | Out-Null
  Write-Host "Downloading $RepoZip ..."
  $zip = Join-Path $tmp "main.zip"
  Invoke-WebRequest -Uri $RepoZip -OutFile $zip
  Expand-Archive -Path $zip -DestinationPath $tmp
  $src = Get-ChildItem -Path $tmp -Directory -Recurse -Depth 2 | Where-Object { $_.Name -eq "skills" } | Select-Object -First 1 -ExpandProperty FullName
  if (-not $src) { throw "download did not contain a skills/ folder" }
}

$available = Get-ChildItem -Path $src -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } | Select-Object -ExpandProperty Name
if (-not $available) { throw "no skills found in $src" }

if ($List) {
  foreach ($s in $available) {
    $desc = (Get-Content (Join-Path $src "$s\SKILL.md") | Where-Object { $_ -match '^description:' } | Select-Object -First 1) -replace '^description:\s*', '' -replace '"', ''
    if ($desc.Length -gt 110) { $desc = $desc.Substring(0, 110) + "..." }
    "{0,-14} {1}" -f $s, $desc
  }
  return
}

if (-not $Skills) { $Skills = $available }

New-Item -ItemType Directory -Path $Target -Force | Out-Null
foreach ($s in $Skills) {
  $from = Join-Path $src $s
  if (-not (Test-Path (Join-Path $from "SKILL.md"))) { throw "no such skill: $s (available: $($available -join ', '))" }
  $to = Join-Path $Target $s
  if (Test-Path $to) { Remove-Item -Recurse -Force $to }
  Copy-Item -Recurse -Path $from -Destination $to
  Write-Host "installed  $s  ->  $to"
}

Write-Host ""
Write-Host "Done. In Claude Code, invoke a skill by name (/ats-beater, /resume-guide) or just ask."
Write-Host "ats-beater works best with poppler (pdftotext, pdffonts) and the pdfplumber Python package installed."
