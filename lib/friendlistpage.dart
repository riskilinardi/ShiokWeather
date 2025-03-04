import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Friendlistpage extends StatefulWidget {
  @override
  State<Friendlistpage> createState() => _FriendlistpageState();
}

class _FriendlistpageState extends State<Friendlistpage> {
  List<String> comments = ["Loading comments..."];

  Future<void> loadJsonAsset() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/mood.json');
      final data = jsonDecode(jsonString);

      //Print JSON structure
      print("JSON Data: $data");

      if (data.containsKey('content') && data['content'] is List && data['content'].length > 1) {
        var commentsSection = data['content'][1];

        if (commentsSection.containsKey('comments') && commentsSection['comments'] is List) {
          List<String> loadedComments = [];

          for (var entry in commentsSection['comments']) {
            if (entry is Map<String, dynamic>) {
              loadedComments.addAll(entry.values.map((e) => e.toString()));
            }
          }

          setState(() {
            comments = loadedComments.isNotEmpty ? loadedComments : ["No comments found"];
          });

          print("Loaded Comments: $comments");
        } else {
          print("Error: 'comments' key is missing or empty.");
        }
      } else {
        print("Error: 'content' key is missing or has insufficient elements.");
      }
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Friend List", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: _displayBox("Friend", comments[index]),
                  );
                },
              ),
            ),
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
            radius: 30,
            backgroundImage: AssetImage('assets/images/background.png'),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Column(
            children: [
              Image.asset(
                'assets/images/sunny.png',
                width: 50,
                height: 50,
              ),
              SizedBox(height: 2),
              Text(
                "2h ago",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
