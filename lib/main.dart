import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

// latitude and longitude

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<LatLng> listLocs = [
    LatLng(51.51, -0.09),
    LatLng(51.44, -0.09),
    LatLng(51.45, -0.09),
    LatLng(51.50, -0.09),
  ];

  LatLng myCurrentLocation = LatLng(51.5, -0.09);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map'),
          actions: [
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () async{
                final Position position = await determinePosition();
                myCurrentLocation = LatLng(position.latitude, position.longitude);
                print(position);
                setState(() {

                });
              },
            ),
          ],
        ),
        body: customMap(),
      ),
    );
  }

  Widget customMap() {
    return FlutterMap(
      options: MapOptions(
        center: myCurrentLocation,
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [
            for (LatLng each in listLocs) ...[
              Marker(
                width: 80.0,
                height: 80.0,
                point: each,
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
