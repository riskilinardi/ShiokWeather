import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'db.dart';

class Friendlistpage extends StatefulWidget {
  @override
  State<Friendlistpage> createState() => _FriendlistpageState();
}

class _FriendlistpageState extends State<Friendlistpage> {
  List<String> comments = ["Loading comments..."];
  TextEditingController inputController = TextEditingController();

  Future<void> loadJsonAsset() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/mood.json');
      final data = jsonDecode(jsonString);

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
        }
      }
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  List<Map<String, dynamic>> _friendlist = [];

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
    _loadFriends();
  }

  _loadFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    List<Map<String, dynamic>> friendlist = await DatabaseHelper.instance.queryFriendlist(id);
    setState(() {
      _friendlist = friendlist;
    });
  }

  _addFriend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    String userId = inputController.text.trim();

    if (userId.isNotEmpty) {
      try {
        int parsedUserId = int.parse(userId);

        List<Map<String, dynamic>> userList = await DatabaseHelper.instance.queryOneUser(parsedUserId);

        if (userList.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User does not exist!'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Friendlist friend = Friendlist(uid1: id!, uid2: parsedUserId, timestamp: DateTime.now().toString());

        int result = await DatabaseHelper.instance.insertFriend(friend);

        if (result == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You are already friends with this user!'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        _loadFriends();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        inputController.clear();
      } catch (e) {
        print("Error adding friend: $e");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding friend!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid user ID!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: Colors.black87,
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter user id...',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black54,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: _addFriend,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _friendlist.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: _displayBox(_friendlist[index]['displayname'], _friendlist[index]['status'], _friendlist[index]['mood']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayBox(String title, String content, String mood) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
        border: Border.all(color: Colors.blueGrey, width: 2),
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
                'assets/images/' + mood,
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
