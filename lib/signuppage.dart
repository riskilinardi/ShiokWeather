import 'package:flutter/material.dart';
import 'loginpage.dart'; // Import the LoginPage
import 'db.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _page(),
            Positioned(
              top: 80,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
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
            _signUpText(),
            const SizedBox(height: 30),
            _inputField("Username", usernameController),
            const SizedBox(height: 20),
            _inputField(
              "Email",
              emailController,
            ),
            const SizedBox(height: 20),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(height: 20),
            _inputField(
              "Confirm Password",
              confirmPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            _signUpButton(),
            const SizedBox(height: 20),
            _logInText(context),
          ],
        ),
      ),
    );
  }

  Widget _signUpText() {
    return Align(
      alignment: Alignment.centerLeft, 
      child: Text(
        "Sign Up",
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
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.blue),
    ); 

    return TextField(
      style: const TextStyle(color: Colors.white), 
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ), 
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  // Sign Up button
  Widget _signUpButton() {
    return Container(
      width:
          double
              .infinity, 
      height: 50, 
      decoration: BoxDecoration(
        color: Colors.blue, 
        borderRadius: BorderRadius.circular(
          18,
        ), 
      ),
      child: TextButton(
        onPressed: () async {
          // Validate inputs
          if (passwordController.text != confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Passwords do not match'),
            ));
            return;
          }

          if (usernameController.text.isEmpty ||
              emailController.text.isEmpty ||
              passwordController.text.isEmpty) {
            // Fields cannot be empty
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please fill in all fields'),
            ));
            return;
          }

          User newUser = User(
            username: usernameController.text,
            email: emailController.text,
            password: passwordController.text,
          );

          // Insert the user into the database
          int result = await DatabaseHelper.instance.insertUser(newUser);

          if (result > 0) {
            // User inserted successfully
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Sign Up Successful'),
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login page
            );
          } else {
            // Something went wrong
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Sign Up Failed'),
            ));
          }
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Log In prompt with clickable link
  Widget _logInText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already have an account? ",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            TextSpan(
              text: "Log in",
              style: TextStyle(
                fontSize: 16,
                color:
                    Colors
                        .blue, 
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
