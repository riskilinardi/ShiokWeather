import 'package:Trackery/Animation/FadeAnimation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'customerasset.dart';
import 'sparinginv.dart';
import 'homepage.dart';

// ignore: must_be_immutable
class GradAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 70.0;

  String title;
  Color gradBegin, gradEnd;
  GradAppBar({this.title, this.gradBegin, this.gradEnd})
      : assert(title != null),
        assert(gradBegin != null),
        assert(gradEnd != null);

  Widget build(BuildContext context) {
    return Container(
      height: _preferredHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[gradBegin, gradEnd])),
      child: Text(title,
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 10.0,
                fontSize: 24.0,
                fontWeight: FontWeight.w600),
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
