class RouteManager {
  static const Map<String, List<String>> routeImages = {
    'A6_A7': [
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A6-A7(3).png', // By Vehicle
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A6-A7(2).png', // Shortest
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A6-A7(1).png', // Accessible
    ],
    'A7_A6': [
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A6-A7(3).png', // By Vehicle
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A6-A7(2).png', // Shortest
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A6-A7(1).png', // Accessible
    ],
    'A7_ADMIN_BLOCK': [
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A7-ADMIN(1).png', // By Vehicle
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A7-ADMIN(3).png', // Shortest
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A7-ADMIN(2).png', // Accessible
    ],
    'ADMIN_BLOCK_A7': [
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A7-ADMIN(2).png', // Accessible
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A7-ADMIN(3).png', // Shortest
      'https://raw.githubusercontent.com/thatsaryan/Campus_View/main/A7-ADMIN(1).png', // By Vehicle
    ],
  };

  // Route distances in meters - Updated order
  static const Map<String, Map<String, int>> routeDistances = {
    'A6_A7': {'accessible': 293, 'shortest': 187, 'by_vehicle': 287},
    'A7_A6': {'accessible': 293, 'shortest': 187, 'by_vehicle': 287},
    'A7_ADMIN_BLOCK': {'accessible': 300, 'shortest': 225, 'by_vehicle': 350},
    'ADMIN_BLOCK_A7': {'accessible': 300, 'shortest': 225, 'by_vehicle': 350},
  };

  // Route type names in NEW correct order - matching your file organization
  static const List<String> routeTypeNames = [
    'Accessible', // Index 0 - (1).png for A6-A7, (2).png for A7-ADMIN
    'Shortest', // Index 1 - (2).png for A6-A7, (3).png for A7-ADMIN
    'By Vehicle', // Index 2 - (3).png for A6-A7, (1).png for A7-ADMIN
  ];

  // Route type keys for distance lookup - NEW order
  static const List<String> routeTypeKeys = [
    'accessible', // Index 0
    'shortest', // Index 1
    'by_vehicle', // Index 2
  ];

  // Route type descriptions in NEW correct order
  static const List<String> routeTypeDescriptions = [
    'Wheelchair accessible route with ramps', // Index 0 - Accessible
    'Shortest walking distance route', // Index 1 - Shortest
    'Vehicle-friendly route with road access', // Index 2 - By Vehicle
  ];

  /// Fixed normalization that handles your specific QR code format
  static String _normalizeLocation(String location) {
    String normalized = location.toUpperCase().trim();

    // Handle specific QR code formats first
    if (normalized.contains('CSPIT - A6') ||
        normalized.contains('CSPIT-A6') ||
        normalized.contains('CSPIT A6')) {
      return 'A6';
    }
    if (normalized.contains('CSPIT - A7') ||
        normalized.contains('CSPIT-A7') ||
        normalized.contains('CSPIT A7')) {
      return 'A7';
    }

    // Handle other specific cases
    if (normalized.contains('ADMIN BLOCK') ||
        normalized.contains('ADMIN-BLOCK') ||
        normalized.contains('ADMIN_BLOCK')) {
      return 'ADMIN_BLOCK';
    }

    // Handle other locations
    normalized = normalized
        .replaceAll('MAIN GATE - 1', 'MAIN_GATE_1')
        .replaceAll('GATE - 2', 'GATE_2')
        .replaceAll('CENTRAL LAWN', 'CENTRAL_LAWN')
        .replaceAll('GIRLS HOSTEL', 'GIRLS_HOSTEL')
        .replaceAll('CRICKET GROUND', 'CRICKET_GROUND')
        .replaceAll('GATE-2 CANTEEN', 'GATE_2_CANTEEN');

    // Clean up any remaining special characters
    normalized = normalized
        .replaceAll(RegExp(r'[^A-Z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return normalized;
  }

  /// Generate route key from source and destination
  static String generateRouteKey(String source, String destination) {
    final normalizedSource = _normalizeLocation(source);
    final normalizedDestination = _normalizeLocation(destination);
    return '${normalizedSource}_$normalizedDestination';
  }

  /// Get image URLs for a specific route (returns all 3 route types)
  static List<String>? getRouteImages(String source, String destination) {
    final routeKey = generateRouteKey(source, destination);
    return routeImages[routeKey];
  }

  /// Get distance for a specific route and type
  static int? getRouteDistance(
    String source,
    String destination,
    int routeTypeIndex,
  ) {
    final routeKey = generateRouteKey(source, destination);
    if (routeTypeIndex >= 0 && routeTypeIndex < routeTypeKeys.length) {
      final routeTypeKey = routeTypeKeys[routeTypeIndex];
      return routeDistances[routeKey]?[routeTypeKey];
    }
    return null;
  }

  /// Get a specific route type image (0=Accessible, 1=Shortest, 2=By Vehicle)
  static String? getRouteImageByType(
    String source,
    String destination,
    int routeType,
  ) {
    final images = getRouteImages(source, destination);
    if (images != null && routeType >= 0 && routeType < images.length) {
      return images[routeType];
    }
    return null;
  }

  /// Check if a route exists
  static bool routeExists(String source, String destination) {
    final routeKey = generateRouteKey(source, destination);
    return routeImages.containsKey(routeKey);
  }

  /// Get all available routes
  static List<String> getAllRoutes() {
    return routeImages.keys.toList();
  }

  /// Get route type name by index
  static String getRouteTypeName(int index) {
    if (index >= 0 && index < routeTypeNames.length) {
      return routeTypeNames[index];
    }
    return 'Unknown Route';
  }

  /// Get route type description by index
  static String getRouteTypeDescription(int index) {
    if (index >= 0 && index < routeTypeDescriptions.length) {
      return routeTypeDescriptions[index];
    }
    return 'No description available';
  }
}
