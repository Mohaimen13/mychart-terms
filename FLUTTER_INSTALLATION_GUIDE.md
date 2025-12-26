# Flutter Installation Guide for Windows

## Prerequisites

Before installing Flutter, you need:

✅ **Windows 10 or later** (64-bit)  
✅ **At least 2GB of free disk space**  
✅ **Git for Windows** (for version control)

## Step 1: Download Flutter SDK

1. Go to the Flutter website: [https://flutter.dev/docs/get-started/install/windows](https://flutter.dev/docs/get-started/install/windows)
2. Click **"Download Flutter SDK"**
3. Download the latest stable release (`.zip` file)
4. The file will be named something like `flutter_windows_3.x.x-stable.zip`

## Step 2: Extract Flutter

1. **Extract the ZIP file** to a location where you want Flutter installed
   - **Recommended location:** `C:\flutter` ✅ (You've installed it here!)
   - **Avoid:** Installing in folders with spaces or special characters
   - **Avoid:** `C:\Program Files\` (requires admin permissions)

2. The extracted folder should contain:
   ```
   C:\flutter\
   ├── bin\
   ├── packages\
   ├── examples\
   └── ...
   ```

## Step 3: Add Flutter to PATH

### Option A: Using System Environment Variables (Recommended)

1. **Open System Properties:**
   - Press `Windows + R`
   - Type: `sysdm.cpl` and press Enter
   - Or: Right-click "This PC" → Properties → Advanced system settings

2. **Edit Environment Variables:**
   - Click **"Environment Variables"** button
   - Under **"User variables"**, find **"Path"** and click **"Edit"**
   - Click **"New"** and add: `C:\flutter\bin` ✅ (Use this path since you installed to C:\flutter)
   - Click **"OK"** on all dialogs

3. **Restart your terminal/PowerShell** (or restart your computer)

### Option B: Using PowerShell (Temporary - Current Session Only)

```powershell
$env:Path += ";C:\flutter\bin"
```

This only works for the current PowerShell session.

## Step 4: Verify Installation

1. **Open a new terminal/PowerShell** (important: must be new after PATH change)
2. **Run:**
   ```bash
   flutter --version
   ```
   You should see Flutter version information.

3. **Run Flutter Doctor:**
   ```bash
   flutter doctor
   ```
   This checks your setup and shows what's installed/missing.

## Step 5: Install Additional Tools

Flutter Doctor will tell you what's missing. Here's what you typically need:

### Android Development Setup

1. **Install Android Studio:**
   - Download from: [https://developer.android.com/studio](https://developer.android.com/studio)
   - Run the installer
   - During installation, make sure to install:
     - Android SDK
     - Android SDK Platform
     - Android Virtual Device (AVD)

2. **Accept Android Licenses:**
   ```bash
   flutter doctor --android-licenses
   ```
   Press `y` to accept all licenses.

### Optional: VS Code (Recommended Editor)

1. Download VS Code: [https://code.visualstudio.com/](https://code.visualstudio.com/)
2. Install Flutter extension:
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Flutter"
   - Install the official Flutter extension

## Step 6: Verify Complete Setup

Run Flutter Doctor again:

```bash
flutter doctor
```

You should see checkmarks (✅) for:
- ✅ Flutter (channel stable)
- ✅ Android toolchain (if you installed Android Studio)
- ✅ VS Code (if you installed it)
- ✅ Connected device (if you have an emulator running or device connected)

## Common Issues & Solutions

### Issue: "flutter: command not found"

**Solution:**
- Make sure you added Flutter to PATH correctly
- Restart your terminal/PowerShell
- Verify the path: `C:\flutter\bin` exists

### Issue: "Unable to locate Android SDK"

**Solution:**
1. Open Android Studio
2. Tools → SDK Manager
3. Install Android SDK (API level 33 or higher recommended)
4. Note the SDK location (usually `C:\Users\YourName\AppData\Local\Android\Sdk`)
5. Set environment variable `ANDROID_HOME` to that path

### Issue: "Android licenses not accepted"

**Solution:**
```bash
flutter doctor --android-licenses
```
Accept all licenses by pressing `y`.

### Issue: "Git not found"

**Solution:**
1. Download Git for Windows: [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. Install with default settings
3. Restart terminal

## Quick Verification Commands

After installation, test these commands:

```bash
# Check Flutter version
flutter --version

# Check setup status
flutter doctor

# List available devices
flutter devices

# Update Flutter (optional)
flutter upgrade
```

## Next Steps After Installation

Once Flutter is installed:

1. ✅ **Install dependencies for your project:**
   ```bash
   cd c:\mychart_fhir_app
   flutter pub get
   ```

2. ✅ **Check your project setup:**
   ```bash
   flutter doctor
   ```

3. ✅ **Start testing your app:**
   ```bash
   flutter run
   ```

## Installation Checklist

- [ ] Downloaded Flutter SDK
- [ ] Extracted to `C:\flutter` ✅ (You've done this!)
- [ ] Added Flutter to PATH (Next step!)
- [ ] Verified with `flutter --version`
- [ ] Ran `flutter doctor`
- [ ] Installed Android Studio (for Android development)
- [ ] Accepted Android licenses
- [ ] Installed VS Code + Flutter extension (optional but recommended)
- [ ] Verified setup with `flutter doctor` showing checkmarks

## System Requirements

- **OS:** Windows 10 (64-bit) or later
- **Disk Space:** 2.8 GB (does not include disk space for IDE/tools)
- **Tools:** Git for Windows
- **IDE:** Android Studio or VS Code (recommended)

## Getting Help

If you encounter issues:

1. **Check Flutter documentation:** [https://flutter.dev/docs](https://flutter.dev/docs)
2. **Run `flutter doctor -v`** for detailed diagnostics
3. **Check Flutter GitHub issues:** [https://github.com/flutter/flutter/issues](https://github.com/flutter/flutter/issues)
4. **Flutter Community:** [https://flutter.dev/community](https://flutter.dev/community)

## Alternative: Using Flutter via Chocolatey (Advanced)

If you have Chocolatey package manager:

```powershell
choco install flutter
```

This automatically handles PATH setup.

---

**Once Flutter is installed, proceed to `TESTING_GUIDE.md` to start testing your app!** 🚀

