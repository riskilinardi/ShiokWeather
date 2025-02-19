import 'mappage.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    ));

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

// NAVIGATION BAR CODES
class _MainPage extends State<MainPage> {
  int _page = 1;
  final _pageOpt = [
    MapPage(),
    HomePage(),
    HomePage()
  ];
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Shiok Weather"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.lightBlue, Colors.indigo]),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 1,
          height: 50.0,
          items: <Widget>[
            Icon(MdiIcons.alphaI, size: 30),
            Icon(MdiIcons.home, size: 30),
            Icon(MdiIcons.alphaA, size: 30),
          ],
          color: Colors.indigo,
          buttonBackgroundColor: Colors.indigo[400],
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _pageOpt[_page]);
  }
}