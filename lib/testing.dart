import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:geolocator/geolocator.dart';
import 'locationService.dart';
import 'forum.dart';

class Testing extends StatefulWidget {
  const Testing({super.key, required this.title});

  final String title;
  @override
  State<Testing> createState() => testing();
}

class testing extends State<Testing> {
  final LocationService locationService = LocationService();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String inputValue = '';

  Future<void> handleSubmitted(String value) async {
    Position userLocation = await locationService.getCurrentLocation();
    print(userLocation.longitude);
    print(userLocation.altitude);
    var something = 'algo aqui';
    FirebaseFirestore.instance.collection('forum').add({
      'title': value,
      'data': something,
      'longitud': userLocation.longitude,
      'latitud': userLocation.latitude,
    });
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
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
                onSubmitted: handleSubmitted,
                decoration: InputDecoration(
                  hintText: 'Enter your text...',
                  labelText: 'Text Input',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Input value: $inputValue',
                style: TextStyle(fontSize: 18.0),
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
