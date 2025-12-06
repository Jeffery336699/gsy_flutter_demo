@echo off
chcp 65001 >nul
echo.
echo ========================================
echo   🚀 启动 Shelf 本地服务器
echo ========================================
echo.

cd /d "%~dp0..\.."

echo 📦 检查依赖...
call flutter pub get

echo.
echo 🌟 启动服务器...
echo 服务器地址: http://localhost:3456
echo 按 Ctrl+C 停止服务器
echo.
echo ========================================
echo.

dart lib\server_mock\main.dart

