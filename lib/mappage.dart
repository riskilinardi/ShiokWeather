import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  Future<String> callapi() async{
    return 'yes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: FutureBuilder(
            future: callapi(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData) {
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
              } else {
                return Card(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: new EdgeInsets.only(top: 5)),
                      Center(child: Text(snapshot.error.toString())),
                    ],
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}
