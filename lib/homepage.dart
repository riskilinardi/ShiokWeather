import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int? uid;

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
          map['data']['records'][0]['forecasts'][x]['forecast'].toString()
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

Future<void> callapi() async {
  listhourlyforecast = [];
  listforecast = [];
  await fourdaysforecast();
  await threehourlyforecast();
  
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  uid = prefs.getInt('id');
}


 @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.black87,
          child: FutureBuilder(
              future: callapi(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(listforecast.isNotEmpty && listhourlyforecast.isNotEmpty) {
                  var data = listforecast;
                  var data2 = listhourlyforecast;
                  List<String> imagedisplay = [];
                  String sunny = 'Fair';
                  List<String> rainy = ['Rain', 'Showers'];
                  String thunderstorm = 'Thundery';
                  List<String> cloudy = ['Cloudy', 'Hazy', 'Windy', 'Mist', 'Fog', ];
                  imagedisplay.add('Rainy');
                  for(final x in listforecast){
                    String? check = x.forecast;
                    if(check!.contains(sunny)){
                      imagedisplay.add('Sunny');
                    }
                    else if(check!.contains(thunderstorm)){
                      imagedisplay.add('Thunders');
                    }
                    else if(rainy.contains(check)){
                      imagedisplay.add('Rainy');
                    }
                    else if(cloudy.contains(check)){
                      imagedisplay.add('Cloudy');
                    }
                  }
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Gap(10),
                              Text(
                                'Singapore User ID: ' + uid.toString(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                              ),
                              Image(
                                image: AssetImage('assets/images/' + imagedisplay[0].toLowerCase() + '.png'),
                                fit: BoxFit.fill,
                                height: 200,
                              ),
                              Text(
                                data2[0].currtemp.toString() + '\u2103',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Colors.white,
                                    fontSize: 90,
                                    fontWeight: FontWeight.w700,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 15,
                                        offset: Offset(5, 5),
                                      )
                                    ]),
                              ),
                              Text(
                                imagedisplay[0],
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                              ),
                              const Gap(5),
                              Text(
                                DateFormat('MMMMEEEEd').format(DateTime.parse(data2[0].timestamp.toString())),
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
                          color: Colors.black87,
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
                                    color: Colors.white
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
                                        color: Colors.black38,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                         child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                                Text(
                                                  DateFormat('HH').format(DateTime.parse(data2[i].timestamp.toString())) + ':00',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                            Text(
                                              DateFormat('EEEE').format(DateTime.parse(data2[i].timestamp.toString())),
                                                style: TextStyle(color: Colors.white)
                                            ),
                                            Image.network('https://openweathermap.org/img/wn/'+ data2[i].icon.toString() +'@2x.png',
                                              scale: 1.5,
                                            ),
                                            Text(data2[i].currtemp.toString() + '\u2103',
                                                style: TextStyle(color: Colors.white)
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
                        Card(
                          color: Colors.black87,
                          margin: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder: (c, i) {
                                    String code = '';
                                    if(imagedisplay[i] == 'Rainy' ){
                                      code = '09d@2x.png';
                                    } else if (imagedisplay[i] == 'Sunny'){
                                      code = '01d@2x.png';
                                    } else if (imagedisplay[i] == 'Thunders'){
                                      code = '11d@2x.png';
                                    } else if (imagedisplay[i] == 'Cloudy'){
                                      code = '04d@2x.png';
                                    }
                                    return InkWell(
                                      splashColor: Colors.black87,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16)),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                DateFormat('EEEE').format(DateTime.parse(data[i].timestamp.toString())),
                                                style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Image.network('https://openweathermap.org/img/wn/'+ code,
                                                    scale: 1.5,
                                                  ),
                                                  const Gap(5),
                                                  Expanded(
                                                    child: Text(imagedisplay[i],
                                                      style: TextStyle(color: Colors.white),
                                                      maxLines: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(data[i].templow.toString() + '\u2103',
                                                    style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                      color: Colors.white30,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' / ',
                                                    style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(data[i].temphigh.toString() + '\u2103',
                                                    style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const Divider(),
                                InkWell(
                                  splashColor: Colors.black87,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      '4 days forecast',
                                      style: TextStyle(color: Colors.white70, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.black87,
                          margin: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder: (c, i) {
                                    return InkWell(
                                      splashColor: Colors.black87,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16)),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                DateFormat('EEEE').format(DateTime.parse(data[i].timestamp.toString())),
                                                style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  // Image.network('https://openweathermap.org/img/wn/',
                                                  //   scale: 1.5,
                                                  // ),
                                                  const Gap(5),
                                                  Expanded(
                                                    child: Text(imagedisplay[i],
                                                      style: TextStyle(color: Colors.white),
                                                      maxLines: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(data[i].templow.toString() + '\u2103',
                                                    style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                      color: Colors.white30,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' / ',
                                                    style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(data[i].temphigh.toString() + '\u2103',
                                                    style: Theme.of(c).textTheme.labelLarge?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
}