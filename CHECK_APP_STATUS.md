# How to Check if App is Running

## Check Web App (React/Next.js)

### 1. Check if Web App Exists

```powershell
# Check if web app folder exists
Test-Path "..\mychart-web"
```

### 2. Check if Server is Running

**Check for Node.js process:**
```powershell
Get-Process | Where-Object {$_.ProcessName -like "*node*"}
```

**Check if port 3000 is in use (Next.js default):**
```powershell
netstat -ano | findstr ":3000"
```

### 3. Check Browser

Open your browser and go to:
- **http://localhost:3000** (Next.js default)
- **http://localhost:8080** (if using different port)

## Check Flutter App

### 1. Check Flutter Process

```powershell
Get-Process | Where-Object {$_.ProcessName -like "*flutter*"}
```

### 2. Check if Flutter Web is Running

Flutter web typically runs on:
- **http://localhost:xxxxx** (random port)

Check your terminal for the URL.

## How to Start the App

### Start Web App (React/Next.js)

```powershell
# Navigate to web app
cd ..\mychart-web

# Install dependencies (first time only)
npm install

# Start development server
npm run dev
```

Then open: **http://localhost:3000**

### Start Flutter Web App

```powershell
cd c:\mychart_fhir_app

# Run in Chrome (with workaround)
C:\flutter\bin\flutter.bat --no-version-check run -d chrome
```

## Quick Status Check

Run this to check everything:

```powershell
# Check Node.js processes
Write-Host "=== Node.js Processes ===" -ForegroundColor Green
Get-Process | Where-Object {$_.ProcessName -like "*node*"} | Select-Object ProcessName, Id

# Check Flutter processes  
Write-Host "`n=== Flutter Processes ===" -ForegroundColor Green
Get-Process | Where-Object {$_.ProcessName -like "*flutter*"} | Select-Object ProcessName, Id

# Check ports
Write-Host "`n=== Port 3000 (Next.js) ===" -ForegroundColor Green
netstat -ano | findstr ":3000"

Write-Host "`n=== Port 8080 ===" -ForegroundColor Green
netstat -ano | findstr ":8080"
```

## Current Status

Based on your setup:
- ❌ **Web app not created yet** (Next.js creation timed out)
- ❌ **Flutter not working** (installation issues)
- ✅ **Node.js installed** (v24.12.0)
- ✅ **npm installed** (v11.6.2)

## Next Steps

Would you like me to:
1. **Create the web app manually** (create files step by step)?
2. **Try creating Next.js app again** (might work this time)?
3. **Create a simple HTML/JS version** (works immediately, no build needed)?

Let me know which you prefer!

