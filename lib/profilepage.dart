import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController(text: "tester@example.com");
  TextEditingController usernameController = TextEditingController(text: "tester123");

  String displayName = "Tester";

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('name') ?? "Tester";
      nameController.text = displayName;
    });
  }

  _saveName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', newName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 1),
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/images/background.png"),
            ),
            SizedBox(height: 20),
            Text(
              displayName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _inputField("Name", nameController),
            SizedBox(height: 20),
            _inputField("Email", emailController),
            SizedBox(height: 20),
            _inputField("Username", usernameController),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.blue),
              title: Text("Change Password"),
              onTap: () {},
            ),
            Divider(),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  displayName = nameController.text;
                });
                _saveName(displayName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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
              onPressed: () {},
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
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextField(
          style: const TextStyle(color: Colors.black),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black54),
            enabledBorder: border,
            focusedBorder: border,
          ),
          obscureText: isPassword,
        ),
      ],
    );
  }
}
