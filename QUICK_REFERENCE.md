# Student App - Quick Reference Summary

## 🚨 **Top 3 Critical Issues to Fix NOW**

### 1. **Hardcoded Profile Data**
- **File**: `lib/widgets/common/profile_popup.dart` (lines 87-104)
- **Issue**: Shows "Alex Johnson" instead of real user
- **Fix**: Fetch real profile from backend API

### 2. **Fake Location Verification**  
- **File**: `lib/screens/tabs/home_tab.dart` (lines 91-104)
- **Issue**: Always succeeds without checking GPS
- **Fix**: Implement real geofence validation

### 3. **Missing Backend APIs**
- Need: `GET /api/student/profile` (for profile display)
- Need: `POST /api/student/verify-location` (for geofence check)
- Verify geofence validation works in `POST /api/student/scan-qr`

---

## 📊 **Current Status Summary**

| Feature | Status | Notes |
|---------|--------|-------|
| Google Login | ✅ Working | Firebase auth implemented |
| QR Scanning | ⚠️ Partial | Works but geolocation disabled |
| Location Verification | ❌ Broken | Mock only, not real |
| Profile Display | ❌ Broken | Hardcoded data |
| Course Join | ✅ Working | Join via code implemented |
| Timetable | ✅ Working | Fetches and displays |
| Attendance History | ❓ Untested | API exists, needs testing |

---

## 🎯 **Priority Workflow**

### **Phase 1: Fix Critical Issues** (Do First)
1. Add `GET /api/student/profile` endpoint in backend
2. Update `profile_popup.dart` to fetch real data
3. Implement real geolocation in `home_tab.dart`
4. Test QR scanning with real coordinates

### **Phase 2: Backend Integration** (Do Next)
1. Add `POST /api/student/verify-location` endpoint
2. Verify all existing endpoints work
3. Improve error handling in `api_service.dart`
4. Add token refresh logic

### **Phase 3: Polish** (Before Launch)
1. Remove all TODOs and mock data
2. Add logout button
3. Test on real devices
4. Configure Android signing
5. Performance testing

---

## 📁 **Key Files to Know**

| File | Purpose | Issues |
|------|---------|--------|
| `lib/services/api_service.dart` | All backend API calls | Needs better error handling |
| `lib/services/auth_service.dart` | Google login, tokens | Need auto-refresh |
| `lib/widgets/common/profile_popup.dart` | User profile display | **Hardcoded data** |
| `lib/screens/tabs/home_tab.dart` | Home screen, location | **Mock verification** |
| `lib/screens/qr_scanner_screen.dart` | QR attendance | Check if geolocation works |
| `lib/config/app_config.dart` | Backend URL | Update if needed |

---

## 🔧 **Quick Fixes**

### Enable Real Geolocation (if disabled)
Check `qr_scanner_screen.dart` line 26-40 - should be getting real GPS.  
If using placeholder coords, remove and use actual `Geolocator.getCurrentPosition()`.

### Update Backend URL
Edit `lib/config/app_config.dart` if backend URL changes.

### Test APIs
Use this to check backend connectivity:
```dart
final apiService = ApiService();
await apiService.getDashboard(); // Should return data
await apiService.getCourses();   // Should return courses list
```

---

## 📞 **Questions to Answer Before Launch**

1. **Profile Management**: Admin-managed OR student self-service?
2. **Geofence**: What are the exact college coordinates and radius?
3. **Course Unenroll**: Should students be able to leave courses?
4. **Profile Setup**: Show setup screen or enforce admin-only profiles?

---

## 📚 **Full Details**

See [DEVELOPMENT_TODO.md](file:///d:/iiitnrattendanceSys-QR_Geofence_Based/StudentApp/DEVELOPMENT_TODO.md) for complete documentation with 20 categorized tasks.

---

**Backend**: `https://iiitnrattendence-backend.onrender.com`  
**Package**: Uses `mobile_scanner` for QR (replaced `qr_code_scanner`)  
**Min SDK**: Android 23 (for Firebase compatibility)
