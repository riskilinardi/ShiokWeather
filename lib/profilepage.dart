import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Unknown';
      email = prefs.getString('email') ?? 'Not Provided';
      updatedName = prefs.getString('name') ?? '';
      usernameController.text = username;
      emailController.text = email;
      nameController.text = updatedName;
    });
  }

  _updateName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      updatedName = nameController.text;
    });
    await prefs.setString('name', updatedName);
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
      body: Container(
        color: Colors.black87,
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
              if (updatedName.isNotEmpty)
                Text(
                  updatedName,
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
            fillColor: Colors.black54,
            filled: true,
          ),
        ),
      ],
    );
  }
}
