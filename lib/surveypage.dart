import 'package:flutter/material.dart';
import 'db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Surveypage extends StatefulWidget {
  @override
  State<Surveypage> createState() => _SurveypageState();
}

class _SurveypageState extends State<Surveypage> {
  TextEditingController statusController = TextEditingController();
  List<Mood> moodList = [];
  String? selectedImageName;

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  // Load mood data
  Future<void> _loadMoodData() async {
    List<Map<String, dynamic>> moodMaps =
        await DatabaseHelper.instance.queryAllMood();
    setState(() {
      moodList = moodMaps.map((map) => Mood.fromMap(map)).toList();
    });
  }

  // Function to handle image selection
  void _onImageSelected(String imageName) {
    setState(() {
      selectedImageName = imageName;
    });
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
        title: Text("Survey Page", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(40.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Do you know that 70% of Shiok Weather users feel moody when it\'s raining?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'How are you feeling today?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: statusController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter your status...',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _onImageSelected('angry.png'),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/angry.png',
                                width: 70,
                                height: 70,
                              ),
                              Text(
                                'Angry',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => _onImageSelected('happy.png'),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/happy.png',
                                width: 70,
                                height: 70,
                              ),
                              Text(
                                'Happy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => _onImageSelected('sad.png'),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/sad.png',
                                width: 70,
                                height: 70,
                              ),
                              Text(
                                'Sad',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => _onImageSelected('calm.png'),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/calm.png',
                                width: 70,
                                height: 70,
                              ),
                              Text(
                                'Calm',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        String status = statusController.text;

                        if (status.isNotEmpty && selectedImageName != null) {
                          int? uid = await SharedPreferences.getInstance()
                              .then((prefs) => prefs.getInt('id'));

                          if (uid != null) {
                            int result = await DatabaseHelper.instance
                                .updateUserMoodAndStatusById(
                              uid,
                              status,
                              selectedImageName!,
                            );

                            if (result > 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Mood updated successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              statusController.clear();
                              setState(() {
                                selectedImageName = null;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update mood.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'User not logged in. Please log in first.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a status and select an image.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
