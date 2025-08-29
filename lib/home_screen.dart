// ignore_for_file: unused_local_variable
import 'package:charusat_maps/campus_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'academic_buildings.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Color constants
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreen.surface,
      body: SafeArea(
        child: CustomScrollView(slivers: [_buildHeader(), _buildContent()]),
      ),
    );
  }

  /// Build the header section
  Widget _buildHeader() {
    return SliverToBoxAdapter(
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
    );
  }

  /// Build the main content section
  Widget _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildSubtitle(),
            const SizedBox(height: 40),
            _buildMainActionCard(),
            const SizedBox(height: 32),
            _buildQuickAccessSection(),
            const SizedBox(height: 32),
            _buildServicesList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Build subtitle text
  Widget _buildSubtitle() {
    return Text(
      'Navigate your campus with ease',
      style: TextStyle(
        fontSize: 16,
        color: HomeScreen.textSecondary,
        height: 1.5,
      ),
    );
  }

  /// Build the main action card for campus exploration
  Widget _buildMainActionCard() {
    return _buildActionCard(
      icon: Icons.map_outlined,
      title: 'Explore Campus',
      subtitle: 'Interactive campus map with real-time navigation',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PanoramaScreen()),
        );
      },
    );
  }

  /// Build the quick access section
  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: HomeScreen.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        _buildActionGrid(),
      ],
    );
  }

  /// Build a reusable action card widget
  Widget _buildActionCard({
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

  /// Build the grid of quick action cards
  Widget _buildActionGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.location_on_outlined,
            title: 'Find Places',
            onTap: () => _showFeatureSnackBar('Find Places'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.directions_outlined,
            title: 'Directions',
            onTap: () => _showFeatureSnackBar('Directions'),
          ),
        ),
      ],
    );
  }

  /// Build individual quick action card
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

  /// Build the services list
  Widget _buildServicesList() {
    final services = _getServices();

    return Column(
      children: services.map((service) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildServiceCard(
            icon: service['icon'] as IconData,
            title: service['title'] as String,
            subtitle: service['subtitle'] as String,
            onTap: service['onTap'] as VoidCallback,
          ),
        );
      }).toList(),
    );
  }

  /// Get the list of services configuration
  List<Map<String, dynamic>> _getServices() {
    return [
      {
        'icon': Icons.camera_alt_outlined,
        'title': 'Scanner',
        'subtitle': 'Scan the QR code to get details',
        'onTap': () => _showFeatureSnackBar('QR Code Scanner'),
      },
      {
        'icon': Icons.school_outlined,
        'title': 'Academic Buildings',
        'subtitle': 'Classrooms, labs, and departments',
        'onTap': () => _navigateToAcademicBuildings(),
      },
      {
        'icon': Icons.restaurant_outlined,
        'title': 'Cafeterias',
        'subtitle': 'Food courts and canteens',
        'onTap': () => _showFeatureSnackBar('Cafeterias & Dining'),
      },
      {
        'icon': Icons.local_parking_outlined,
        'title': 'Parking Areas',
        'subtitle': 'Available parking spots and zones',
        'onTap': () => _showFeatureSnackBar('Parking Areas'),
      },
      {
        'icon': Icons.local_library_outlined,
        'title': 'Libraries & Study Areas',
        'subtitle': 'Central library and reading rooms',
        'onTap': () => _showFeatureSnackBar('Libraries & Study Areas'),
      },
    ];
  }

  /// Build individual service card
  Widget _buildServiceCard({
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

  /// Navigate to Academic Buildings screen
  void _navigateToAcademicBuildings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AcademicBuildingsScreen()),
    );
  }

  /// Handle feature actions with appropriate behavior
  void _showFeatureSnackBar(String feature) {
    if (feature == "QR Code Scanner") {
      _handleQRScannerAction();
    } else {
      _showComingSoonMessage(feature);
    }
  }

  /// Handle QR Scanner action based on platform support
  void _handleQRScannerAction() {
    if (_isPlatformSupported()) {
      _requestCameraPermissionAndNavigate();
    } else {
      _showUnsupportedPlatformMessage();
    }
  }

  /// Check if current platform supports QR scanning
  bool _isPlatformSupported() {
    return !kIsWeb &&
        !Platform.isWindows &&
        !Platform.isLinux &&
        !Platform.isMacOS;
  }

  /// Request camera permission and navigate to QR scanner
  void _requestCameraPermissionAndNavigate() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      _showCameraPermissionError();
    } else {
      _navigateToQRScanner();
    }
  }

  /// Navigate to QR scanner screen
  void _navigateToQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );
  }

  /// Show coming soon message for features
  void _showComingSoonMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature coming soon!',
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

  /// Show unsupported platform message
  void _showUnsupportedPlatformMessage() {
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

  /// Show camera permission error
  void _showCameraPermissionError() {
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
}
