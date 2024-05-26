import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'locationService.dart';
import 'package:geolocator/geolocator.dart';

void addDocument(String msg, double longitud, double latitud) {
  FirebaseFirestore.instance.collection('forum').add({
    'msg': msg,
    'longitud': longitud,
    'latitud': latitud,
  });
}

class MyCollectionPage extends StatefulWidget {
  @override
  _MyCollectionPageState createState() => _MyCollectionPageState();
}

class _MyCollectionPageState extends State<MyCollectionPage> {
  final LocationService locationService = LocationService();
  final double nearbyRadius = 10000; // 10 kilometers
  String selectedDropdownValue = 'Noticias'; // Valor predeterminado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Collection'),
        actions: [
          DropdownButton<String>(
            value: selectedDropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedDropdownValue = newValue!;
              });
            },
            items: <String>['Noticias', 'Reseñas', 'Hacks', 'Social']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('forum').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          return FutureBuilder<Position>(
            future: _runLocationService(),
            builder: (context, positionSnapshot) {
              if (positionSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (positionSnapshot.hasError) {
                return Text(
                    'Error getting user location: ${positionSnapshot.error}');
              }

              Position user = positionSnapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  var longitud = document['longitud'];
                  var latitud = document['latitud'];
                  var dropdownValue = document[
                      'dropdown']; // Obtener el valor del campo dropdown
                  var distance = locationService.calculateDistance(
                      user.latitude, user.longitude, latitud, longitud);
                  if (distance <= nearbyRadius &&
                      dropdownValue == selectedDropdownValue) {
                    var titles = document[
                        'title']; // Replace 'your_field' with the name of your field
                    var data = document['data'];
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '$titles: $data',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Position> _runLocationService() async {
    return await locationService.getCurrentLocation();
  }
}
