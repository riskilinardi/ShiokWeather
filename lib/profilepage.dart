import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiokweather/loginpage.dart';

import 'db.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String updatedName = '';
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  List<Map<String, dynamic>> _personaldata = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    List<Map<String, dynamic>> personaldata = await DatabaseHelper.instance.queryOneUser(id);
    setState(() {
      _personaldata = personaldata;
      nameController.text = _personaldata[0]['displayname'];
      usernameController.text = _personaldata[0]['username'];
      emailController.text = _personaldata[0]['email'];
    });
  }

  _updateName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    int output = await DatabaseHelper.instance.updateOneUser(nameController.text, emailController.text, usernameController.text, id);

    if (output > 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully!', style: TextStyle(color: Colors.white),),
      ));
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => MainPage()),
      // );
    } else {
      // Something went wrong
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile update failed!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black26,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("assets/images/background.png"),
              ),
              SizedBox(height: 20),
              if (_personaldata.isNotEmpty)
                Text(
                  _personaldata[0]['displayname'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              SizedBox(height: 20),
              _inputField("Name", nameController),
              SizedBox(height: 20),
              _inputField("Email", emailController),
              SizedBox(height: 20),
              _inputField("Username", usernameController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: Size(double.infinity, 60),
                ),
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: Size(double.infinity, 60),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String displayName, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: border,
            focusedBorder: border,
            fillColor: Colors.black12,
            filled: true,
          ),
        ),
      ],
    );
  }
}
