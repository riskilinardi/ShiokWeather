import 'package:flutter/material.dart';

class Friendlistpage extends StatefulWidget {
  @override
  State<Friendlistpage> createState() => _FriendlistpageState();
}

class _FriendlistpageState extends State<Friendlistpage> {
  String comment = "Lorem ipsum dolor sit amet, consec tetur adipiscing elit. Vivamus lacinia odio vitae vestibulum.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            _displayBox("Name", comment),
            SizedBox(height: 20),
            _displayBox("Name", comment),
            SizedBox(height: 20),
            _displayBox("Name", comment),
            SizedBox(height: 20),
            _displayBox("Name", comment),
            SizedBox(height: 20),
            _displayBox("Name", comment),
            SizedBox(height: 20),
            _displayBox("Name", comment),
            SizedBox(height: 20),
            _displayBox("Name", comment),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _displayBox(String title, String content) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30, // Set the radius for the circle
            backgroundImage: AssetImage('assets/images/background.png'), // Your image on the left
          ),
          SizedBox(width: 15), // Space between the image and the text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5), // Space between title and content
                Text(
                  content,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(width: 15), // Space before the second image
          // Column to display image and text below it
          Column(
            children: [
              Image.asset(
                'assets/images/sunny.png',
                width: 50,  // Set the width of the image
                height: 50, // Set the height of the image
              ),
              SizedBox(height: 2), // Space between the image and the text
              Text(
                "2h ago",  // Time text below the image
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
