import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';

// Import our custom paths data
import 'campus_paths.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHARUSAT Navigation',
      home: const CampusMap(),
    );
  }
}

class CampusMap extends StatefulWidget {
  const CampusMap({super.key});

  @override
  State<CampusMap> createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> {
  final MapController _mapController = MapController();

  // User's current location
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Navigation state
  List<LatLng> _currentRoute = [];
  bool _isNavigating = false;
  int _currentWaypointIndex = 0;
  String _navigationInstruction = "";
  double _distanceToDestination = 0.0;
  double _userBearing = 0.0;

  // MAP TYPE SWITCHING
  String _currentMapType = 'normal';
  final Map<String, MapTypeInfo> _mapTypes = {
    'normal': MapTypeInfo(
      name: 'Normal',
      url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      icon: Icons.map,
    ),
    'satellite': MapTypeInfo(
      name: 'Satellite',
      url:
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      icon: Icons.satellite_alt,
    ),
    'hybrid': MapTypeInfo(
      name: 'Hybrid',
      url:
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      icon: Icons.layers,
    ),
  };

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Location permissions are permanently denied');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(_currentLocation!, 18.0);
      _startLocationTracking();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _startLocationTracking() {
    LatLng? previousLocation;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
              (Position position) {
            LatLng newLocation = LatLng(position.latitude, position.longitude);

            if (previousLocation != null) {
              double distance = Geolocator.distanceBetween(
                previousLocation!.latitude,
                previousLocation!.longitude,
                newLocation.latitude,
                newLocation.longitude,
              );

              if (distance > 3.0) {
                setState(() {
                  _userBearing = CampusData.calculateBearing(
                    previousLocation!,
                    newLocation,
                  );
                });
              }
            }

            setState(() {
              _currentLocation = newLocation;
            });

            if (_isNavigating && _currentRoute.isNotEmpty) {
              _updateNavigationProgress();
            }

            previousLocation = newLocation;
          },
        );
  }

  // MAP TYPE SWITCHING METHODS
  void _showMapTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Map Type',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Map type options
              ..._mapTypes.entries.map((entry) {
                bool isSelected = _currentMapType == entry.key;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _currentMapType = entry.key;
                        });
                        Navigator.of(context).pop();
                        _showSnackBar('Switched to ${entry.value.name} view');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue[600]!
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          color: isSelected
                              ? Colors.blue[50]
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue[100]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                entry.value.icon,
                                color: isSelected
                                    ? Colors.blue[600]
                                    : Colors.grey[600],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                entry.value.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.blue[600]
                                      : Colors.black,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Colors.blue[600],
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _updateNavigationProgress() {
    if (_currentLocation == null || _currentRoute.isEmpty) return;

    double distanceToWaypoint = Geolocator.distanceBetween(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      _currentRoute[_currentWaypointIndex].latitude,
      _currentRoute[_currentWaypointIndex].longitude,
    );

    if (distanceToWaypoint < 5.0 &&
        _currentWaypointIndex < _currentRoute.length - 1) {
      setState(() {
        _currentWaypointIndex++;
        _updateNavigationInstruction();
      });
    }

    setState(() {
      _distanceToDestination = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _currentRoute.last.latitude,
        _currentRoute.last.longitude,
      );
    });

    if (_distanceToDestination < 10.0) {
      _completeNavigation();
    }
  }

  void _updateNavigationInstruction() {
    if (_currentWaypointIndex < _currentRoute.length - 1) {
      double bearingToNext = CampusData.calculateBearing(
        _currentLocation!,
        _currentRoute[_currentWaypointIndex + 1],
      );

      String direction = _getDirectionText(bearingToNext);

      setState(() {
        _navigationInstruction = "Continue $direction";
      });
    } else {
      setState(() {
        _navigationInstruction = "Arrived at destination";
      });
    }
  }

  String _getDirectionText(double bearing) {
    if (bearing >= 315 || bearing < 45) return "north";
    if (bearing >= 45 && bearing < 135) return "east";
    if (bearing >= 135 && bearing < 225) return "south";
    return "west";
  }

  void _completeNavigation() {
    setState(() {
      _isNavigating = false;
      _currentRoute = [];
      _currentWaypointIndex = 0;
      _navigationInstruction = "";
    });

    _showSnackBar('🎉 You have arrived!', color: Colors.green);
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 20,
          right: 20,
        ),
      ),
    );
  }

  String _findNearestCampusLocation() {
    if (_currentLocation == null) return '';

    String nearestLocation = '';
    double shortestDistance = double.infinity;

    CampusData.campusLocations.forEach((locationName, coordinates) {
      double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        coordinates.latitude,
        coordinates.longitude,
      );

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestLocation = locationName;
      }
    });

    return nearestLocation;
  }

  List<LatLng> _createPathFromCurrentLocation(String destination) {
    if (_currentLocation == null) return [];

    String nearestCampus = _findNearestCampusLocation();
    List<LatLng> pathToCampus = [_currentLocation!];

    LatLng campusLocation = CampusData.campusLocations[nearestCampus]!;
    pathToCampus.add(campusLocation);

    List<LatLng>? campusToDestination = CampusData.getPath(
      nearestCampus,
      destination,
    );
    if (campusToDestination != null) {
      pathToCampus.addAll(campusToDestination.skip(1));
    } else {
      pathToCampus.add(CampusData.campusLocations[destination]!);
    }

    return pathToCampus;
  }

  void _startNavigation(String source, String destination) {
    List<LatLng>? path;

    if (source == 'My Location') {
      if (_currentLocation == null) {
        _showSnackBar('Current location not available');
        return;
      }

      path = _createPathFromCurrentLocation(destination);
      String nearestCampus = _findNearestCampusLocation();

      _showSnackBar('Route: My Location → $nearestCampus → $destination');
    } else {
      path = CampusData.getPath(source, destination);

      if (path == null) {
        path = [
          CampusData.campusLocations[source]!,
          CampusData.campusLocations[destination]!,
        ];
      }
    }

    if (path != null && path.isNotEmpty) {
      setState(() {
        _currentRoute = path!;
        _isNavigating = true;
        _currentWaypointIndex = 0;
        _navigationInstruction = "Navigation started";
      });

      _mapController.move(_currentRoute.first, 17.0);
    } else {
      _showSnackBar('No route available');
    }
  }

  void _showNavigationBottomSheet() {
    String selectedSource = '';
    String selectedDestination = '';

    List<String> sourceOptions = ['My Location'];
    sourceOptions.addAll(CampusData.campusLocations.keys);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Navigate to',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Source
                  Text(
                    'From',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      hint: const Text('Select starting point'),
                      value: selectedSource.isEmpty ? null : selectedSource,
                      items: sourceOptions.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Row(
                            children: [
                              Icon(
                                location == 'My Location'
                                    ? Icons.my_location
                                    : Icons.business,
                                size: 20,
                                color: location == 'My Location'
                                    ? Colors.blue
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Text(location),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setSheetState(() {
                          selectedSource = newValue ?? '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Destination
                  Text(
                    'To',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      hint: const Text('Select destination'),
                      value: selectedDestination.isEmpty
                          ? null
                          : selectedDestination,
                      items: CampusData.campusLocations.keys.map((
                          String location,
                          ) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.place,
                                size: 20,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 12),
                              Text(location),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setSheetState(() {
                          selectedDestination = newValue ?? '';
                        });
                      },
                    ),
                  ),

                  // Info message
                  if (selectedSource == 'My Location' &&
                      _currentLocation != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Route will go via ${_findNearestCampusLocation()}',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                      selectedSource.isNotEmpty &&
                          selectedDestination.isNotEmpty
                          ? () {
                        if (selectedSource == 'My Location' &&
                            _currentLocation == null) {
                          _showSnackBar('Waiting for GPS location...');
                          return;
                        }
                        _startNavigation(
                          selectedSource,
                          selectedDestination,
                        );
                        Navigator.of(context).pop();
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Start Navigation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen map with DYNAMIC TILE LAYER
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(22.599405, 72.819643),
              initialZoom: 16.0,
            ),
            children: [
              // DYNAMIC TILE LAYER - Changes based on _currentMapType
              TileLayer(
                urlTemplate: _mapTypes[_currentMapType]!.url,
                userAgentPackageName: 'com.example.charusat_navigation',
              ),

              // Hybrid overlay for street names on satellite
              if (_currentMapType == 'hybrid')
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.charusat_navigation',
                ),

              // Route polyline
              if (_isNavigating && _currentRoute.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _currentRoute,
                      color: Colors.red,
                      strokeWidth: 6.0,
                      pattern: StrokePattern.dotted(),  // Dotted pattern
                    ),
                  ],
                ),

              // Campus markers
              MarkerLayer(
                markers: [
                  ...CampusData.campusLocations.entries.map((entry) {
                    return Marker(
                      point: entry.value,
                      width: 80,
                      height: 55,
                      alignment: Alignment.center,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 40 - 17.5,
                            child: const Icon(
                              Icons.place,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // User location with arrow
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          if (_isNavigating && _userBearing != 0.0)
                            Transform.rotate(
                              angle: _userBearing * pi / 180,
                              child: const Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          // MAP TYPE SWITCHER BUTTON (TOP RIGHT)
          Positioned(
            top: 60,
            right: 20,
            child: FloatingActionButton(
              heroTag: "map_type",
              onPressed: _showMapTypeBottomSheet,
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey[700],
              mini: true,
              child: Icon(_mapTypes[_currentMapType]!.icon),
            ),
          ),

          // Bottom navigation button
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _showNavigationBottomSheet,
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              label: const Text('Navigate'),
              icon: const Icon(Icons.directions),
            ),
          ),

          // My location button
          Positioned(
            bottom: 40,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 18.0);
                }
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey[700],
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class for map type information
class MapTypeInfo {
  final String name;
  final String url;
  final IconData icon;

  MapTypeInfo({required this.name, required this.url, required this.icon});
}
