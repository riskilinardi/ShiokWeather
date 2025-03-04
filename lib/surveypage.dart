import 'package:flutter/material.dart';
import 'db.dart';

class Surveypage extends StatefulWidget {
  @override
  State<Surveypage> createState() => _SurveypageState();
}

class _SurveypageState extends State<Surveypage> {
  TextEditingController statusController = TextEditingController();
  List<Mood> moodList = [];
  String? selectedImagePath; 

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    List<Map<String, dynamic>> moodMaps =
        await DatabaseHelper.instance.queryAllMood();
    setState(() {
      moodList = moodMaps.map((map) => Mood.fromMap(map)).toList();
    });
  }

  // Function to handle image selection
  void _onImageSelected(String imagePath) {
    setState(() {
      selectedImagePath = imagePath;
    });
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
        title: Text("Survey Page", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
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
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'How are you feeling today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                  labelText: 'Enter your status...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _onImageSelected('assets/images/sunny.png'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/sunny.png',
                          width: 70,
                          height: 70,
                        ),
                        Text('Angry', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => _onImageSelected('assets/images/happy.png'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/happy.png',
                          width: 70,
                          height: 70,
                        ),
                        Text('Happy', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => _onImageSelected('assets/images/sad.png'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/sad.png',
                          width: 70,
                          height: 70,
                        ),
                        Text('Sad', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => _onImageSelected('assets/images/calm.png'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/calm.png',
                          width: 70,
                          height: 70,
                        ),
                        Text('Calm', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  String status = statusController.text;

                  if (status.isNotEmpty && selectedImagePath != null) {
                    Mood mood = Mood(status: status, imagePath: selectedImagePath!);
                    int result = await DatabaseHelper.instance.insertMood(mood);

                    if (result > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mood submitted successfully!')),
                      );
                      statusController.clear();
                      setState(() {
                        selectedImagePath = null;
                      });
                      _loadMoodData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to submit mood.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a status and select an image.')),
                    );
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Previous Moods',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: moodList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      title: Text(moodList[index].status),
                      leading: Image.asset(moodList[index].imagePath, width: 40, height: 40),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
