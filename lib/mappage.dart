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
import 'db.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  List<Map<String, dynamic>> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  // Load all users from the database
  _loadReports() async {
    List<Map<String, dynamic>> reports = await DatabaseHelper.instance.queryAllFloodReport();
    setState(() {
      _reports = reports;
    });
  }

  Future<String> callapi() async{
    return 'yes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
                child: Stack(
                  children: [
                    Card(
                      margin: const EdgeInsets.only(top: 20, bottom: 400, right: 20, left: 20),
                      color: Colors.black87,
                      child: new FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(1.3521, 103.8198), // Center the map over London
                          initialZoom: 13,
                        ),
                        children: [
                          TileLayer( // Bring your own tiles
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
                            userAgentPackageName: 'com.example.app', // Add your app identifier
                            // And many more recommended properties!
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.black87,
                      margin: const EdgeInsets.only(top: 450, bottom: 20, right: 20, left: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Column(
                          children: [
                            const Gap(5),
                            Text('Recent reported flood', style: TextStyle(color: Colors.white, fontSize: 20)),
                            const Gap(5),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _reports.length < 4 ? _reports.length : 4,
                              itemBuilder: (c, i) {
                                return InkWell(
                                  splashColor: Colors.black87,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(16)),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _reports[_reports.length-i-1]['location'],
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                                Image.memory(base64Decode(_reports[_reports.length-i-1]['photo']),
                                                width: 100,
                                                    height: 50,
                                                  fit: BoxFit.fitWidth,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    await showDialog(context: context,
                                        builder: (_) =>
                                        Dialog(
                                          backgroundColor: Colors.black54,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: 200,
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: MemoryImage(base64Decode(_reports[_reports.length-i-1]['photo'])),
                                                          fit: BoxFit.cover
                                                      )
                                                  ),
                                                ),
                                                const Gap(5),
                                                Text('Description: ' + _reports[_reports.length-i-1]['description'], style: TextStyle(color: Colors.white, fontSize: 16)),
                                                const SizedBox(height: 15),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // child: Container(
                                          //   width: 200,
                                          //   height: 200,
                                          //   decoration: BoxDecoration(
                                          //       image: DecorationImage(
                                          //           image: MemoryImage(base64Decode(_reports[i]['photo'])),
                                          //           fit: BoxFit.cover
                                          //       )
                                          //   ),
                                          // ),
                                      )
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                 ]
                ),
        ),
      );
  }
}
