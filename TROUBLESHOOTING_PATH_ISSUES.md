# Troubleshooting PATH Issues

## Error: "Contact your system administrator for more info"

This error typically occurs when:
- System policies prevent modifying environment variables
- Insufficient permissions
- Corporate/enterprise system restrictions

## Solutions

### Solution 1: Use User-Level PATH (Recommended)

Instead of system-level PATH, add Flutter to your **user-level PATH**:

1. Press `Windows + R`
2. Type: `rundll32 sysdm.cpl,EditEnvironmentVariables` and press Enter
3. In the **User variables** section (top half), find **Path**
4. Click **Edit**
5. Click **New** and add: `C:\flutter\bin`
6. Click **OK** on all dialogs
7. **Restart your terminal/PowerShell**

### Solution 2: Use PowerShell (User-Level)

Open PowerShell (not as Administrator) and run:

```powershell
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$currentPath;C:\flutter\bin", "User")
```

Then close and reopen PowerShell.

### Solution 3: Temporary PATH (For Current Session)

If you can't modify PATH permanently, you can add it temporarily for each session:

**In PowerShell:**
```powershell
$env:Path += ";C:\flutter\bin"
```

**In Command Prompt:**
```cmd
set PATH=%PATH%;C:\flutter\bin
```

**Note:** This only works for the current terminal session. You'll need to run this every time you open a new terminal.

### Solution 4: Use Full Path to Flutter

Instead of adding to PATH, use the full path to Flutter commands:

```bash
C:\flutter\bin\flutter.bat --version
C:\flutter\bin\flutter.bat doctor
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat run
```

### Solution 5: Create a Batch File (Workaround)

Create a shortcut script to make it easier:

1. Create a file: `c:\mychart_fhir_app\run_flutter.bat`
2. Add this content:
   ```batch
   @echo off
   set PATH=%PATH%;C:\flutter\bin
   flutter %*
   ```
3. Use it like: `run_flutter.bat pub get`

## Verify Flutter Works

After trying any solution above, test:

```bash
# If added to PATH:
flutter --version

# If using full path:
C:\flutter\bin\flutter.bat --version

# If using temporary PATH:
# (First run: $env:Path += ";C:\flutter\bin" in PowerShell)
flutter --version
```

## Check Current PATH

To see if Flutter is in your PATH:

**PowerShell:**
```powershell
$env:Path -split ';' | Select-String "flutter"
```

**Command Prompt:**
```cmd
echo %PATH% | findstr flutter
```

## Alternative: Use Flutter from Current Directory

You can also create a local script in your project:

1. Create `flutter_wrapper.bat` in your project root:
   ```batch
   @echo off
   C:\flutter\bin\flutter.bat %*
   ```

2. Use it:
   ```bash
   .\flutter_wrapper.bat pub get
   .\flutter_wrapper.bat run
   ```

## For Your Project

Since you're in `c:\mychart_fhir_app`, you can:

**Option A: Use full path**
```bash
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat doctor
C:\flutter\bin\flutter.bat run
```

**Option B: Add to PATH temporarily (each session)**
```powershell
$env:Path += ";C:\flutter\bin"
flutter pub get
flutter doctor
flutter run
```

## Next Steps

1. Try Solution 1 (User-level PATH) first
2. If that doesn't work, use Solution 4 (full path) or Solution 3 (temporary PATH)
3. Once Flutter works, proceed with `flutter pub get` and `flutter run`

## Still Having Issues?

If none of these work:
- Check if you're on a corporate/restricted system
- Contact your IT administrator
- Consider using Flutter from a different location (like a user folder)
- Use Flutter via full path for now

