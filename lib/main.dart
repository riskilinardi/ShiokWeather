// import 'package:Trackery/Animation/FadeAnimation.dart';
// import 'package:Trackery/homepage.dart';
// import 'package:Trackery/navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'navbar.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     ));
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   var name = prefs.getString('Name');
// //   print(name);
// //   runApp(MaterialApp(home: name == null ? LoginPage() : HomePage()));
// // }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPage createState() => _LoginPage();
// }

// class _LoginPage extends State<LoginPage> {
//   final TextEditingController _username = TextEditingController();
//   final TextEditingController _password = TextEditingController();

//   signIn(username, password) async {
//     var url = 'https://napecinventory.azurewebsites.net/Api/LoginApi/' +
//         username +
//         '/' +
//         password;
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (BuildContext context) => NavBar()),
//           (route) => false);
//       print("Success");
//     } else {
//       print("Failed Login");
//       AlertDialog alert = AlertDialog(
//         title: Text("Error"),
//         content: Text("Wrong Username or Password!"),
//       );

//       // show the dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return alert;
//         },
//       );
//     }
//   }

//   String uid;
//   String pw;

//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   height: 400,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/background.png'),
//                           fit: BoxFit.fill)),
//                   child: Stack(
//                     children: <Widget>[
//                       Positioned(
//                         left: 30,
//                         width: 80,
//                         height: 200,
//                         child: FadeAnimation(
//                             1,
//                             Container(
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(
//                                           'assets/images/light-1.png'))),
//                             )),
//                       ),
//                       Positioned(
//                         left: 140,
//                         width: 80,
//                         height: 150,
//                         child: FadeAnimation(
//                             1.3,
//                             Container(
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(
//                                           'assets/images/light-2.png'))),
//                             )),
//                       ),
//                       Positioned(
//                         right: 40,
//                         top: 40,
//                         width: 80,
//                         height: 150,
//                         child: FadeAnimation(
//                             1.5,
//                             Container(
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(
//                                           'assets/images/clock.png'))),
//                             )),
//                       ),
//                       Positioned(
//                         child: FadeAnimation(
//                           1.6,
//                           Container(
//                             margin: EdgeInsets.only(top: 140),
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage(
//                                         'assets/images/TrackeryMobile.png'))),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(30.0),
//                   child: Column(
//                     children: <Widget>[
//                       FadeAnimation(
//                           1.8,
//                           Container(
//                             padding: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Color.fromRGBO(143, 148, 251, .2),
//                                       blurRadius: 20.0,
//                                       offset: Offset(0, 10))
//                                 ]),
//                             child: Column(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   decoration: BoxDecoration(
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color: Colors.grey.shade100))),
//                                   child: TextField(
//                                       decoration: InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: "Username",
//                                           hintStyle: TextStyle(
//                                               color: Colors.grey[400])),
//                                       controller: _username,
//                                       onChanged: (value) {
//                                         uid = value;
//                                       }),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: TextField(
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "Password",
//                                       ),
//                                       obscureText: true,
//                                       controller: _password,
//                                       onChanged: (value) {
//                                         pw = value;
//                                       }),
//                                 )
//                               ],
//                             ),
//                           )),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                         height: 40.0,
//                         width: 250.0,
//                         margin: EdgeInsets.all(10),
//                         child: ElevatedButton(
//                           child: Text('Login'),
//                           style: ElevatedButton.styleFrom(
//                               primary: Colors.indigo.shade500,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 50, vertical: 0),
//                               textStyle: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold)),
//                           onPressed: () async {
//                             try {
//                               signIn(uid, pw);
//                             } catch (e) {
//                               print(e);
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
