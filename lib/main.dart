import 'package:flutter/material.dart';
import 'mappage.dart';
import 'homepage.dart';
import 'table.dart';
import 'loginpage.dart';
import 'db.dart';
import 'profilepage.dart';
import 'reportpage.dart';
import 'friendlistpage.dart';
import 'moodpage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeUsers();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));
}

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

// NAVIGATION BAR CODES
class _MainPage extends State<MainPage> {
  int _page = 2;
  final _pageOpt = [
    ReportPage(),
    MapPage(),
    HomePage(),
    Moodpage(),
    ProfilePage()
    ];
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/icon/icon.png', height: 70,
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.black87
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],

      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
        height: 50.0,
        items: <Widget>[
          Icon(MdiIcons.camera, size: 30, color: Colors.white70),
          Icon(MdiIcons.map, size: 30, color: Colors.white70),
          Icon(MdiIcons.home, size: 30, color: Colors.white70),
          Icon(MdiIcons.bookHeart, size: 30, color: Colors.white70),
          Icon(MdiIcons.account, size: 30, color: Colors.white70),
        ],
        color: Colors.black87,
        buttonBackgroundColor: Colors.black87,
        backgroundColor: Colors.black12,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _pageOpt[_page],
    );
  }
}
