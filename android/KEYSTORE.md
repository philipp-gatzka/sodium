# Android Keystore Management

This document describes how to manage the Android keystore for signing release builds of the Sodium app.

## Overview

Android requires all APKs/AABs to be digitally signed before installation. For Play Store distribution, you must use a consistent signing key - changing the key means you cannot update the app.

## Creating a New Keystore

Generate a production keystore using keytool:

```bash
keytool -genkey -v -keystore sodium-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sodium
```

You will be prompted for:
- Keystore password (remember this!)
- Key password (can be same as keystore password)
- Your name and organization details

**Important:** Use a strong, unique password and store it securely.

## Setting Up Local Signing

1. Copy the example configuration:
   ```bash
   cp android/key.properties.example android/key.properties
   ```

2. Edit `android/key.properties` with your values:
   ```properties
   storeFile=sodium-release.jks
   storePassword=your_actual_password
   keyAlias=sodium
   keyPassword=your_actual_password
   ```

3. Place your keystore file in the `android/` directory (or update the path in key.properties).

4. Verify the configuration works:
   ```bash
   flutter build apk --release
   ```

## GitHub Actions CI/CD

For automated release builds, add the following secrets to your GitHub repository:

| Secret Name | Description |
|------------|-------------|
| `KEYSTORE_BASE64` | Base64-encoded keystore file |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias (e.g., `sodium`) |
| `KEY_PASSWORD` | Key password |

### Encoding the Keystore

```bash
base64 -i android/sodium-release.jks -o keystore.base64
# Copy contents of keystore.base64 to GitHub secret
```

### Workflow Configuration

The release workflow will automatically:
1. Decode the keystore from the secret
2. Create key.properties
3. Sign the release build

## Backup Procedure

**CRITICAL:** If you lose your keystore or passwords, you cannot update your app on Play Store!

### Required Backups

1. **Keystore file** (`sodium-release.jks`)
2. **Keystore password**
3. **Key alias**
4. **Key password**

### Recommended Backup Locations

Store backups in multiple secure locations:

1. **Password Manager** - Store passwords in a secure password manager (1Password, Bitwarden, etc.)
2. **Encrypted Cloud Storage** - Keep an encrypted copy in cloud storage (Google Drive, Dropbox)
3. **Offline Backup** - USB drive in a safe/secure location
4. **Play App Signing** - Consider using Google Play App Signing for additional protection

### Verification

Periodically verify your backups work:

```bash
keytool -list -v -keystore sodium-release.jks
```

## Google Play App Signing (Recommended)

For additional protection, use [Google Play App Signing](https://developer.android.com/studio/publish/app-signing#app-signing-google-play):

1. Google manages your app signing key
2. You only need to manage an upload key
3. If you lose your upload key, Google can reset it
4. Your app signing key is never at risk

To enroll:
1. Go to Play Console > Setup > App signing
2. Follow the enrollment process
3. Update your keystore to be an upload key

## Security Best Practices

- **Never commit** keystore files or key.properties to version control
- **Use strong passwords** (20+ characters, mixed case, numbers, symbols)
- **Different passwords** for keystore and key (recommended)
- **Limit access** to keystore files and passwords
- **Audit access** regularly if multiple developers have access
- **Rotate upload key** if compromised (Play App Signing only)

## Troubleshooting

### "Keystore was tampered with"
The keystore password is incorrect. Double-check your key.properties file.

### "Cannot recover key"
The key password is incorrect. Note that key password may differ from keystore password.

### "Keystore file not found"
Check the storeFile path in key.properties. Path is relative to the android/ directory.

### Build succeeds but APK is not signed
Ensure key.properties exists and has correct values. Check build output for signing information.
