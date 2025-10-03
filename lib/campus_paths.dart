// campus_paths.dart
import 'package:latlong2/latlong.dart';

class CampusData {
  // Campus locations with their coordinates (from your image)
  static const Map<String, LatLng> campusLocations = {
    'CSPIT (A6)': LatLng(22.6001, 72.8191),
    'CSPIT (A7)': LatLng(22.599400, 72.817800),
    'RPCP (A3)': LatLng(22.5993, 72.8195),
    'Lake & Lake Canteen': LatLng(22.5985, 72.8202),
    'IIIM (A2)': LatLng(22.6002, 72.8209),
    'Cricket Ground': LatLng(22.5993, 72.8217),
    'Admin Building (A1)': LatLng(22.5999, 72.8202),
    'DEPSTAR (A5)': LatLng(22.6008, 72.8205),
    'Girls Hostel': LatLng(22.6015, 72.8187),
    'PDPIAS (A8)': LatLng(22.6018, 72.8196),
    'CMPICA': LatLng(22.603258, 72.818346),
  };

  // Pre-defined custom walking paths following the WHITE ROADS from your campus image
  static const Map<String, Map<String, List<LatLng>>> customPaths = {
    'CSPIT (A7)': {
      'Admin Building (A1)': [
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600669, 72.81947),
        LatLng(22.600670, 72.819510),
        LatLng(22.599971, 72.819915),
        LatLng(22.600081, 72.820117),
        LatLng(22.5999, 72.8202), // End: Admin Building (A1)
      ],
      'IIIM (A2)': [
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600669, 72.81947),
        LatLng(22.600670, 72.819510),
        LatLng(22.599971, 72.819915),
        LatLng(22.600133, 72.820208),
        LatLng(22.600098, 72.820368),
        LatLng(22.599966, 72.820434),
        LatLng(22.6002, 72.8209), // End: IIIM (A2)
      ],
      'RPCP (A3)': [
        // Internal campus road from A7 to A6
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600669, 72.81947),
        LatLng(22.600670, 72.819510),
        LatLng(22.599984, 72.819911),
        LatLng(22.599824, 72.819896),
        LatLng(22.59956, 72.820057),
        LatLng(22.5993, 72.8195), // End: RPCP (A3)
      ],
      'DEPSTAR (A5)': [
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600669, 72.81947),
        LatLng(22.600333, 72.819673),
        LatLng(22.600518, 72.81996), // End: DEPSTAR (A5)
      ],
      'CSPIT (A6)': [
        // Internal campus road from A7 to A6
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600669, 72.81947),
        LatLng(22.600670, 72.819510),
        LatLng(22.600444, 72.81964),
        LatLng(22.6001, 72.8191), // End: CSPIT (A6)
      ],
      'Girls Hostel': [
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600052, 72.818102),
        LatLng(22.600199, 72.818351),
        LatLng(22.601024, 72.817872),
        LatLng(22.601428, 72.818726),
      ],
      'PDPIAS (A8)':[
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600898, 72.819353),
        LatLng(22.600990 ,72.819460),
        LatLng(22.601329, 72.819230),
        LatLng(22.6018, 72.8196),
      ],
      'CMPICA':[
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600898, 72.819353),
        LatLng(22.600990 ,72.819460),
        LatLng(22.601680, 72.819000),
        LatLng(22.601950, 72.819000),
        LatLng(22.602110, 72.818920),
        LatLng(22.602551, 72.818550),
        LatLng(22.602690, 72.818563),
        LatLng(22.602800, 72.818650),
        LatLng(22.603155, 72.819070),
        LatLng(22.603400, 72.818880),
        LatLng(22.603258, 72.818346), //End: CMPICA
      ],
      'Lake & Lake Canteen':[
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600669, 72.81947),
        LatLng(22.600670, 72.819510),
        LatLng(22.599971, 72.819915),
        LatLng(22.599831, 72.819900),
        LatLng(22.599247, 72.820256),
        LatLng(22.599156, 72.820594),
        LatLng(22.598803, 72.820825),
        LatLng(22.5985, 72.8202),
      ],
      'Cricket Ground':[
        LatLng(22.599400, 72.817800), // Start: CSPIT (A7)
        LatLng(22.599571, 72.818103),
        LatLng(22.599883, 72.818175),
        LatLng(22.600000, 72.818090),
        LatLng(22.600765, 72.819380),
        LatLng(22.600669, 72.81947),
        LatLng(22.600670, 72.819510),
        LatLng(22.599971, 72.819915),
        LatLng(22.599831, 72.819900),
        LatLng(22.599247, 72.820256),
        LatLng(22.599156, 72.820594),
        LatLng(22.598803, 72.820825),
        LatLng(22.5993, 72.8217),
      ]

    },

    'CSPIT (A6)': {
      'DEPSTAR (A5)': [
        // Main road from CSPIT A6 to DEPSTAR A5
        LatLng(22.6001, 72.8191), // Start: CSPIT (A6)
        LatLng(22.6008, 72.8205), // End: DEPSTAR (A5)
      ],
      'RPCP (A3)': [
        LatLng(22.6001, 72.8191), // Start: CSPIT (A6)
        LatLng(22.6004, 72.819660), // Towards the road
        LatLng(22.599980, 72.8199), // Toward RPCP
        LatLng(22.599820, 72.819890), // Turn
        LatLng(22.599580, 72.820050), // Straight Road
        LatLng(22.5993, 72.8195), // End: RPCP
      ],
      'Lake & Lake Canteen': [
        // Road from CSPIT A6 to Lake area
        LatLng(22.600100, 72.819150), // Start: CSPIT (A6)
        LatLng(22.5998, 72.8195), // Turn towards lake road
        LatLng(22.5995, 72.8198), // Follow lake access road
        LatLng(22.5990, 72.8201), // Approach lake area
        LatLng(22.5980, 72.8202), // End: Lake & Lake Canteen
      ],
      'IIIM (A2)': [
        // Road from A6 to IIIM A2
        LatLng(22.600100, 72.819150), // Start: CSPIT (A6)
        LatLng(22.6002, 72.8195), // Main road
        LatLng(22.6003, 72.8200), // Continue north
        LatLng(22.6003, 72.8205), // Turn east toward IIIM
        LatLng(22.6002, 72.8209), // End: IIIM (A2)
      ],
    },

    'DEPSTAR (A5)': {
      'Girls Hostel': [
        // Road from DEPSTAR to Girls Hostel
        LatLng(22.6010, 72.8205), // Start: DEPSTAR (A5)
        LatLng(22.6012, 72.8200), // Exit DEPSTAR road
        LatLng(22.6013, 72.8195), // Turn towards hostel road
        LatLng(22.6014, 72.8190), // Hostel access road
        LatLng(22.6015, 72.8187), // End: Girls Hostel
      ],
      'PDPIAS (A8)': [
        // Road from DEPSTAR to PDPIAS
        LatLng(22.6010, 72.8205), // Start: DEPSTAR (A5)
        LatLng(22.6013, 72.8202), // Turn towards A8
        LatLng(22.6015, 72.8199), // Follow road to A8
        LatLng(22.6017, 72.8197), // Approach A8
        LatLng(22.6018, 72.8196), // End: PDPIAS (A8)
      ],
    },

    'Admin Building (A1)': {
      'IIIM (A2)': [
        // Central road from Admin to IIIM
        LatLng(22.5999, 72.8202), // Start: Admin Building (A1)
        LatLng(22.6000, 72.8205), // Central campus road
        LatLng(22.6001, 72.8207), // Continue east
        LatLng(22.6002, 72.8209), // End: IIIM (A2)
      ],
      'Cricket Ground': [
        // Road from Admin to Cricket Ground
        LatLng(22.5999, 72.8202), // Start: Admin Building (A1)
        LatLng(22.5997, 72.8205), // Turn south
        LatLng(22.5995, 72.8210), // Continue towards ground
        LatLng(22.5994, 72.8215), // Approach ground
        LatLng(22.5993, 72.8217), // End: Cricket Ground
      ],
    },

    'IIIM (A2)': {
      'Cricket Ground': [
        // Road from IIIM to Cricket Ground
        LatLng(22.6002, 72.8209), // Start: IIIM (A2)
        LatLng(22.6000, 72.8212), // Exit IIIM road
        LatLng(22.5997, 72.8214), // Turn towards ground
        LatLng(22.5995, 72.8216), // Ground access road
        LatLng(22.5993, 72.8217), // End: Cricket Ground
      ],
    },

    'RPCP (A3)': {
      'Lake & Lake Canteen': [
        // Road from RPCP to Lake
        LatLng(22.5993, 72.8195), // Start: RPCP (A3)
        LatLng(22.5990, 72.8198), // Follow road to lake
        LatLng(22.5988, 72.8200), // Continue to lake area
        LatLng(22.5985, 72.8202), // End: Lake & Lake Canteen
      ],
      'Admin Building (A1)': [
        // Road from RPCP to Admin
        LatLng(22.5993, 72.8195), // Start: RPCP (A3)
        LatLng(22.5996, 72.8198), // Turn towards admin
        LatLng(22.5998, 72.8200), // Continue on road
        LatLng(22.5999, 72.8202), // End: Admin Building (A1)
      ],
    },

    // Add more circular routes that follow the white roads
    'Girls Hostel': {
      'PDPIAS (A8)': [
        // North campus road connection
        LatLng(22.6015, 72.8187), // Start: Girls Hostel
        LatLng(22.6017, 72.8190), // North campus road
        LatLng(22.6018, 72.8193), // Continue east
        LatLng(22.6018, 72.8196), // End: PDPIAS (A8)
      ],
    },
  };

  // Helper method to get path between two locations
  static List<LatLng>? getPath(String source, String destination) {
    if (customPaths.containsKey(source) &&
        customPaths[source]!.containsKey(destination)) {
      return customPaths[source]![destination];
    } else if (customPaths.containsKey(destination) &&
        customPaths[destination]!.containsKey(source)) {
      // Return reverse path
      return customPaths[destination]![source]!.reversed.toList();
    }
    return null;
  }

  // Get all available destinations from a source
  static List<String> getAvailableDestinations(String source) {
    List<String> destinations = [];

    // Direct paths from source
    if (customPaths.containsKey(source)) {
      destinations.addAll(customPaths[source]!.keys);
    }

    // Reverse paths (where source is destination)
    customPaths.forEach((key, paths) {
      if (paths.containsKey(source) && !destinations.contains(key)) {
        destinations.add(key);
      }
    });

    return destinations;
  }

  // Calculate bearing for arrow rotation
  static double calculateBearing(LatLng startPoint, LatLng endPoint) {
    const double pi = 3.141592653589793;

    final double startLat = startPoint.latitude * pi / 180;
    final double startLng = startPoint.longitude * pi / 180;
    final double endLat = endPoint.latitude * pi / 180;
    final double endLng = endPoint.longitude * pi / 180;

    final double deltaLng = endLng - startLng;

    final double y = sin(deltaLng) * cos(endLat);
    final double x =
        cos(startLat) * sin(endLat) -
        sin(startLat) * cos(endLat) * cos(deltaLng);

    final double bearing = atan2(y, x);

    return (bearing * 180 / pi + 360) % 360;
  }
}

// Extension methods for easier path operations
extension PathExtensions on List<LatLng> {
  // Get direction arrows at regular intervals
  List<DirectionArrow> getDirectionArrows({double intervalMeters = 30}) {
    List<DirectionArrow> arrows = [];

    for (int i = 0; i < length - 1; i++) {
      final bearing = CampusData.calculateBearing(this[i], this[i + 1]);
      arrows.add(DirectionArrow(position: this[i], bearing: bearing, index: i));
    }

    return arrows;
  }
}

// Direction arrow data class
class DirectionArrow {
  final LatLng position;
  final double bearing;
  final int index;

  DirectionArrow({
    required this.position,
    required this.bearing,
    required this.index,
  });
}

// Math helper functions
double sin(double x) => x - x * x * x / 6 + x * x * x * x * x / 120;
double cos(double x) => 1 - x * x / 2 + x * x * x * x / 24;
double atan2(double y, double x) {
  if (x > 0) return atan(y / x);
  if (x < 0 && y >= 0) return atan(y / x) + 3.141592653589793;
  if (x < 0 && y < 0) return atan(y / x) - 3.141592653589793;
  if (x == 0 && y > 0) return 3.141592653589793 / 2;
  if (x == 0 && y < 0) return -3.141592653589793 / 2;
  return 0; // x == 0 && y == 0
}

double atan(double x) => x - x * x * x / 3 + x * x * x * x * x / 5;
