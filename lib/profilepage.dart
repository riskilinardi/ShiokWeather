import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String displayName = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    
    // Assuming the first user in the table is the logged-in user
    List<Map<String, dynamic>> users = await dbHelper.queryAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        // Use the first user from the table to display the data
        var user = users[0]; 
        displayName = user['username'];  // Display the username (or name) of the user
        emailController.text = user['email'];
        usernameController.text = user['username'];
      });
    }
  }

  _saveName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', newName); // Save the updated name to SharedPreferences
  }

  _saveEmail(String newEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', newEmail); // Save the updated email to SharedPreferences
  }

  _saveUsername(String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', newUsername); // Save the updated username to SharedPreferences
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear SharedPreferences on logout
    Navigator.of(context).pushReplacementNamed('/login');  // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 1),
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/images/background.png"), // You can change this to a dynamic image if needed
            ),
            SizedBox(height: 20),
            Text(
              displayName.isEmpty ? "No Name" : displayName,  // Display the fetched name or "No Name"
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
              leading: Icon(Icons.lock, color: Colors.blueGrey),
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
                _saveName(displayName);  // Save the updated name
                _saveEmail(emailController.text);  // Save the updated email
                _saveUsername(usernameController.text);  // Save the updated username
              },
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
              onPressed: _logout,  // Call logout method
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
      borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
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
