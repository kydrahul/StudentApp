# IIITNR Attendance - Student App

Flutter mobile application for students to mark attendance via QR code scanning with geolocation verification.

## 📱 Features

- **Google Sign-In**: Firebase-based authentication
- **QR Code Scanning**: Mark attendance by scanning faculty-generated QR codes
- **Geolocation Verification**: Ensure students are physically present in class
- **Course Management**: Join courses via join code, view enrolled courses
- **Timetable**: View weekly class schedule
- **Attendance History**: Track attendance records
- **Profile Management**: View student profile information

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio / Xcode
- Firebase project configured

### Installation
```bash
flutter pub get
flutter run
```

## 📋 Documentation

- **[DEVELOPMENT_TODO.md](DEVELOPMENT_TODO.md)** - Complete list of pending tasks and improvements
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick summary of critical issues

## 🔗 Related Projects

- **Backend**: `../backend` - Node.js/Express API server
- **Faculty Portal**: Web app for faculty to generate QR codes and manage classes

## 📝 Current Status

⚠️ **In Development** - Some features use mock data and need completion before production deployment.

See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for critical issues that need fixing.

## 🛠️ Tech Stack

- Flutter 3.x
- Firebase Authentication
- Google Sign-In
- Mobile Scanner (QR code scanning)
- Geolocator (location services)
- HTTP (API communication)

