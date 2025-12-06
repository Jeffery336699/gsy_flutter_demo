# Shelf 服务器 API 测试脚本
# PowerShell 版本

Write-Host "🚀 开始测试 Shelf 服务器 API..." -ForegroundColor Green
Write-Host ""

$baseUrl = "http://localhost:3456"

# 测试 1: Hello 接口
Write-Host "📝 测试 1: Hello 接口" -ForegroundColor Cyan
Write-Host "GET /hello/Flutter" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/hello/Flutter" -Method Get
    Write-Host "✅ 响应: $response" -ForegroundColor Green
} catch {
    Write-Host "❌ 错误: $_" -ForegroundColor Red
}
Write-Host ""

# 测试 2: 用户查询接口
Write-Host "📝 测试 2: 用户查询接口" -ForegroundColor Cyan
Write-Host "GET /user?name=张三&age=25" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/user?name=张三&age=25" -Method Get
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 错误: $_" -ForegroundColor Red
}
Write-Host ""

# 测试 3: 登录接口（成功）
Write-Host "📝 测试 3: 登录接口（成功）" -ForegroundColor Cyan
Write-Host "POST /login" -ForegroundColor Yellow
try {
    $body = @{
        username = "admin"
        password = "123456"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/login" -Method Post -Body $body -ContentType "application/json"
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 错误: $_" -ForegroundColor Red
}
Write-Host ""

# 测试 4: 登录接口（失败）
Write-Host "📝 测试 4: 登录接口（失败）" -ForegroundColor Cyan
Write-Host "POST /login (错误密码)" -ForegroundColor Yellow
try {
    $body = @{
        username = "admin"
        password = "wrong_password"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/login" -Method Post -Body $body -ContentType "application/json"
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    $errorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
    Write-Host "⚠️ 预期的错误响应:" -ForegroundColor Yellow
    $errorResponse | ConvertTo-Json
}
Write-Host ""

# 测试 5: 获取产品列表
Write-Host "📝 测试 5: 获取产品列表（分页）" -ForegroundColor Cyan
Write-Host "GET /api/products?page=1&pageSize=3" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/products?page=1&pageSize=3" -Method Get
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 错误: $_" -ForegroundColor Red
}
Write-Host ""

# 测试 6: 获取产品详情
Write-Host "📝 测试 6: 获取产品详情" -ForegroundColor Cyan
Write-Host "GET /api/products/5" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/products/5" -Method Get
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 错误: $_" -ForegroundColor Red
}
Write-Host ""

# 测试 7: 更新产品
Write-Host "📝 测试 7: 更新产品" -ForegroundColor Cyan
Write-Host "PUT /api/products/5" -ForegroundColor Yellow
try {
    $body = @{
        name = "Updated Product Name"
        price = 99.99
        description = "This product has been updated"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/api/products/5" -Method Put -Body $body -ContentType "application/json"
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 错误: $_" -ForegroundColor Red
}
Write-Host ""

# 测试 8: 删除产品
Write-Host "📝 测试 8: 删除产品" -ForegroundColor Cyan
Write-Host "DELETE /api/products/5" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/products/5" -Method Delete
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 错误: $_" -ForegroundColor Red
}
Write-Host ""

# 测试 9: 404 错误
Write-Host "📝 测试 9: 404 错误处理" -ForegroundColor Cyan
Write-Host "GET /nonexistent" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/nonexistent" -Method Get
    Write-Host "✅ 响应:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    $errorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
    Write-Host "⚠️ 预期的 404 响应:" -ForegroundColor Yellow
    $errorResponse | ConvertTo-Json
}
Write-Host ""

Write-Host "🎉 所有测试完成！" -ForegroundColor Green

