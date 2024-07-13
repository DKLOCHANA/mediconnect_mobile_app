import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PharmacyLocatorPage extends StatefulWidget {
  @override
  _PharmacyLocatorPageState createState() => _PharmacyLocatorPageState();
}

class _PharmacyLocatorPageState extends State<PharmacyLocatorPage> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getNearbyPharmacies();
    }).catchError((e) {
      print(e);
    });
  }

  void _getNearbyPharmacies() async {
    if (_currentPosition == null) return;

    final String apiKey = 'your apikey here';
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final String location =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final String radius = '5000'; // Search within 5km radius
    final String type = 'pharmacy'; // search category

    final String requestUrl =
        '$baseUrl?location=$location&radius=$radius&type=$type&key=$apiKey';

    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      setState(() {
        _markers.clear();
        for (var result in results) {
          final lat = result['geometry']['location']['lat'];
          final lng = result['geometry']['location']['lng'];
          final name = result['name'];
          final placeId = result['place_id'];

          _markers.add(
            Marker(
              markerId: MarkerId(placeId),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: name,
                onTap: () => _showPharmacyDetails(placeId),
              ),
            ),
          );
        }
      });
    } else {
      print('Failed to load nearby pharmacies');
    }
  }

  void _showPharmacyDetails(String placeId) async {
    final String apiKey = 'your apikey here';
    final String detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(detailsUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              result['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  if (result['formatted_address'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              result['formatted_address'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (result['formatted_phone_number'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              result['formatted_phone_number'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (result['rating'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 10),
                          Text(
                            result['rating'].toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to load pharmacy details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Pharmacies Near Me',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: _currentPosition == null
            ? Center(child: CircularProgressIndicator())
            : GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude),
                  zoom: 15,
                ),
                markers: _markers,
              ),
      ),
    );
  }
}
