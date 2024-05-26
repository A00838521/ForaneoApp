import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}

class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location(
      {required this.name, required this.latitude, required this.longitude});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final LocationService locationService = LocationService();
  final double nearbyRadius = 10000; // 10 kilometers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Call the function when the button is pressed
            await _runLocationService();
          },
          child: Text('Get Nearby Locations'),
        ),
      ),
    );
  }

  // Function to run the location service and print nearby locations
  Future<void> _runLocationService() async {
    Position userLocation = await locationService.getCurrentLocation();

    List<Location> locations = [
      Location(
          name: 'Location 1',
          latitude: 25.65161843458422,
          longitude: -100.292331030908),
      Location(name: 'Location 2', latitude: 34.0522, longitude: -118.2437),
      Location(name: 'Location 3', latitude: 51.5074, longitude: -0.1278),
      // Add more locations as needed
    ];

    List<String> nearbyLocations = [];

    locations.forEach((location) {
      double distance = locationService.calculateDistance(userLocation.latitude,
          userLocation.longitude, location.latitude, location.longitude);

      if (distance <= nearbyRadius) {
        nearbyLocations.add(location.name);
      }
    });

    print('Nearby locations: $nearbyLocations');
  }
}
