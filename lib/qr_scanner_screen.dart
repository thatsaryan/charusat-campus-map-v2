import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'navigation_display_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  // Color constants
  static const Color primary = Color(0xFF497DD1);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFF6C7293);

  MobileScannerController? cameraController = MobileScannerController();
  String qrCodeResult = "";
  bool hasScanned = false;
  bool isLoading = false;
  bool isCameraInitializing = true;

  List<String> institutes = [
    'CSPIT-A6',
    'CSPIT-A7',
    'DEPSTAR',
    'CMPICA',
    'IIIM',
    'RPCP',
    'PDPIAS',
    'MTIN',
    'CIPS',
    'Admin Block',
    'Main Gate - 1',
    'Gate - 2',
    'Lake',
    'Gate-2 Canteen',
    'Central Lawn',
    'Library',
    'Girls Hostel',
    'Cricket Ground',
  ];

  String selectedInstitute = 'Central Lawn';
  final TextEditingController sourceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sourceController.text = "Scan a QR code";
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() {
      isCameraInitializing = true;
    });

    // Simulate camera initialization delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      isCameraInitializing = false;
    });
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
          // Show loading animation while camera is initializing
          if (isCameraInitializing)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Initializing Camera...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
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

          // Scanning overlay (only show when camera is ready)
          if (!isCameraInitializing)
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

          // Instructions (only show when camera is ready)
          if (!isCameraInitializing)
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
          'Select Destination',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showInstituteSelector(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedInstitute,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showInstituteSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Destination',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 2-Column Grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3.5,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: institutes.length,
                        itemBuilder: (context, index) {
                          final institute = institutes[index];
                          final isSelected = institute == selectedInstitute;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedInstitute = institute;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary.withOpacity(0.1)
                                    : surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? primary
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    institute,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? primary
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: isLoading ? null : () => Navigator.of(context).pop(),
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
            onPressed: isLoading ? null : _onNavigate,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('Loading...', style: TextStyle(fontSize: 16)),
                    ],
                  )
                : const Text('Navigate', style: TextStyle(fontSize: 16)),
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
      isCameraInitializing = true;
    });

    try {
      cameraController = MobileScannerController();
      _initializeCamera();
    } catch (e) {
      print("Camera restart error: $e");
    }
  }

  /// Updated navigation method to handle A6 to A7 route
  void _onNavigate() async {
    setState(() {
      isLoading = true;
    });

    try {
      cameraController?.stop();
    } catch (e) {
      print("Error stopping camera: $e");
    }

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      isLoading = false;
    });

    // Check if this is the A6 to A7 route
    if (_shouldShowNavigationScreen()) {
      Navigator.of(context).pop(); // Close QR scanner
      // Navigate to NavigationDisplayScreen with your 3 images
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationDisplayScreen(
            source: qrCodeResult,
            destination: selectedInstitute,
            imageUrls: [
              'https://raw.githubusercontent.com/thatsaryan/Campus_View/a02da1cf91050fa5c3aa4cb8c3875badb19da20a/A6-A7(1).png',
              'https://raw.githubusercontent.com/thatsaryan/Campus_View/a02da1cf91050fa5c3aa4cb8c3875badb19da20a/A6-A7(2).png',
              'https://raw.githubusercontent.com/thatsaryan/Campus_View/a02da1cf91050fa5c3aa4cb8c3875badb19da20a/A6-A7(3).png',
            ],
          ),
        ),
      );
    } else {
      // For other routes, show regular snackbar
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Navigating to $qrCodeResult in $selectedInstitute',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          backgroundColor: primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Check if we should show the NavigationDisplayScreen
  bool _shouldShowNavigationScreen() {
    // Normalize the strings for comparison
    final source = qrCodeResult.toLowerCase().trim();
    final destination = selectedInstitute.toLowerCase().trim();

    // Check for A6 to A7 route (various possible combinations)
    final isA6ToA7 =
        (source.contains('a6') && destination.contains('a7')) ||
        (source.contains('cspit-a6') && destination.contains('cspit-a7')) ||
        (source.contains('cspit a6') && destination.contains('cspit a7'));

    // Check for A7 to A6 route (reverse direction - same images)
    final isA7ToA6 =
        (source.contains('a7') && destination.contains('a6')) ||
        (source.contains('cspit-a7') && destination.contains('cspit-a6')) ||
        (source.contains('cspit a7') && destination.contains('cspit a6'));

    return isA6ToA7 || isA7ToA6;
  }
}
