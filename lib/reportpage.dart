import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: _page(),
        ),
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
            const SizedBox(height: 10),
            _headerWithCounter(),
            const SizedBox(height: 10),
            _inputField("Description...", descriptionController),
            const SizedBox(height: 20),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: _pickImage,
          color: Colors.blue,
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
        border: Border.all(color: Colors.blue, width: 2),
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
                style: TextStyle(color: Colors.grey),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ValueListenableBuilder(
          valueListenable: descriptionController,
          builder: (context, value, child) {
            return Text("${descriptionController.text.length}/200");
          },
        ),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      "Location",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLength: 200,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _locationInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLength: 200,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          "Submit",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
