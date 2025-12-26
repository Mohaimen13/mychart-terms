# Fixing Flutter Installation Issues

## Problem: "The system cannot find the path specified" / "Flutter SDK is not available"

This error indicates your Flutter installation is incomplete or corrupted.

## Solution 1: Verify Installation Completeness

Check if all required folders exist in `C:\flutter`:

**Required folders:**
- `bin\` - Flutter executables
- `packages\` - Flutter packages
- `cache\` - Flutter cache
- `dev\` - Development tools
- `examples\` - Example apps

## Solution 2: Re-download and Reinstall Flutter

### Step 1: Delete Current Installation

1. **Close all terminals/IDEs** using Flutter
2. **Delete the Flutter folder:**
   - Delete `C:\flutter` completely
   - Or rename it to `C:\flutter_old` as backup

### Step 2: Fresh Download

1. Go to: [https://docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
2. Download the **latest stable** Flutter SDK ZIP file
3. **Extract to `C:\flutter`** (make sure it extracts directly, not into a subfolder)

### Step 3: Verify Extraction

After extraction, you should have:
```
C:\flutter\
├── bin\
│   ├── flutter.bat
│   ├── dart.bat
│   └── ...
├── packages\
├── cache\
├── dev\
└── ...
```

**Important:** Make sure `C:\flutter\bin\flutter.bat` exists.

### Step 4: Test Installation

Open a **new** PowerShell and run:

```powershell
C:\flutter\bin\flutter.bat --version
```

This should show Flutter version without errors.

## Solution 3: Fix Current Installation (If Re-download Not Possible)

### Option A: Run Flutter Doctor

```powershell
C:\flutter\bin\flutter.bat doctor -v
```

This will show what's missing.

### Option B: Clear Cache and Rebuild

```powershell
# Navigate to Flutter directory
cd C:\flutter

# Clear cache
Remove-Item -Recurse -Force bin\cache -ErrorAction SilentlyContinue

# Try to rebuild
.\bin\flutter.bat --version
```

## Solution 4: Use Git Clone (Alternative Installation Method)

If ZIP download doesn't work, try Git:

```powershell
# Install Git first if not installed
# Then:
cd C:\
git clone https://github.com/flutter/flutter.git -b stable
```

This ensures you get a complete installation.

## Quick Fix Checklist

- [ ] Verify `C:\flutter\bin\flutter.bat` exists
- [ ] Check all required folders are present
- [ ] Try re-downloading Flutter SDK
- [ ] Extract directly to `C:\flutter` (not a subfolder)
- [ ] Test with `C:\flutter\bin\flutter.bat --version`
- [ ] Add to PATH after verification works

## Common Extraction Mistakes

❌ **Wrong:** Extracting to `C:\flutter\flutter\` (double folder)  
✅ **Correct:** Extract so `C:\flutter\bin\` exists directly

❌ **Wrong:** Extracting only some files  
✅ **Correct:** Extract entire ZIP contents

## After Fixing Installation

Once `C:\flutter\bin\flutter.bat --version` works:

1. **Add to PATH** (see `TROUBLESHOOTING_PATH_ISSUES.md`)
2. **Run Flutter Doctor:**
   ```powershell
   C:\flutter\bin\flutter.bat doctor
   ```
3. **Install dependencies:**
   ```powershell
   cd c:\mychart_fhir_app
   C:\flutter\bin\flutter.bat pub get
   ```

## Still Having Issues?

If the problem persists:

1. **Check antivirus** - Some antivirus software blocks Flutter
2. **Check disk space** - Ensure you have enough free space
3. **Check permissions** - Make sure you have write access to `C:\flutter`
4. **Try different location** - Install to `C:\src\flutter` or user folder
5. **Contact support** - Flutter GitHub issues or community

## Recommended: Complete Reinstall

**Best approach for a clean start:**

1. Delete `C:\flutter` completely
2. Download fresh Flutter SDK ZIP
3. Extract to `C:\flutter`
4. Verify with `C:\flutter\bin\flutter.bat --version`
5. Add to PATH
6. Run `flutter doctor`

This usually fixes installation issues.

