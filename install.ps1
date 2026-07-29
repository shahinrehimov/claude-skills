# claude-skills - skilleri ~/.claude/skills/ icine qurasdirir (Windows)
# Istifade:  .\install.ps1            (movcud eyniadli skil uzerine yazilmir)
#            .\install.ps1 -Force     (uzerine yazir)

param([switch]$Force)

$ErrorActionPreference = "Stop"

$repoSkills = Join-Path $PSScriptRoot "skills"
$target = Join-Path $env:USERPROFILE ".claude\skills"

if (-not (Test-Path $repoSkills)) {
    Write-Host "XETA: skills/ qovlugu tapilmadi: $repoSkills" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Write-Host "Yaradildi: $target"
}

$qurulan = 0
$atlandi = 0

foreach ($skill in Get-ChildItem $repoSkills -Directory) {
    $dest = Join-Path $target $skill.Name
    if ((Test-Path $dest) -and -not $Force) {
        Write-Host ("ATLANDI  {0}  (artiq var - uzerine yazmaq ucun -Force)" -f $skill.Name) -ForegroundColor Yellow
        $atlandi++
        continue
    }
    Copy-Item -Recurse -Force $skill.FullName $target
    Write-Host ("QURULDU  {0}" -f $skill.Name) -ForegroundColor Green
    $qurulan++
}

Write-Host ""
Write-Host ("Netice: {0} qurashdirildi, {1} atlandi." -f $qurulan, $atlandi)
Write-Host "Claude Code-u yeniden baslat, sonra /context ile yoxla."
