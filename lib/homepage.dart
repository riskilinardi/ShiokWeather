import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

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

class threehourlylist{
  DateTime? timestamp;
  int? currtemp;
  String? icon;

  threehourlylist (
      this.timestamp, this.currtemp, this.icon
      );
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final itemScrollController = ItemScrollController();
  List<fourdayslist> listforecast = [];
  List<threehourlylist> listhourlyforecast = [];
  Future<void> fourdaysforecast() async {
    var url = 'https://api-open.data.gov.sg/v2/real-time/api/four-day-outlook';
    var response = await http.get(Uri.parse(url));
    var map = json.decode(response.body) as Map<String, dynamic>;
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
  }

  Future<void> threehourlyforecast() async {
    var url = 'https://api.openweathermap.org/data/2.5/forecast?q=Singapore&appid=8b4deb04fad850eba9224dfb3ccfc328';
    var response = await http.get(Uri.parse(url));
    var map = json.decode(response.body) as Map<String, dynamic>;
    for (var x = 0; x < 8; x++) {
      var list = threehourlylist(
          DateTime.parse(map['list'][x]['dt_txt'].toString()).add(const Duration(hours: 8)),
          (map['list'][x]['main']['temp'] - 273.15).toInt(),
          map['list'][x]['weather'][0]['icon'].toString()
      );
      listhourlyforecast.add(list);
    }
  }

  Future<void> callapi() async{
    await fourdaysforecast();
    await threehourlyforecast();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: FutureBuilder(
              future: callapi(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(listforecast.isNotEmpty && listhourlyforecast.isNotEmpty) {
                  var data = listforecast;
                  var data2 = listhourlyforecast;
                    return ListView(
                      children: [
                        Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: SizedBox(
                              height: 160,
                              child: ScrollablePositionedList.separated(
                                key: const PageStorageKey(0),
                                separatorBuilder: (BuildContext context, int index) {
                                  return const VerticalDivider(
                                    width: 10,
                                    indent: 40,
                                    endIndent: 40,
                                  );
                                },
                                itemCount: 8,
                                scrollDirection: Axis.horizontal,
                                itemScrollController: ItemScrollController(),
                                itemBuilder: (context, i) {
                                  final i8 = (i / 8).floor();

                                  return GestureDetector(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                         child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                                Text(
                                                  DateFormat('HH').format(DateTime.parse(data2[i].timestamp.toString())) + ':00',
                                                ),
                                            Text(
                                              DateFormat('EEEE').format(DateTime.parse(data2[i].timestamp.toString())),
                                            ),
                                            Image.network('https://openweathermap.org/img/wn/'+ data2[i].icon.toString() +'@2x.png',
                                              scale: 1.5,
                                            ),
                                            Text(data2[i].currtemp.toString() + '\u2103',
                                            ),
                                          ],
                                        )
                                    ),
                                  );
                                },
                              ),
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