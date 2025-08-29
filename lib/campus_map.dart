import 'dart:async';
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

class _PanoramaScreenState extends State<PanoramaScreen> {
  String _currentSceneId = 'main_entrance_1';
  bool _isLoading = true;
  String _displayedPanoramaUrl = '';

  static const Color primary = Color(0xFF497DD1);
  static const Color accent = Color(0xFF007AFF);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndPreload(_currentSceneId);
    });
  }

  void _loadAndPreload(String sceneId) async {
    if (_currentSceneId != sceneId || _displayedPanoramaUrl.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }
    await _loadImage(sceneId);
    _preloadImages();
  }

  Future<void> _loadImage(String imageId) async {
    final scene = panoramaData[imageId];
    if (scene == null) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Scene not found')));
      }
      return;
    }

    final String newPanoramaUrl = scene['url'];
    if (_displayedPanoramaUrl == newPanoramaUrl && !_isLoading) return;

    final ImageProvider imageProvider = CachedNetworkImageProvider(
      newPanoramaUrl,
    );

    try {
      final completer = Completer<void>();
      ImageStreamListener? listener;

      listener = ImageStreamListener(
        (ImageInfo _, bool __) {
          if (!completer.isCompleted) completer.complete();
          if (listener != null) {
            imageProvider
                .resolve(const ImageConfiguration())
                .removeListener(listener);
          }
        },
        onError: (Object exception, StackTrace? stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(exception, stackTrace);
          }
          if (listener != null) {
            imageProvider
                .resolve(const ImageConfiguration())
                .removeListener(listener);
          }
        },
      );

      imageProvider.resolve(const ImageConfiguration()).addListener(listener);
      await completer.future;

      if (mounted) {
        setState(() {
          _displayedPanoramaUrl = newPanoramaUrl;
          _currentSceneId = imageId;
          _isLoading = false;
        });
      }
    } catch (exception) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load image: $imageId'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _preloadImages() {
    final currentScene = panoramaData[_currentSceneId];
    if (currentScene == null) return;

    final List<Map<String, dynamic>> hotspotsData = currentScene['hotspots'];
    int preloadedCount = 0;
    const int maxPreload = 4;

    for (final hotspot in hotspotsData) {
      if (preloadedCount >= maxPreload) break;
      final String nextSceneId = hotspot['id'];
      if (panoramaData.containsKey(nextSceneId)) {
        final ImageProvider imageProvider = CachedNetworkImageProvider(
          panoramaData[nextSceneId]!['url'],
        );
        imageProvider
            .resolve(const ImageConfiguration())
            .addListener(
              ImageStreamListener(
                (ImageInfo _, bool __) {},
                onError: (Object exception, StackTrace? stackTrace) {
                  debugPrint(
                    'Failed to preload image: $nextSceneId - $exception',
                  );
                },
              ),
            );
        preloadedCount++;
      }
    }
  }

  void _changeScene(String newSceneId) {
    if (newSceneId != _currentSceneId) {
      if (panoramaData.containsKey(newSceneId)) {
        _loadAndPreload(newSceneId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scene "$newSceneId" not found!')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final currentScene = panoramaData[_currentSceneId];
    if (currentScene == null) {
      return const Scaffold(
        body: Center(child: Text("Error: Panorama data not found.")),
      );
    }

    final String panoramaUrl = _displayedPanoramaUrl.isEmpty
        ? currentScene['url']
        : _displayedPanoramaUrl;
    final List<Map<String, dynamic>> hotspotsData = currentScene['hotspots'];

    return Scaffold(
      body: Stack(
        children: [
          // Panorama background (manual only, no animation)
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _isLoading ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: PanoramaViewer(
                sensitivity: 1.5,
                zoom: 0.4,
                hotspots: hotspotsData.map((hotspot) {
                  return Hotspot(
                    latitude: hotspot['latitude'],
                    longitude: hotspot['longitude'],
                    width: 80,
                    height: 80,
                    widget: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          primary.withOpacity(0.6),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_circle_up_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                      tooltip: 'Go to ${hotspot['id']}',
                      onPressed: () => _changeScene(hotspot['id']),
                    ),
                  );
                }).toList(),
                child: Image(
                  image: CachedNetworkImageProvider(panoramaUrl),
                  key: ValueKey(panoramaUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Top overlay: back button
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: primary.withOpacity(0.85),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom overlay: instruction
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary.withOpacity(0.9), accent.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Text(
                "Tap the glowing arrows to navigate around campus",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Loading screen
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.75),
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
