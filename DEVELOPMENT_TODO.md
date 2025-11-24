# Student App Development Guide

## 🚨 Critical Issues (Fix Before Launch)

### 1. Profile Data Integration

**Current Issue**: Profile popup shows hardcoded mock data instead of real user data

**Location**: `lib/widgets/common/profile_popup.dart` (lines 87-104)

**Fix Steps**:

1. **Add backend endpoint** `GET /api/student/profile`:
   ```javascript
   // Expected response
   {
     "name": "Student Name",
     "rollNo": "2023-CS-104",
     "branch": "Computer Science",
     "email": "student@iiit.ac.in",
     "passingYear": "2026",
     "batch": "2023",
     "semester": "5"
   }
   ```

2. **Update `profile_popup.dart`**:
   - Accept student data as parameters
   - Fetch from API if not provided
   - Show "Profile not found" if student not in database

3. **Update `custom_header.dart`**:
   - Fetch profile data
   - Pass to ProfilePopup widget

### 2. Geolocation Verification

**Current Issue**: Location verification always succeeds without checking GPS

**Location**: `lib/screens/tabs/home_tab.dart` (lines 91-104)

**Fix Steps**:

1. **Remove mock verification**:
   ```dart
   // Current code (REMOVE THIS):
   Future.delayed(const Duration(milliseconds: 1500), () {
     setState(() {
       locationStatus = 'success';
       canScan = true;
     });
   });
   ```

2. **Implement real verification**:
   ```dart
   Future<void> _handleVerifyLocation() async {
     setState(() => locationStatus = 'verifying');
     
     try {
       final position = await Geolocator.getCurrentPosition();
       final result = await _apiService.verifyLocation(
         latitude: position.latitude,
         longitude: position.longitude,
         accuracy: position.accuracy,
       );
       
       setState(() {
         locationStatus = result['valid'] ? 'success' : 'error';
         canScan = result['valid'];
       });
     } catch (e) {
       setState(() => locationStatus = 'error');
     }
   }
   ```

3. **Add backend endpoint** `POST /api/student/verify-location`:
   ```javascript
   // Request
   {
     "latitude": 17.3850,
     "longitude": 78.4867,
     "accuracy": 10.5
   }
   
   // Response
   {
     "valid": true,
     "message": "Location verified",
     "expiresAt": "2025-11-24T19:48:00Z"
   }
   ```

### 3. QR Scanner Location

**Current Issue**: QR scanner may use placeholder coordinates

**Location**: `lib/screens/qr_scanner_screen.dart` (lines 26-40)

**Verify**: Ensure `_getCurrentLocation()` uses real GPS, not placeholders

**If using placeholders**:
```dart
// WRONG - Remove if present
return {
  'latitude': 17.3850,  // Hardcoded
  'longitude': 78.4867, // Hardcoded
};

// CORRECT - Keep this
final position = await Geolocator.getCurrentPosition();
return {
  'latitude': position.latitude,
  'longitude': position.longitude,
  'accuracy': position.accuracy,
};
```

## 🔧 Backend API Checklist

### Existing Endpoints

| Endpoint | Method | Status | Notes |
|----------|--------|--------|-------|
| `/api/student/dashboard` | GET | ✅ | Working |
| `/api/student/scan-qr` | POST | ⚠️ | Verify geofence works |
| `/api/student/join-course` | POST | ✅ | Working |
| `/api/student/courses` | GET | ✅ | Working |
| `/api/student/timetable` | GET | ✅ | Working |
| `/api/student/attendance-history` | GET | ✅ | Working |

### Missing Endpoints

**Need to add**:

1. `GET /api/student/profile`
   ```javascript
   // Fetch student profile by authenticated user
   Response: { name, rollNo, branch, email, passingYear, batch, semester }
   ```

2. `POST /api/student/verify-location`
   ```javascript
   // Pre-validate location before allowing QR scan
   Body: { latitude, longitude, accuracy }
   Response: { valid: boolean, message, expiresAt }
   ```

3. `DELETE /api/student/courses/:courseId`
   ```javascript
   // Allow students to unenroll from courses
   Response: { success: true, message }
   ```

## ⚙️ Configuration & Setup

### Update Backend URL

**Location**: `lib/config/app_config.dart`

```dart
class AppConfig {
  static const String apiBaseUrl = 'https://iiitnrattendence-backend.onrender.com';
  static const String apiVersion = '/api';
  static String get baseUrl => '$apiBaseUrl$apiVersion';
}
```

### Android Configuration

**Location**: `android/app/build.gradle`

**TODOs to fix**:

1. **Line 23-24**: Set unique Application ID
   ```gradle
   applicationId "com.iiitnr.attendance_student"
   ```

2. **Line 35-36**: Configure release signing
   ```gradle
   signingConfig signingConfigs.release
   ```

3. **Verify minSdk**: Should be `23` (for Firebase compatibility)

### Permissions

**Verify in `android/app/src/main/AndroidManifest.xml`**:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## 🎯 Feature Improvements

### Timetable Integration

**Current**: Working but basic

**Improvements**:
1. Add offline caching
2. Show loading skeleton
3. Better empty state message
4. Add class reminders

### Course Management

**Current**: Can join and view courses

**Add**:
1. Unenroll functionality
2. Course-specific attendance percentage
3. Search/filter courses
4. Show upcoming classes per course

### Attendance History

**Current**: Basic implementation

**Add**:
1. Date range filtering
2. Export to PDF/CSV
3. Attendance charts/statistics
4. Group by course
5. Search functionality

## 🔐 Authentication & Security

### Token Refresh

**Location**: `lib/services/auth_service.dart`

**Add automatic refresh**:
```dart
Future<String?> getToken() async {
  final user = _auth.currentUser;
  if (user != null) {
    // Force refresh if token older than 55 minutes
    final token = await user.getIdToken(true);
    await _storage.write(key: 'auth_token', value: token);
    return token;
  }
  return await _storage.read(key: 'auth_token');
}
```

### Logout Implementation

**Add logout button** in Settings tab:

```dart
ElevatedButton(
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Logout')),
        ],
      ),
    );
    
    if (confirm == true) {
      await AuthService().signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  },
  child: Text('Logout'),
)
```

## 🧪 Testing Checklist

### Before Launch

- [ ] Remove all hardcoded/mock data
- [ ] Test Google Sign-In
- [ ] Test QR scanning with real GPS
- [ ] Test location verification
- [ ] Test joining courses
- [ ] Test viewing timetable
- [ ] Test attendance history
- [ ] Test logout
- [ ] Test on multiple devices
- [ ] Test with slow/no internet
- [ ] Verify all APIs work
- [ ] Check error messages are user-friendly

### API Testing

Test each endpoint:

```bash
# Get profile
curl -H "Authorization: Bearer TOKEN" \
  https://iiitnrattendence-backend.onrender.com/api/student/profile

# Verify location
curl -X POST -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"latitude":17.385,"longitude":78.486,"accuracy":10}' \
  https://iiitnrattendence-backend.onrender.com/api/student/verify-location

# Get courses
curl -H "Authorization: Bearer TOKEN" \
  https://iiitnrattendence-backend.onrender.com/api/student/courses
```

## 🔍 Troubleshooting

### Profile not loading

1. Check if `GET /api/student/profile` endpoint exists
2. Verify Firebase token is valid
3. Check backend logs for errors
4. Ensure student exists in admin database

### Location verification fails

1. Check GPS permissions granted
2. Try outdoors for better GPS signal
3. Verify backend geofence coordinates are correct
4. Check backend logs for validation errors

### QR scan not working

1. Grant camera permission
2. Ensure location is verified first
3. Check QR code is valid (generated by faculty)
4. Verify backend `/scan-qr` endpoint works
5. Check backend logs

### API errors

**Check backend health**:
```bash
curl https://iiitnrattendence-backend.onrender.com/health
```

**Expected**:
```json
{"status":"ok","timestamp":"2025-11-24T..."}
```

### Build errors

**Clear and rebuild**:
```bash
flutter clean
flutter pub get
flutter run
```

## 📦 Deployment

### Pre-deployment Checklist

- [ ] Update app version in `pubspec.yaml`
- [ ] Set proper `applicationId` in `build.gradle`
- [ ] Configure release signing
- [ ] Test release build
- [ ] Remove debug logs
- [ ] Enable ProGuard (optional)
- [ ] Test on real device

### Build Release APK

```bash
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

## 📊 What's Implemented

✅ Google Sign-In (Firebase Auth)  
✅ QR Code Scanning (mobile_scanner)  
✅ Course Management (join, view)  
✅ Timetable Display  
✅ Attendance History  
✅ Profile Setup Screen  
⚠️ Location Verification (mock only)  
⚠️ Profile Display (hardcoded data)  

## 🎯 Priority Order

### P0 - Must Fix Now
1. Fix profile data integration (#1)
2. Enable real location verification (#2)
3. Verify QR scanner uses real GPS (#3)
4. Add missing backend APIs

### P1 - Before Launch
5. Update Android configuration
6. Add logout functionality
7. Implement token refresh
8. Complete testing checklist

### P2 - Post-Launch
9. Feature improvements (filters, charts, export)
10. Performance optimizations
11. UI/UX enhancements

