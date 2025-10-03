// ignore_for_file: unused_local_variable
import 'package:charusat_maps/campus_map.dart';
import 'package:flutter/material.dart';
import 'academic_buildings.dart';
import 'directions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildSliverHeader(screenHeight, screenWidth),
              _buildSliverContent(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader(double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06, // Responsive horizontal padding
          vertical: screenHeight * 0.015,  // Responsive vertical padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.01), // Reduced top spacing
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Responsive font size
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'CHARUSAT',
              style: TextStyle(
                fontSize: screenWidth * 0.09, // Smaller responsive font size
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                height: 1.1,
              ),
            ),
            Text(
              'Campus Navigator',
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Smaller font size
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Reduced bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildSliverContent(double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildExploreSection(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.03), // Responsive spacing
              _buildFeaturesGrid(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildServicesTitle(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              ..._buildServiceCards(screenWidth),
              SizedBox(height: screenHeight * 0.04), // Added more bottom spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreSection(double screenHeight, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20), // Slightly smaller radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.025), // Responsive padding
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.explore,
                  color: Colors.white,
                  size: screenWidth * 0.06, // Responsive icon size
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Text(
                  'Explore Campus',
                  style: TextStyle(
                    fontSize: screenWidth * 0.055, // Smaller responsive font size
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            'Take a virtual 360° tour of our beautiful campus. Discover buildings, facilities, and landmarks.',
            style: TextStyle(
              fontSize: screenWidth * 0.035, // Responsive font size
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PanoramaScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1E40AF),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018), // Responsive padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Start Virtual Tour',
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // Responsive font size
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(double screenHeight, double screenWidth) {
    final features = [
      {
        'icon': Icons.search_rounded,
        'title': 'Find Places',
        'color': const Color(0xFF3B82F6),
        'onTap': () => _showFeatureSnackBar('Find Places'),
      },
      {
        'icon': Icons.navigation_rounded,
        'title': 'Directions',
        'color': const Color(0xFF1D4ED8),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CampusMap()),
          );
        },
      },
      {
        'icon': Icons.school_rounded,
        'title': 'Academic',
        'color': const Color(0xFF2563EB),
        'onTap': () => _navigateToAcademicBuildings(),
      },
      {
        'icon': Icons.map_rounded,
        'title': 'Campus Map',
        'color': const Color(0xFF1E40AF),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CampusMap()),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: screenWidth > 600 ? 2.0 : 1.8, // Responsive aspect ratio
        crossAxisSpacing: screenWidth * 0.03, // Responsive spacing
        mainAxisSpacing: screenWidth * 0.03,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(
          icon: feature['icon'] as IconData,
          title: feature['title'] as String,
          color: feature['color'] as Color,
          onTap: feature['onTap'] as VoidCallback,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.035), // Responsive padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.025), // Responsive padding
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: screenWidth * 0.055, // Responsive icon size
              ),
            ),
            SizedBox(height: screenHeight * 0.008),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.032, // Responsive font size
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTitle(double screenWidth) {
    return Text(
      'Campus Services',
      style: TextStyle(
        fontSize: screenWidth * 0.055, // Responsive font size
        fontWeight: FontWeight.w700,
        color: Colors.grey[800],
      ),
    );
  }

  List<Widget> _buildServiceCards(double screenWidth) {
    return _getServices().map((service) {
      return Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.03), // Responsive margin
        child: _buildServiceCard(
          icon: service['icon'] as IconData,
          title: service['title'] as String,
          subtitle: service['subtitle'] as String,
          color: service['color'] as Color,
          onTap: service['onTap'] as VoidCallback,
          screenWidth: screenWidth,
        ),
      );
    }).toList();
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.045), // Responsive padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.13, // Responsive width
              height: screenWidth * 0.13, // Responsive height
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: screenWidth * 0.065, // Responsive icon size
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.042, // Responsive font size
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, // Responsive font size
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.035, // Responsive icon size
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getServices() {
    return [
      {
        'icon': Icons.school,
        'title': 'Academic Buildings',
        'subtitle': 'Classrooms, labs, and departments',
        'color': const Color(0xFF3B82F6),
        'onTap': () => _navigateToAcademicBuildings(),
      },
      {
        'icon': Icons.restaurant,
        'title': 'Cafeterias & Dining',
        'subtitle': 'Food courts and canteens',
        'color': const Color(0xFF1D4ED8),
        'onTap': () => _showFeatureSnackBar('Cafeterias & Dining'),
      },
      {
        'icon': Icons.local_parking,
        'title': 'Parking Areas',
        'subtitle': 'Available parking spots and zones',
        'color': const Color(0xFF2563EB),
        'onTap': () => _showFeatureSnackBar('Parking Areas'),
      },
      {
        'icon': Icons.local_library,
        'title': 'Libraries & Study Areas',
        'subtitle': 'Central library and reading rooms',
        'color': const Color(0xFF1E40AF),
        'onTap': () => _showFeatureSnackBar('Libraries & Study Areas'),
      },
    ];
  }

  void _navigateToAcademicBuildings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AcademicBuildingsScreen()),
    );
  }

  void _showFeatureSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature coming soon!',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
