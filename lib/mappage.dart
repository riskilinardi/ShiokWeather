import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 20, bottom: 200, right: 20, left: 20),
      color: Colors.black87,
      child: new FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(1.3521, 103.8198), // Center the map over London
          initialZoom: 12,
        ),
        children: [
          TileLayer( // Bring your own tiles
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
            userAgentPackageName: 'com.example.app', // Add your app identifier
            // And many more recommended properties!
          ),
        ],
      ),
    );
  }
}
