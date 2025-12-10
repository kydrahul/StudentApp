import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  // Use High Resolution for better distance scanning
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // Prevent spam
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode], // Optimize for QR only
    returnImage: false,
    autoStart: true,
    // Target 720p for balance between speed and clarity
    cameraResolution: const Size(1280, 720),
  );

  final ApiService _apiService = ApiService();
  bool _isProcessing = false;
  bool _isTorchOn = false;
  Map<String, double>? _cachedLocation;
  DateTime? _lastScanTime; // For debouncing

  @override
  void initState() {
    super.initState();
    // Prefetch location to minimize delay when scanning
    _startLocationUpdates();
  }

  void _startLocationUpdates() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      // Get initial position
      try {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium); // Medium is faster
        if (mounted) {
          _cachedLocation = {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'accuracy': position.accuracy,
          };
        }
      } catch (e) {
        print("Initial location fetch failed: $e");
      }
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<Map<String, double>> _getCurrentLocation() async {
    // Return cached location if fresh (e.g., < 30 seconds old? ignoring for simplicity, just updating cache)
    if (_cachedLocation != null) return _cachedLocation!;

    final permission = await Permission.location.request();
    if (!permission.isGranted) {
      throw Exception('Location permission denied');
    }

    // Use medium accuracy for speed if no cache
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    _cachedLocation = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy': position.accuracy,
    };

    return _cachedLocation!;
  }

  Future<void> _handleQRCode(String qrData) async {
    if (_isProcessing) return;

    // Strict Debounce: 2 seconds
    if (_lastScanTime != null &&
        DateTime.now().difference(_lastScanTime!) <
            const Duration(seconds: 2)) {
      return;
    }
    _lastScanTime = DateTime.now();

    setState(() => _isProcessing = true);

    try {
      // Get location (Best effort)
      Map<String, double> location = {
        'latitude': 0.0,
        'longitude': 0.0,
        'accuracy': 0.0,
      };

      try {
        location = await _getCurrentLocation();
      } catch (e) {
        print('Location fetch failed: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Location unavailable. Proceeding with attendance...'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      // Call API
      final result = await _apiService.scanQR(
        qrData: qrData,
        latitude: location['latitude']!,
        longitude: location['longitude']!,
        accuracy: location['accuracy'],
      );

      if (mounted) {
        // Show success
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Success!'),
            content: Text(result['message'] ?? 'Attendance marked'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close scanner
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _isProcessing = false);
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen size
    final scanWindowSize = MediaQuery.of(context).size.width * 0.75;

    // Define the scanning window rect
    final scanWindow = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: scanWindowSize,
      height: scanWindowSize,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Mobile Scanner (Full Screen)
          MobileScanner(
            controller: cameraController,
            scanWindow: scanWindow, // NATIVE ROI OPTIMIZATION
            onDetect: (capture) {
              if (_isProcessing) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleQRCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // 2. Dark Overlay with Cutout
          CustomPaint(
            painter: ScannerOverlayPainter(
              scanWindow: Rect.fromCenter(
                center: Offset(
                  MediaQuery.of(context).size.width / 2,
                  MediaQuery.of(context).size.height / 2,
                ),
                width: scanWindowSize,
                height: scanWindowSize,
              ),
              borderRadius: 20.0,
            ),
            child: Container(),
          ),

          // 3. White Border for Scan Area
          Center(
            child: Container(
              width: scanWindowSize,
              height: scanWindowSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // 4. Top Controls (Flash and Close)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flash Toggle
                GestureDetector(
                  onTap: () {
                    cameraController.toggleTorch();
                    setState(() {
                      _isTorchOn = !_isTorchOn;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    radius: 24,
                    child: Icon(
                      _isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                // Close Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    radius: 24,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5. Bottom Controls (Text and Indicator)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Scan QR code to mark attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // "QR CODE" Bubble
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1), // Indigo/Purple color
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "QR CODE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Processing Indicator Overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Marking Attendance...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom Painter for the dark overlay with a hole
class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final double borderRadius;

  ScannerOverlayPainter({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          scanWindow,
          Radius.circular(borderRadius),
        ),
      );

    final overlayPath =
        Path.combine(PathOperation.difference, backgroundPath, cutoutPath);

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.8) // Dark overlay color
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
