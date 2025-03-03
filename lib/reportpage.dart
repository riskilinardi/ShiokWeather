import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shiokweather/homepage.dart';
import 'package:shiokweather/main.dart';
import 'package:shiokweather/mappage.dart';
import 'db.dart';

class ReportPage extends StatefulWidget {
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File? imageFile;
  final imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    getFromCamera();
  }

  getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _photoHeader(),
            const SizedBox(height: 10),
            _imageDisplay(),
            const SizedBox(height: 15),
            _headerWithCounter(),
            const SizedBox(height: 15),
            _inputField("Description...", descriptionController),
            const SizedBox(height: 10),
            _locationHeader(),
            const SizedBox(height: 10),
            _locationInput("Location...", locationController),
            const SizedBox(height: 20),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _photoHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Photo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: _pickImage,
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  Widget _imageDisplay() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey, width: 2),
      ),
      child: imageFile != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                imageFile!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            )
          : Center(
              child: Text(
                "No image selected",
                style: TextStyle(color: Colors.white70),
              ),
            ),
    );
  }

  Widget _headerWithCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Description",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        ValueListenableBuilder(
          valueListenable: descriptionController,
          builder: (context, value, child) {
            return Text("${descriptionController.text.length}/200", style: TextStyle(color: Colors.white70),);
          },
        ),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      "Location",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      style: TextStyle(color: Colors.white70),
      controller: controller,
      maxLength: 200,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
      ),
    );
  }

  Widget _locationInput(String label, TextEditingController controller) {
    return TextField(
      style: TextStyle(color: Colors.white70),
      controller: controller,
      maxLength: 200,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextButton(
        onPressed: () async {
          // Validate inputs
          if (imageFile == null ||
              descriptionController.text.isEmpty ||
              locationController.text.isEmpty) {
            // Fields cannot be empty
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please fill in all fields'),
            ));
            return;
          }

          List<int> bytesimage = imageFile?.readAsBytesSync() as List<int>;
          String base64 = base64Encode(bytesimage);

          FloodReport fr = FloodReport(
            photo: base64,
            description: descriptionController.text,
            location: locationController.text,
          );

          // Insert the user into the database
          int result = await DatabaseHelper.instance.insertFloodReport(fr);

          if (result > 0) {
            // User inserted successfully
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Flood report submitted', style: TextStyle(color: Colors.white),),
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()), // Navigate to login page
            );
          } else {
            // Something went wrong
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Flood report failed!'),
            ));
          }
        },
        child: const Text(
          "Submit",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
    );
  }
}
