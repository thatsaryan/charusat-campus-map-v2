// ignore_for_file: unused_local_variable
import 'package:charusat_maps/campus_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'academic_buildings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color primary = Color(0xFF497DD1);
  static const Color secondary = Color(0xFF6C7293);
  static const Color accent = Color(0xFF007AFF);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color cardSurface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C7293);
  static const Color border = Color(0xFFE5E7EB);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MobileScannerController? cameraController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreen.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Replace the entire SliverAppBar section with this:
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                color: HomeScreen.surface,
                child: const Text(
                  'Campus',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: HomeScreen.textPrimary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    Text(
                      'Navigate your campus with ease',
                      style: TextStyle(
                        fontSize: 16,
                        color: HomeScreen.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    _buildMainActionCard(
                      context,
                      icon: Icons.map_outlined,
                      title: 'Explore Campus',
                      subtitle:
                          'Interactive campus map with real-time navigation',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PanoramaScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: HomeScreen.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildActionGrid(context),

                    const SizedBox(height: 32),

                    _buildServicesList(context),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: HomeScreen.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: HomeScreen.primary.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.location_on_outlined,
            title: 'Find Places',
            onTap: () => _showFeatureSnackBar(context, 'Find Places'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.directions_outlined,
            title: 'Directions',
            onTap: () => _showFeatureSnackBar(context, 'Directions'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HomeScreen.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HomeScreen.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HomeScreen.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: HomeScreen.accent),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: HomeScreen.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(BuildContext context) {
    final services = [
      {
        'icon': Icons.camera_alt_outlined,
        'title': 'Scanner',
        'subtitle': 'Scan the QR code to get details',
        'onTap': () => _showFeatureSnackBar(context, 'QR Code Scanner'),
      },
      {
        'icon': Icons.school_outlined,
        'title': 'Academic Buildings',
        'subtitle': 'Classrooms, labs, and departments',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AcademicBuildingsScreen(),
          ),
        ),
      },
      {
        'icon': Icons.restaurant_outlined,
        'title': 'Cafeterias',
        'subtitle': 'Food courts and canteens',
        'onTap': () => _showFeatureSnackBar(context, 'Cafeterias & Dining'),
      },
      {
        'icon': Icons.local_parking_outlined,
        'title': 'Parking Areas',
        'subtitle': 'Available parking spots and zones',
        'onTap': () => _showFeatureSnackBar(context, 'Parking Areas'),
      },
      {
        'icon': Icons.local_library_outlined,
        'title': 'Libraries & Study Areas',
        'subtitle': 'Central library and reading rooms',
        'onTap': () => _showFeatureSnackBar(context, 'Libraries & Study Areas'),
      },
    ];

    return Column(
      children: services.map((service) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildServiceCard(
            context,
            icon: service['icon'] as IconData,
            title: service['title'] as String,
            subtitle: service['subtitle'] as String,
            onTap: service['onTap'] as VoidCallback,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HomeScreen.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HomeScreen.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: HomeScreen.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 22, color: HomeScreen.textPrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: HomeScreen.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: HomeScreen.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: HomeScreen.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureSnackBar(BuildContext context, String feature) {
    // Check if the feature is QR Code Scanner
    if (feature == "QR Code Scanner") {
      // Check if the platform is supported for QR scanning
      if (kIsWeb ||
          Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS) {
        _showUnsupportedPlatformMessage(context);
      } else {
        // Show QR scanner dialog on supported platforms
        _showQRScannerDialog(context);
      }
    } else {
      // For other features, show a "coming soon" message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$feature coming soon!',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          backgroundColor: HomeScreen.primary,
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

  void _showUnsupportedPlatformMessage(BuildContext context) {
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

  void _showQRScannerDialog(BuildContext context) async {
    // Check camera permission first
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Camera permission is required for QR scanning',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Navigate to full-screen QR scanner instead of showing dialog
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );
  }

  void _onNavigate(BuildContext context, String source, String institute) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to $source in $institute',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: HomeScreen.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Separate QR Scanner Screen to avoid LayoutBuilder conflicts
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController? cameraController = MobileScannerController();
  String qrCodeResult = "";
  bool hasScanned = false;

  // List of Charusat University institutes
  List<String> institutes = [
    'CSPIT',
    'DEPSTAR',
    'CMPICA',
    'IIIM',
    'RPCP',
    'PDPIAS',
    'MTIN',
    'CIPS',
    'Architecture',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        backgroundColor: HomeScreen.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // QR Scanner view - Always show camera when not scanned
          if (!hasScanned)
            Expanded(
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
            )
          // Form section - Only show when QR is scanned
          else
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Success message
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                            ),
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
                      ),

                      const Text(
                        'Source',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: HomeScreen.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: sourceController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HomeScreen.surface,
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
                            onPressed: () {
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
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Institute',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: HomeScreen.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedInstitute,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HomeScreen.surface,
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
                      const SizedBox(height: 30),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: HomeScreen.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _onNavigate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HomeScreen.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Navigate',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
        backgroundColor: HomeScreen.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
