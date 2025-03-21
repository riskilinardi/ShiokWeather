import 'package:flutter/material.dart';
import 'signuppage.dart';
import 'homepage.dart';
import 'main.dart';
import 'db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final userMap = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      users = userMap.map((um) => User.fromMap(um)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.black87,
        child: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logInText(),
            const SizedBox(height: 30),
            _inputField("Username", usernameController),
            const SizedBox(height: 20),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(height: 30),
            _extraText(),
            const SizedBox(height: 23),
            _loginButton(),
            const SizedBox(height: 20),
            _signUpText(context),
          ],
        ),
      ),
    );
  }

  Widget _logInText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Log In",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _inputField(
    String hintText,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
    );

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _extraText() {
    return Align(
      alignment: Alignment.centerRight,
      child: const Text(
        "Forget Password?",
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextButton(
        onPressed: () async {
          String username = usernameController.text;
          String password = passwordController.text;
          int? id;
          bool isValidUser = false;

          for (final u in users) {
            if (u.username == username && u.password == password) {
              isValidUser = true;
              id = u.id;
            }
          }

          if (isValidUser) {
            // Store the user data in SharedPreferences
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('id', id!);
            await prefs.setString('username', username); // Store the username
            await prefs.setString('email', users.firstWhere((u) => u.id == id).email); // Store the email
            
            // Navigate to MainPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(
                    "Invalid Username or Password",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const Text(
          "Log In",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _signUpText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            TextSpan(
              text: "Sign up",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
