import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  bool _isLoading = false;

  // Function to get the current location and update the address
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Request permission to access the device's location
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle permission denied
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        return;
      }

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get the address from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _currentAddress = placemark.name ?? "";
          _isLoading = false; // Hide loading indicator
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false; // Hide loading indicator on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Location Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  CircularProgressIndicator() // Show loading indicator
                else if (_currentAddress != null && _currentAddress!.isNotEmpty)
                  Text(
                    'You are in: $_currentAddress',
                    style: TextStyle(color: Colors.white),
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _getCurrentLocation, // Disable button while loading
                  child: const Text(
                    "Get Current Location",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LocationPage(),
  ));
}
