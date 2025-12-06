# Shelf 本地服务器启动脚本 (PowerShell)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🚀 启动 Shelf 本地服务器" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到项目根目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
Set-Location $projectRoot

Write-Host "📦 检查依赖..." -ForegroundColor Yellow
flutter pub get | Out-Null

Write-Host ""
Write-Host "🌟 启动服务器..." -ForegroundColor Green
Write-Host "服务器地址: " -NoNewline
Write-Host "http://localhost:3456" -ForegroundColor Cyan
Write-Host "按 " -NoNewline
Write-Host "Ctrl+C" -ForegroundColor Yellow -NoNewline
Write-Host " 停止服务器"
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

dart lib\server_mock\main.dart

