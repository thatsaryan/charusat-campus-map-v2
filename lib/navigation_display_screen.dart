// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class NavigationDisplayScreen extends StatefulWidget {
  final String source;
  final String destination;
  final List<String>? imageUrls;

  const NavigationDisplayScreen({
    Key? key,
    required this.source,
    required this.destination,
    this.imageUrls,
  }) : super(key: key);

  @override
  State<NavigationDisplayScreen> createState() =>
      _NavigationDisplayScreenState();
}

class _NavigationDisplayScreenState extends State<NavigationDisplayScreen> {
  static const Color primary = Color(0xFF497DD1);
  static const Color secondary = Color(0xFF6C7293);
  static const Color accent = Color(0xFF007AFF);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color cardSurface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C7293);
  static const Color border = Color(0xFFE5E7EB);

  // PageView controller for image sliding
  PageController _pageController = PageController();
  int _currentImageIndex = 0;
  List<String> _imageUrls = [];

  // Zoom control variables
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _imageUrls = widget.imageUrls ?? _getImageUrlsForRoute();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCompactRouteInfo(),
          _buildLargeImageViewer(),
          if (_imageUrls.length > 1) _buildPathSelector(),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  /// Build the app bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Navigation Route',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Build compact route information (reduced size)
  Widget _buildCompactRouteInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // From section
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.location_on, color: Colors.green, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.source,
                        style: const TextStyle(
                          color: textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // To section
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.flag, color: Colors.red, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.destination,
                        style: const TextStyle(
                          color: textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Path count indicator
          if (_imageUrls.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_imageUrls.length} paths',
                style: TextStyle(
                  color: accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build large image viewer with gesture conflict prevention
  Widget _buildLargeImageViewer() {
    return Expanded(
      flex: 6,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // PageView with conditional physics
              PageView.builder(
                controller: _pageController,
                physics: _isZoomed
                    ? const NeverScrollableScrollPhysics() // Disable when zoomed
                    : const BouncingScrollPhysics(), // Enable when not zoomed
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                    // Reset zoom when changing pages
                    _transformationController.value = Matrix4.identity();
                    _isZoomed = false;
                  });
                },
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: surface,
                    child: _buildSimpleZoomImage(_imageUrls[index], index),
                  );
                },
              ),

              // Page indicators (dots)
              if (_imageUrls.length > 1)
                Positioned(top: 16, right: 16, child: _buildPageIndicator()),

              // Path label
              if (_imageUrls.length > 1)
                Positioned(top: 16, left: 16, child: _buildPathLabel()),

              // Navigation arrows - only show when not zoomed
              if (_imageUrls.length > 1 && !_isZoomed) ...[
                _buildNavigationArrow(isLeft: true),
                _buildNavigationArrow(isLeft: false),
              ],

              // Zoom reset button - only show when zoomed
              if (_isZoomed)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _buildZoomResetButton(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Enhanced zoom image with scale monitoring
  Widget _buildSimpleZoomImage(String imageUrl, int index) {
    if (imageUrl.isNotEmpty) {
      return Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(10),
          minScale: 0.8,
          maxScale: 3.0,
          onInteractionUpdate: (details) {
            // Check if user is zoomed in
            final scale = _transformationController.value.getMaxScaleOnAxis();
            final newIsZoomed = scale > 1.1; // Consider zoomed if scale > 1.1
            if (newIsZoomed != _isZoomed) {
              setState(() {
                _isZoomed = newIsZoomed;
              });
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorPlaceholder(index);
              },
            ),
          ),
        ),
      );
    } else {
      return _buildPlaceholderContent(index);
    }
  }

  /// Build zoom reset button
  Widget _buildZoomResetButton() {
    return GestureDetector(
      onTap: () {
        _transformationController.value = Matrix4.identity();
        setState(() {
          _isZoomed = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.zoom_out_map, color: textPrimary, size: 20),
      ),
    );
  }

  /// Build page indicator dots
  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_imageUrls.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentImageIndex == index
                  ? primary
                  : textSecondary.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }

  /// Build path label
  Widget _buildPathLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Path ${_currentImageIndex + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Updated navigation arrows to reset zoom
  Widget _buildNavigationArrow({required bool isLeft}) {
    return Positioned(
      left: isLeft ? 12 : null,
      right: isLeft ? null : 12,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            // Reset zoom before changing pages
            _transformationController.value = Matrix4.identity();
            setState(() {
              _isZoomed = false;
            });

            if (isLeft && _currentImageIndex > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else if (!isLeft && _currentImageIndex < _imageUrls.length - 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: border.withOpacity(0.5)),
            ),
            child: Icon(
              isLeft ? Icons.chevron_left : Icons.chevron_right,
              color: textPrimary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// Build path selector buttons
  Widget _buildPathSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_imageUrls.length, (index) {
                final isSelected = _currentImageIndex == index;
                return GestureDetector(
                  onTap: () {
                    // Reset zoom before changing paths
                    _transformationController.value = Matrix4.identity();
                    setState(() {
                      _isZoomed = false;
                    });

                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : cardSurface,
                      border: Border.all(
                        color: isSelected ? primary : border,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getPathName(index),
                      style: TextStyle(
                        color: isSelected ? Colors.white : textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Get path name for display
  String _getPathName(int index) {
    final pathNames = ['Accessible', 'Shortest', 'By vehicle'];

    if (index < pathNames.length) {
      return pathNames[index];
    }
    return 'Path ${index + 1}';
  }

  /// Get specific image URLs based on route
  List<String> _getImageUrlsForRoute() {
    final route = '${widget.source}_to_${widget.destination}'
        .toLowerCase()
        .replaceAll(' ', '_');

    final routeImages = {
      'cspit_a6_to_cspit_a7': [
        'https://raw.githubusercontent.com/thatsaryan/Campus_View/a02da1cf91050fa5c3aa4cb8c3875badb19da20a/A6-A7(1).png',
        'https://raw.githubusercontent.com/thatsaryan/Campus_View/a02da1cf91050fa5c3aa4cb8c3875badb19da20a/A6-A7(2).png',
        'https://raw.githubusercontent.com/thatsaryan/Campus_View/a02da1cf91050fa5c3aa4cb8c3875badb19da20a/A6-A7(3).png',
      ],
    };

    return routeImages[route] ?? [];
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ),
    );
  }

  /// Build error placeholder
  Widget _buildErrorPlaceholder(int pathIndex) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: textSecondary),
          const SizedBox(height: 12),
          Text(
            'Unable to load Path ${pathIndex + 1}',
            style: TextStyle(color: textPrimary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {}),
            child: Text('Retry', style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  /// Build placeholder content
  Widget _buildPlaceholderContent(int pathIndex) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PATH ${pathIndex + 1}',
            style: TextStyle(
              color: textSecondary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Navigation map will appear here',
            style: TextStyle(color: textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Build navigation buttons
  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              title: 'Start Navigation',
              icon: Icons.navigation,
              isPrimary: true,
              onTap: _startNavigation,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              title: 'Share Route',
              icon: Icons.share,
              isPrimary: false,
              onTap: _shareRoute,
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual action button
  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? primary : cardSurface,
          border: isPrimary ? null : Border.all(color: border),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : textPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isPrimary ? Colors.white : textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle start navigation action
  void _startNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting navigation via ${_getPathName(_currentImageIndex)} from ${widget.source} to ${widget.destination}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Handle share route action
  void _shareRoute() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing ${_getPathName(_currentImageIndex)}...',
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
