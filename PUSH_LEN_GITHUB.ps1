$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
Write-Host '=== AIX UNETI12 - DAY MA NGUON LEN GITHUB ===' -ForegroundColor Green
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Host 'Chua cai Git. Cai tai https://git-scm.com/downloads/win' -ForegroundColor Red
  exit 1
}
$url = Read-Host 'Dan URL HTTPS repository GITHUB DA TAO (vi du https://github.com/user/UNETI12-AIX-AI02.git)'
if ($url -notmatch '^https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:\.git)?/?$') {
  Write-Host 'URL khong hop le. Chi nhan https://github.com/user/repository.git' -ForegroundColor Red
  exit 1
}
if (-not (Test-Path '.git')) { git init; if ($LASTEXITCODE -ne 0) { exit 1 } }
git add .
if ($LASTEXITCODE -ne 0) { exit 1 }
$changes = git status --porcelain
if ($changes) {
  git commit -m 'Publish AI02 green school website'
  if ($LASTEXITCODE -ne 0) {
    Write-Host 'Commit loi. Hay cau hinh: git config --global user.name "Ten" va git config --global user.email "email"' -ForegroundColor Yellow
    exit 1
  }
}
git branch -M main
if ($LASTEXITCODE -ne 0) { exit 1 }
$remote = git remote
if ($remote -contains 'origin') {
  $current = git remote get-url origin
  if ($current -ne $url) {
    Write-Host "Remote hien tai: $current" -ForegroundColor Yellow
    $confirm = Read-Host 'Thay origin bang URL moi? (y/N)'
    if ($confirm -notin @('y','Y')) { exit 1 }
    git remote set-url origin $url
  }
} else { git remote add origin $url }
if ($LASTEXITCODE -ne 0) { exit 1 }
git push -u origin main
if ($LASTEXITCODE -ne 0) {
  Write-Host 'Push that bai. Kiem tra repository rong, quyen truy cap, dang nhap GitHub.' -ForegroundColor Red
  exit 1
}
Write-Host 'DA DAY MA NGUON! Vao Settings > Pages > Source: GitHub Actions.' -ForegroundColor Green
