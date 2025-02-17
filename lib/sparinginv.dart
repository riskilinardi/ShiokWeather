import 'package:Trackery/Animation/FadeAnimation.dart';
import 'package:Trackery/chooseMno.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'chooseSi.dart';

class SparingInv extends StatefulWidget {
  @override
  _SparingInv createState() => _SparingInv();
}

class _SparingInv extends State<SparingInv> {
  final TextEditingController _data = TextEditingController();
  String datasearch;

  searchSi(typesearch, input) async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ChooseSi(
                  data: input,
                  type: typesearch,
                )));
  }

  searchMno(typesearch, input) async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ChooseMno(
                  data: input,
                  type: typesearch,
                )));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100.0, right: 30.0, left: 30.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Search Sparing Inventory",
                        style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontFamily: "Roboto",
                                fontSize: 26)),
                      ),
                      Text(
                        "",
                        style: TextStyle(fontSize: 40),
                      ),
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Spares Inventory Search Bar",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      controller: _data,
                                      onChanged: (value) {
                                        datasearch = value;
                                      }),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          try {
                            searchSi("sno", datasearch);
                          } catch (e) {
                            print(e);
                          }
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF3F51B5),
                                Color(0xFF5C6BC0),
                                Color(0xFF7986CB),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('Search By Serial No',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Text(
                        "",
                        style: TextStyle(fontSize: 5),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          try {
                            searchMno("mno", datasearch);
                          } catch (e) {
                            print(e);
                          }
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF3F51B5),
                                Color(0xFF5C6BC0),
                                Color(0xFF7986CB),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('Search By Model No',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
