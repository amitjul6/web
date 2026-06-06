# Android setup, Google sign-in & release signing

After running `flutter create --platforms=android --org com.caloriedesi .`,
apply the following.

## 1. Manifest — step sensor permission
`android/app/src/main/AndroidManifest.xml` — add inside `<manifest>` (above
`<application>`):

```xml
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
<uses-feature android:name="android.hardware.sensor.stepcounter" android:required="false"/>
```

The app requests `ACTIVITY_RECOGNITION` at runtime on first entry to the
dashboard. If denied, step tracking is disabled gracefully and the manual
**Override** remains fully functional.

## 2. Gradle — SDK levels
`android/app/build.gradle` (or `build.gradle.kts`) under `defaultConfig`:

```gradle
minSdkVersion 29           // Android 10 — clean runtime ACTIVITY_RECOGNITION
targetSdkVersion 34        // (or the latest you build against)
applicationId "com.caloriedesi.app"
```

## 3. Google Sign-In (Firebase)
Sign-in works only after registering the app with Google. Guest mode works without this.

1. Create a project in the [Firebase console](https://console.firebase.google.com/).
2. **Add app → Android**, package name **`com.caloriedesi.app`** (must match `applicationId`).
3. Register your **SHA-1** fingerprints (both debug and release):
   ```bash
   # Debug
   keytool -list -v -keystore ~/.android/debug.keystore \
     -alias androiddebugkey -storepass android -keypass android
   # Release (after step 4 below)
   keytool -list -v -keystore upload-keystore.jks -alias upload
   ```
   Add the printed SHA-1 under the Android app in Firebase → Project settings.
4. Download **`google-services.json`** → place in `android/app/`.
5. Enable the Google sign-in provider under **Authentication → Sign-in method**.
6. Add the Google Services Gradle plugin:
   - `android/build.gradle`: `classpath 'com.google.gms:google-services:4.4.2'`
   - bottom of `android/app/build.gradle`: `apply plugin: 'com.google.gms.google-services'`

> Common gotcha: sign-in works in **debug** but fails in **release** if the
> release keystore's SHA-1 isn't registered. Add both.

## 4. Release signing
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```
Create `android/key.properties` (gitignored):
```properties
storePassword=••••
keyPassword=••••
keyAlias=upload
storeFile=../upload-keystore.jks
```
Wire it in `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
android {
  signingConfigs {
    release {
      keyAlias keystoreProperties['keyAlias']
      keyPassword keystoreProperties['keyPassword']
      storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
      storePassword keystoreProperties['storePassword']
    }
  }
  buildTypes {
    release { signingConfig signingConfigs.release }
  }
}
```

## 5. Build artifacts
```bash
flutter build apk --debug                 # quick test APK
flutter build apk --release               # signed APK
flutter build apk --release --split-per-abi  # smaller per-architecture APKs
flutter build appbundle --release         # .aab for the Play Store
```

## 6. Play Store (later)
- Create a [Play Console](https://play.google.com/console) developer account (one-time $25).
- Upload the `.aab`, complete the store listing, data-safety form, and content rating.
- Use Play **internal testing** track first to distribute test builds easily.
