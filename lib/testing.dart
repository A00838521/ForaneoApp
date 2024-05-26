import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'locationService.dart';
import 'forum.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key, required this.title}) : super(key: key);

  final String title;

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
      'longitud': userLocation.longitude,
      'latitud': userLocation.latitude,
    });

    // Clear the input values after submission
    titleController.clear();
    dataController.clear();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    titleController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Text Input'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter title...',
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: dataController,
                decoration: InputDecoration(
                  hintText: 'Enter data...',
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: handleSubmitted,
                child: Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCollectionPage()),
                  );
                },
                child: Text('Show Collection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
