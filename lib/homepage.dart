import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class fourdayslist{
  DateTime? timestamp;
  String? day;
  //Temperature
  int? templow;
  int? temphigh;
  //Relative Humidity
  int? rhlow;
  int? rhhigh;
  //Wind Speed
  int? wslow;
  int? wshigh;
  String? winddirection;
  String? forecast;

  fourdayslist (
      this.timestamp, this.day, this.templow, this.temphigh, this.rhlow, this.rhhigh, this.wslow, this.wshigh, this.winddirection, this.forecast
      );
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Future<List<fourdayslist>> fourdaysforecast() async {
    var url = 'https://api-open.data.gov.sg/v2/real-time/api/four-day-outlook';
    var response = await http.get(Uri.parse(url));
    var map = json.decode(response.body) as Map<String, dynamic>;
    List<fourdayslist> listforecast = [];
    for (var x = 0; x < 4; x++) {
      var list = fourdayslist(
          DateTime.parse(map['data']['records'][0]['forecasts'][x]['timestamp']
              .toString()),
          map['data']['records'][0]['forecasts'][x]['day'].toString(),
          map['data']['records'][0]['forecasts'][x]['temperature']['low'],
          map['data']['records'][0]['forecasts'][x]['temperature']['high'],
          map['data']['records'][0]['forecasts'][x]['relativeHumidity']['low'],
          map['data']['records'][0]['forecasts'][x]['relativeHumidity']['high'],
          map['data']['records'][0]['forecasts'][x]['wind']['low'],
          map['data']['records'][0]['forecasts'][x]['wind']['high'],
          map['data']['records'][0]['forecasts'][x]['direction'].toString(),
          map['data']['records'][0]['forecasts'][x]['forecast']['code']
              .toString()
      );
      listforecast.add(list);
    }
    return listforecast;
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: FutureBuilder(
              future: fourdaysforecast(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData) {
                  var data = snapshot.data;
                  return StaggeredGrid.count(
                    crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                        children: <Widget>[
                          _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(
                                        'Today Highest Temperature',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      Text(
                                        data[0].temphigh.toString() + '\u2103',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(
                                        'Today Lowest Temperature',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      Text(
                                        data[0].templow.toString() + '\u2103',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(
                                        'Today Highest Humidity',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      Text(
                                        data[0].rhhigh.toString() + '%',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(
                                        'Today Lowest Humidity',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      Text(
                                        data[0].rhlow.toString() + '%',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                  );
                } else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Padding(padding: new EdgeInsets.only(top: 200.0)),
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

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
        // Do onTap() if it isn't null, otherwise do print()
        onTap:
        onTap != null
            ? () => onTap()
            : () {
          print('Not set yet');
        },
        child: child,
      ),
    );
  }
}