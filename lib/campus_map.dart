import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'scenes.dart';

class PanoramaScreen extends StatefulWidget {
  const PanoramaScreen({super.key});

  @override
  State<PanoramaScreen> createState() => _PanoramaScreenState();
}

class _PanoramaScreenState extends State<PanoramaScreen>
    with TickerProviderStateMixin {
  String _currentSceneId = 'main_entrance_1';
  bool _isLoading = true;
  String _displayedPanoramaUrl = '';
  bool _showTutorial = true;
  bool _userHasInteracted = false;
  Timer? _tutorialTimer;

  // Street View transition variables
  bool _isTransitioning = false;
  String? _nextSceneUrl;

  // Image preloading
  bool _isImageReady = false;

  // Animation controllers
  late AnimationController _fingerAnimationController;
  late AnimationController _fingerMoveController;
  late AnimationController _pulseController;
  late AnimationController _transitionController;

  // Animations
  late Animation<Offset> _fingerPositionAnimation;
  late Animation<double> _fingerOpacityAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _crossFadeAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _motionBlurAnimation;

  static const Color primary = Color(0xFF497DD1);
  static const Color tutorialColor = Color(0xFF2196F3);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Preload first image before building UI
    _preloadFirstImage().then((_) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadAndPreload(_currentSceneId));
      }
    });
  }

  // Preload the first image to prevent black screen
  Future<void> _preloadFirstImage() async {
    final scene = panoramaData[_currentSceneId];
    if (scene != null) {
      final String panoramaUrl = scene['url'];

      // Precache the image using Flutter's precacheImage
      try {
        await precacheImage(
          CachedNetworkImageProvider(panoramaUrl),
          context,
        );

        if (mounted) {
          setState(() {
            _displayedPanoramaUrl = panoramaUrl;
            _isImageReady = true;
          });
        }
      } catch (e) {
        // If precaching fails, still allow normal loading
        if (mounted) {
          setState(() {
            _displayedPanoramaUrl = panoramaUrl;
            _isImageReady = true;
          });
        }
      }
    }
  }

  void _initializeAnimations() {
    _fingerAnimationController = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _fingerMoveController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    // Street View transition controller
    _transitionController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _fingerPositionAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0.5),
      end: const Offset(0.8, 0.5),
    ).animate(CurvedAnimation(parent: _fingerMoveController, curve: Curves.easeInOut));

    _fingerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fingerAnimationController, curve: const Interval(0.0, 0.3)));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Street View transition animations
    _crossFadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)
    ));

    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut)
    ));

    _motionBlurAnimation = Tween<double>(begin: 0.0, end: 4.0)
        .animate(CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeInOut)
    ));
  }

  @override
  void dispose() {
    _tutorialTimer?.cancel();
    _fingerAnimationController.dispose();
    _fingerMoveController.dispose();
    _pulseController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _loadAndPreload(String sceneId) async {
    // Skip loading screen if image is already ready
    if (_currentSceneId != sceneId || (!_isImageReady && _displayedPanoramaUrl.isEmpty)) {
      setState(() => _isLoading = true);
    }

    await _loadImage(sceneId);
    _preloadImages();
    if (_showTutorial && !_userHasInteracted) _startTutorial();
  }

  void _startTutorial() {
    _tutorialTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted && _showTutorial && !_userHasInteracted) {
        _fingerAnimationController.forward();
        _pulseController.repeat(reverse: true);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _showTutorial && !_userHasInteracted) {
            _fingerMoveController.repeat(reverse: true);
          }
        });
        _tutorialTimer = Timer(const Duration(seconds: 8), () {
          if (mounted && !_userHasInteracted) _hideTutorial();
        });
      }
    });
  }

  void _hideTutorial() {
    setState(() {
      _showTutorial = false;
      _userHasInteracted = true;
    });
    _fingerAnimationController.reverse();
    _fingerMoveController.stop();
    _pulseController.stop();
  }

  Future<void> _loadImage(String imageId) async {
    final scene = panoramaData[imageId];
    if (scene == null) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Scene not found');
      }
      return;
    }

    final String newPanoramaUrl = scene['url'];

    // If image is already preloaded and ready, skip loading
    if (_displayedPanoramaUrl == newPanoramaUrl && _isImageReady) {
      if (mounted) {
        setState(() {
          _currentSceneId = imageId;
          _isLoading = false;
        });
      }
      return;
    }

    final ImageProvider imageProvider = CachedNetworkImageProvider(newPanoramaUrl);

    try {
      // Use precacheImage for smoother loading
      await precacheImage(imageProvider, context);

      if (mounted) {
        setState(() {
          _displayedPanoramaUrl = newPanoramaUrl;
          _currentSceneId = imageId;
          _isLoading = false;
          _isImageReady = true;
        });
      }
    } catch (exception) {
      // Fallback to regular loading if precaching fails
      try {
        final completer = Completer<void>();
        ImageStreamListener? listener;

        listener = ImageStreamListener(
              (ImageInfo _, bool __) {
            if (!completer.isCompleted) completer.complete();
            imageProvider.resolve(const ImageConfiguration()).removeListener(listener!);
          },
          onError: (Object exception, StackTrace? stackTrace) {
            if (!completer.isCompleted) completer.completeError(exception, stackTrace);
            imageProvider.resolve(const ImageConfiguration()).removeListener(listener!);
          },
        );

        imageProvider.resolve(const ImageConfiguration()).addListener(listener);
        await completer.future;

        if (mounted) {
          setState(() {
            _displayedPanoramaUrl = newPanoramaUrl;
            _currentSceneId = imageId;
            _isLoading = false;
            _isImageReady = true;
          });
        }
      } catch (fallbackException) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showSnackBar('Failed to load image: $imageId', isError: true);
        }
      }
    }
  }

  void _preloadImages() {
    final currentScene = panoramaData[_currentSceneId];
    if (currentScene == null) return;

    final hotspotsData = currentScene['hotspots'] as List<Map<String, dynamic>>;
    int preloadedCount = 0;

    for (final hotspot in hotspotsData) {
      if (preloadedCount >= 3) break;
      final nextSceneId = hotspot['id'] as String;
      if (panoramaData.containsKey(nextSceneId)) {
        // Use precacheImage for better preloading
        final imageProvider = CachedNetworkImageProvider(panoramaData[nextSceneId]!['url']);
        precacheImage(imageProvider, context).catchError((error) {
          debugPrint('Failed to preload image: $nextSceneId - $error');
        });
        preloadedCount++;
      }
    }
  }

  // Enhanced scene change with Street View-style transition
  void _changeScene(String newSceneId) async {
    if (newSceneId == _currentSceneId || !panoramaData.containsKey(newSceneId) || _isTransitioning) return;

    final newScene = panoramaData[newSceneId]!;
    final newSceneUrl = newScene['url'];

    setState(() {
      _showTutorial = false;
      _userHasInteracted = true;
      _isTransitioning = true;
      _nextSceneUrl = newSceneUrl;
    });

    _hideTutorial();

    // Preload the new image using precacheImage
    try {
      final imageProvider = CachedNetworkImageProvider(newSceneUrl);
      await precacheImage(imageProvider, context);

      // Start Street View transition
      await _transitionController.forward();

      // Update scene data
      if (mounted) {
        setState(() {
          _displayedPanoramaUrl = newSceneUrl;
          _currentSceneId = newSceneId;
          _isTransitioning = false;
          _nextSceneUrl = null;
        });

        _transitionController.reset();
      }
    } catch (exception) {
      if (mounted) {
        setState(() {
          _isTransitioning = false;
          _nextSceneUrl = null;
        });
        _showSnackBar('Failed to load scene: $newSceneId', isError: true);
      }
    }
  }

  void _onUserInteraction() {
    if (!_userHasInteracted) {
      setState(() => _userHasInteracted = true);
      _hideTutorial();
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  Hotspot _buildHotspot(Map<String, dynamic> hotspot) {
    return Hotspot(
      latitude: hotspot['latitude'],
      longitude: hotspot['longitude'],
      width: 60,
      height: 60,
      widget: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _changeScene(hotspot['id']),
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.navigation, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildFingerTutorial() {
    return AnimatedBuilder(
      animation: Listenable.merge([_fingerPositionAnimation, _fingerOpacityAnimation, _pulseAnimation]),
      builder: (context, _) => Positioned(
        left: MediaQuery.of(context).size.width * _fingerPositionAnimation.value.dx - 30,
        top: MediaQuery.of(context).size.height * _fingerPositionAnimation.value.dy - 30,
        child: Transform.scale(
          scale: _pulseAnimation.value,
          child: Opacity(
            opacity: _fingerOpacityAnimation.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: tutorialColor.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: tutorialColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.touch_app, color: Colors.white, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragTrail() {
    return AnimatedBuilder(
      animation: _fingerMoveController,
      builder: (context, _) => _fingerMoveController.value == 0
          ? const SizedBox.shrink()
          : Positioned.fill(
        child: CustomPaint(
          painter: DragTrailPainter(
            progress: _fingerMoveController.value,
            opacity: _fingerOpacityAnimation.value,
            startX: MediaQuery.of(context).size.width * 0.2,
            endX: MediaQuery.of(context).size.width * 0.8,
            centerY: MediaQuery.of(context).size.height * 0.5,
            color: tutorialColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialInstructions() {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _fingerOpacityAnimation,
        builder: (context, _) => AnimatedOpacity(
          opacity: _fingerOpacityAnimation.value,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tutorialColor.withOpacity(0.9), tutorialColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.panorama_photosphere, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        "360° View Tutorial",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInstructionRow(Icons.swipe, "Drag left & right to explore"),
                const SizedBox(height: 8),
                _buildInstructionRow(Icons.navigation, "Tap arrows to move between locations"),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _hideTutorial,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Text("Got it!", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3))),
      ],
    );
  }

  Widget _buildMinimalLoadingOverlay() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: Container(
          color: Colors.black.withOpacity(0.2),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.threeArchedCircle(
                  color: primary,
                  size: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  "Loading image...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Street View-style panorama with transition effects
  Widget _buildStreetViewPanorama(String panoramaUrl, List<Map<String, dynamic>> hotspotsData) {
    return AnimatedBuilder(
      animation: Listenable.merge([_crossFadeAnimation, _zoomAnimation, _motionBlurAnimation]),
      builder: (context, child) {
        Widget panoramaWidget = Transform.scale(
          scale: _zoomAnimation.value,
          child: Stack(
            children: [
              // Current panorama
              PanoramaViewer(
                sensitivity: 1.2,
                zoom: 0.5,
                animSpeed: 0.0,
                hotspots: (_isLoading || _isTransitioning) ? [] : hotspotsData.map((hotspot) => _buildHotspot(hotspot)).toList(),
                child: Image(
                  image: CachedNetworkImageProvider(panoramaUrl),
                  key: ValueKey(panoramaUrl),
                  fit: BoxFit.cover,
                  gaplessPlayback: true, // Prevents black flicker during transitions
                ),
              ),

              // Transition overlay for new panorama
              if (_isTransitioning && _nextSceneUrl != null)
                Opacity(
                  opacity: _crossFadeAnimation.value,
                  child: PanoramaViewer(
                    sensitivity: 1.2,
                    zoom: 0.5,
                    animSpeed: 0.0,
                    hotspots: const [],
                    child: Image(
                      image: CachedNetworkImageProvider(_nextSceneUrl!),
                      key: ValueKey(_nextSceneUrl),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
            ],
          ),
        );

        // Apply motion blur effect during transition
        if (_isTransitioning && _motionBlurAnimation.value > 0) {
          return ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _motionBlurAnimation.value,
              sigmaY: _motionBlurAnimation.value * 0.3, // Horizontal blur emphasis
            ),
            child: panoramaWidget,
          );
        }

        return panoramaWidget;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentScene = panoramaData[_currentSceneId];
    if (currentScene == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("Error: Panorama data not found.", style: TextStyle(color: Colors.white))),
      );
    }

    final hotspotsData = currentScene['hotspots'] as List<Map<String, dynamic>>;
    final panoramaUrl = _displayedPanoramaUrl.isEmpty ? currentScene['url'] : _displayedPanoramaUrl;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanStart: (_) => _onUserInteraction(),
        onTapDown: (_) => _onUserInteraction(),
        child: Stack(
          children: [
            // Street View-style Panorama with transition effects
            if (_isImageReady) // Only show panorama when image is ready
              Positioned.fill(
                child: _buildStreetViewPanorama(panoramaUrl, hotspotsData),
              ),

            // Tutorial elements
            if (_showTutorial && !_userHasInteracted && !_isLoading && !_isTransitioning && _isImageReady) ...[
              _buildFingerTutorial(),
              _buildDragTrail(),
              _buildTutorialInstructions(),
            ],

            // Back button
            if (_isImageReady)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),

            // Loading overlay - only show when actually loading
            if (!_isImageReady || _isLoading)
              Positioned.fill(
                child: _buildMinimalLoadingOverlay(),
              ),

            // REMOVED: Transition loading indicator with "Moving..." text
            // The smooth transitions now happen without any visible loading indicator
          ],
        ),
      ),
    );
  }
}

// Optimized Custom Painter
class DragTrailPainter extends CustomPainter {
  final double progress, opacity, startX, endX, centerY;
  final Color color;

  const DragTrailPainter({
    required this.progress,
    required this.opacity,
    required this.startX,
    required this.endX,
    required this.centerY,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity == 0) return;

    final currentX = startX + (endX - startX) * progress;
    final paint = Paint()
      ..color = color.withOpacity(opacity * 0.3)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw trail
    canvas.drawLine(Offset(startX, centerY), Offset(currentX, centerY), paint);

    // Draw arrow
    if (progress > 0.1) {
      final arrowPaint = paint..color = color.withOpacity(opacity * 0.6);
      canvas.drawLine(Offset(currentX - 12, centerY - 8), Offset(currentX, centerY), arrowPaint);
      canvas.drawLine(Offset(currentX - 12, centerY + 8), Offset(currentX, centerY), arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
