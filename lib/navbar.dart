import 'package:Trackery/Animation/FadeAnimation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'customerasset.dart';
import 'gradappbar.dart';
import 'sparinginv.dart';
import 'homepage.dart';
import 'package:mdi/mdi.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  int _page = 1;
  final _pageOpt = [
    SparingInv(),
    HomePage(),
    CustomerAsset(),
  ];
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradAppBar(
          title: "Trackery",
          gradBegin: Colors.indigo[500],
          gradEnd: Colors.indigo[200],
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
          color: Colors.indigo[400],
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

//V1
