// import 'package:Trackery/Animation/FadeAnimation.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'customerasset.dart';
// import 'sparinginv.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePage createState() => _HomePage();
// }

// class _HomePage extends State<HomePage> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       color: Colors.white,
//       child: Center(
//         child: Column(
//           children: <Widget>[Text("Welcome to Trackery Mobile")],
//         ),
//       ),
//     ));
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animatedloading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<List<double>> charts = [
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ]
  ];

  static final List<String> chartDropdownItems = [
    'Last 7 days',
    'Last month',
    'Last year'
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  Future<List<String>> searchbysno() async {
    List<String> calist = [];
    var url = 'https://napecinventory.azurewebsites.net/Api/HomepageData/';
    var response = await http.get(url);
    var strlist = json.decode(response.body);
    for (var x in strlist) {
      calist.add(x);
    }
    return calist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: FutureBuilder(
                future: searchbysno(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    return StaggeredGridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      children: <Widget>[
                        _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Material(
                                        color: Colors.teal,
                                        shape: CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Icon(
                                              Icons.settings_applications,
                                              color: Colors.white,
                                              size: 30.0),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text('To Trackery Web',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24.0)),
                                    Text('Click to redirect',
                                        style:
                                            TextStyle(color: Colors.black45)),
                                  ]),
                            ),
                            onTap: () => launch(
                                'https://napecinventory.azurewebsites.net/')),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Total Sparing Inventory',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10.0)),
                                      Text(data[0],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0))
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Total Customer Assets',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10.0)),
                                      Text(data[1],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0))
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Pending Loan Request',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10.0)),
                                      Text(data[2],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0))
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Active Customer Assets',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10.0)),
                                      Text(data[4],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0))
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Expired Customer Assets',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10.0)),
                                      Text(data[3],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0))
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Expiring Customer Assets',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10.0)),
                                      Text(data[5],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0))
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        // _buildTile(
                        //   Padding(
                        //     padding: const EdgeInsets.all(24.0),
                        //     child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: <Widget>[
                        //           Material(
                        //               color: Colors.amber,
                        //               shape: CircleBorder(),
                        //               child: Padding(
                        //                 padding: EdgeInsets.all(16.0),
                        //                 child: Icon(Icons.notifications,
                        //                     color: Colors.white, size: 30.0),
                        //               )),
                        //           Padding(padding: EdgeInsets.only(bottom: 16.0)),
                        //           Text('Alerts',
                        //               style: TextStyle(
                        //                   color: Colors.black,
                        //                   fontWeight: FontWeight.w700,
                        //                   fontSize: 24.0)),
                        //           Text('All ', style: TextStyle(color: Colors.black45)),
                        //         ]),
                        //   ),
                        // ),
                        _buildTile(
                          Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Chart Example',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                          Text('Eg',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 34.0)),
                                        ],
                                      ),
                                      DropdownButton(
                                          isDense: true,
                                          value: actualDropdown,
                                          onChanged: (String value) =>
                                              setState(() {
                                                actualDropdown = value;
                                                actualChart =
                                                    chartDropdownItems.indexOf(
                                                        value); // Refresh the chart
                                              }),
                                          items: chartDropdownItems
                                              .map((String title) {
                                            return DropdownMenuItem(
                                              value: title,
                                              child: Text(title,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.0)),
                                            );
                                          }).toList())
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 4.0)),
                                  Sparkline(
                                    data: charts[actualChart],
                                    lineWidth: 5.0,
                                    lineColor: Colors.greenAccent,
                                  )
                                ],
                              )),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Example Card',
                                          style: TextStyle(
                                              color: Colors.redAccent)),
                                      Text('1111',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0))
                                    ],
                                  ),
                                  Material(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(Icons.store,
                                            color: Colors.white, size: 30.0),
                                      )))
                                ]),
                          ),
                        )
                      ],
                      staggeredTiles: [
                        StaggeredTile.extent(2, 180.0),
                        StaggeredTile.extent(1, 160.0),
                        StaggeredTile.extent(1, 160.0),
                        StaggeredTile.extent(1, 160.0),
                        StaggeredTile.extent(1, 160.0),
                        StaggeredTile.extent(1, 160.0),
                        StaggeredTile.extent(1, 160.0),
                        StaggeredTile.extent(2, 220.0),
                        StaggeredTile.extent(2, 110.0),
                      ],
                    );
                  } else {
                    return Container(
                        child: Column(
                      children: <Widget>[
                        Padding(padding: new EdgeInsets.only(top: 200.0)),
                        Center(child: AnimatedAppBar()),
                        Center(child: Text("Trackery is loading..."))
                      ],
                    ));
                  }
                })));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
