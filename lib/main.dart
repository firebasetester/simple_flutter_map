import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() {
  runApp(MyApp());
}

// latitude and longitude

class MyApp extends StatelessWidget {
  List<LatLng> listLocs = [
    LatLng(51.51, -0.09),
    LatLng(51.44, -0.09),
    LatLng(51.45, -0.09),
    LatLng(51.50, -0.09),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: customMap(),
      ),
    );
  }

  Widget customMap() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.5, -0.09),
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
          // markers: [
          //   Marker(
          //     width: 80.0,
          //     height: 80.0,
          //     point: LatLng(51.5, -0.09),
          //     builder: (ctx) => Container(
          //       child: Icon(
          //         Icons.location_on,
          //         color: Colors.red,
          //         size: 50,
          //       ),
          //     ),
          //   ),
          //   Marker(
          //     width: 80.0,
          //     height: 80.0,
          //     point: LatLng(51.5, -0.08),
          //     builder: (ctx) => Container(
          //       child: Icon(
          //         Icons.location_on,
          //         color: Colors.blue,
          //         size: 50,
          //       ),
          //     ),
          //   ),
          // ],
        ),
      ],
    );
  }
}
