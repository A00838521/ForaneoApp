import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../locationService.dart';
import '../forum.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key, required this.title, required this.dropdownValue})
      : super(key: key);

  final String title;
  final String dropdownValue;

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final LocationService locationService = LocationService();
  TextEditingController titleController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  Future<void> handleSubmitted() async {
    Position userLocation = await locationService.getCurrentLocation();
    print(userLocation.longitude);
    print(userLocation.latitude);
    FirebaseFirestore.instance.collection('forum').add({
      'title': titleController.text,
      'data': dataController.text,
      'dropdown': widget.dropdownValue,
      'longitud': userLocation.longitude,
      'latitud': userLocation.latitude,
    });

    // Clear the input values after submission
    titleController.clear();
    dataController.clear();

    // Redirigir a la página anterior
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Limpiar los controladores cuando el widget se elimine
    titleController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dropdown value from MyCollectionPage: ${widget.dropdownValue}',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter title...',
                labelText: 'Title',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[900]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: dataController,
              decoration: InputDecoration(
                hintText: 'Enter data...',
                labelText: 'Data',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[900]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: handleSubmitted,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                // primary: Colors.green[900],
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
