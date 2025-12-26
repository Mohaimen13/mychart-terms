# How to Check if Your App is Running

## Quick Check Methods

### Method 1: Check in Browser

Open your browser and go to:
- **http://localhost:3000** - Next.js web app (if running)
- **http://localhost:8080** - Alternative port

If you see a page, the app is running! ✅

### Method 2: Check Running Processes

**PowerShell:**
```powershell
# Check for Node.js processes
Get-Process | Where-Object {$_.ProcessName -eq "node"}

# Check for Flutter processes
Get-Process | Where-Object {$_.ProcessName -like "*flutter*"}
```

### Method 3: Check Ports

**Check if port 3000 is in use:**
```powershell
netstat -ano | findstr ":3000"
```

If you see output, something is running on that port.

### Method 4: Check Terminal Output

Look at your terminal/command prompt. If you see:
- `Ready - started server on 0.0.0.0:3000` → App is running! ✅
- `Local: http://localhost:3000` → App is running! ✅
- Any error messages → App is not running ❌

## Current Status

Based on what I found:
- ✅ **Web app folder exists** (`mychart-web`)
- ✅ **Node.js processes running** (3 processes)
- ✅ **Chrome is open** (many processes)
- ❓ **Port 3000** - Checking now...

## How to Start the App

### If App is NOT Running:

**Navigate to web app:**
```powershell
cd ..\mychart-web
```

**Install dependencies (first time only):**
```powershell
npm install
```

**Start the server:**
```powershell
npm run dev
```

**Then open:** http://localhost:3000

## What You Should See

When the app is running, you should see in your terminal:
```
  ▲ Next.js 14.x.x
  - Local:        http://localhost:3000
  - Ready in X seconds
```

And in your browser:
- Next.js welcome page, or
- Your MyChart FHIR app login screen

## Troubleshooting

### "Port 3000 already in use"
```powershell
# Find what's using port 3000
netstat -ano | findstr ":3000"

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

### "Cannot find module"
```powershell
cd ..\mychart-web
npm install
```

### "Command not found: npm"
- Make sure Node.js is installed
- Restart your terminal

## Quick Status Check Command

Run this all-in-one check:

```powershell
Write-Host "=== App Status Check ===" -ForegroundColor Cyan
Write-Host "`nNode.js Processes:" -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -eq "node"} | Select-Object Id, ProcessName

Write-Host "`nPort 3000 Status:" -ForegroundColor Yellow
$port3000 = netstat -ano | findstr ":3000"
if ($port3000) {
    Write-Host "✅ Port 3000 is in use - App might be running!" -ForegroundColor Green
    Write-Host $port3000
} else {
    Write-Host "❌ Port 3000 is free - App is not running" -ForegroundColor Red
}

Write-Host "`nWeb App Folder:" -ForegroundColor Yellow
if (Test-Path "..\mychart-web") {
    Write-Host "✅ Web app folder exists" -ForegroundColor Green
} else {
    Write-Host "❌ Web app folder not found" -ForegroundColor Red
}
```

## Next Steps

1. **Check browser:** Open http://localhost:3000
2. **Check terminal:** Look for server messages
3. **If not running:** Run `npm run dev` in the web app folder

