import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  // Color constants (you might want to import these from a theme file)
  static const Color primary = Color(0xFF497DD1);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFF6C7293);

  MobileScannerController? cameraController = MobileScannerController();
  String qrCodeResult = "";
  bool hasScanned = false;

  List<String> institutes = [
    'CSPIT',
    'CSPIT-A6',
    'DEPSTAR',
    'CMPICA',
    'IIIM',
    'RPCP',
    'PDPIAS',
    'MTIN',
    'CIPS',
    'CSPIT-A7',
    'Admin Block',
    'Main Gate - 1',
    'Main Gate - 2',
    'Lake',
    'Gate-2 Canteen',
    'Central Lawn',
    'Library',
  ];

  String selectedInstitute = 'CSPIT';
  final TextEditingController sourceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sourceController.text = "Scan a QR code";
  }

  @override
  void dispose() {
    try {
      cameraController?.dispose();
    } catch (e) {
      print("Error disposing camera: $e");
    }
    sourceController.dispose();
    super.dispose();
  }

  /// Check if QR scanning is supported on current platform
  static bool get isPlatformSupported {
    return !kIsWeb &&
        !Platform.isWindows &&
        !Platform.isLinux &&
        !Platform.isMacOS;
  }

  /// Show QR scanner with platform check
  static void showQRScanner(BuildContext context) async {
    if (!isPlatformSupported) {
      _showUnsupportedPlatformMessage(context);
      return;
    }

    // Check camera permission
    final status = await Permission.camera.request();
    if (status.isDenied) {
      _showCameraPermissionError(context);
      return;
    }

    // Navigate to QR scanner
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );
  }

  static void _showUnsupportedPlatformMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'QR scanning is not available on this platform',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void _showCameraPermissionError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Camera permission is required for QR scanning',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // QR Scanner view - Always show camera when not scanned
          if (!hasScanned) _buildScannerView() else _buildResultForm(),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    return Expanded(
      child: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!hasScanned && capture.barcodes.isNotEmpty) {
                final barcode = capture.barcodes.first;
                setState(() {
                  qrCodeResult = barcode.rawValue ?? '';
                  hasScanned = true;
                  sourceController.text = qrCodeResult;
                });

                // Stop camera after successful scan
                try {
                  cameraController?.stop();
                } catch (e) {
                  print("Error stopping camera: $e");
                }
              }
            },
          ),
          // Scanning overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Instructions
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              "Align QR code within frame",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultForm() {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSuccessMessage(),
              const SizedBox(height: 20),
              _buildSourceField(),
              const SizedBox(height: 20),
              _buildInstituteDropdown(),
              const SizedBox(height: 30),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'QR Code scanned successfully!',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Source',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: sourceController,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _restartScanner,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstituteDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Institute',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedInstitute,
          decoration: InputDecoration(
            filled: true,
            fillColor: surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: institutes.map((String institute) {
            return DropdownMenuItem<String>(
              value: institute,
              child: Text(institute),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedInstitute = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, color: textSecondary),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _onNavigate,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Navigate', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  void _restartScanner() {
    setState(() {
      hasScanned = false;
      qrCodeResult = "";
      sourceController.text = "Scan a QR code";
    });
    try {
      cameraController = MobileScannerController();
    } catch (e) {
      print("Camera restart error: $e");
    }
  }

  void _onNavigate() {
    try {
      cameraController?.stop();
    } catch (e) {
      print("Error stopping camera: $e");
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to $qrCodeResult in $selectedInstitute',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
