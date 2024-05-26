import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'locationService.dart';
import 'package:geolocator/geolocator.dart';

import 'pages/testing.dart';

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
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.green[900],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: DropdownButton<String>(
                    value: selectedDropdownValue,
                    dropdownColor: Colors.green[900],
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                ),
                Divider(
                  color: Colors.white,
                  height: 0,
                  thickness: 1,
                  indent: 25,
                  endIndent: 25,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('forum')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.white)));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return FutureBuilder<Position>(
                        future: _runLocationService(),
                        builder: (context, positionSnapshot) {
                          if (positionSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (positionSnapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error getting user location: ${positionSnapshot.error}',
                                    style: TextStyle(color: Colors.white)));
                          }

                          Position user = positionSnapshot.data!;
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                              var longitud = document['longitud'];
                              var latitud = document['latitud'];
                              var dropdownValue = document['dropdown'];
                              var distance = locationService.calculateDistance(
                                  user.latitude,
                                  user.longitude,
                                  latitud,
                                  longitud);
                              if (distance <= nearbyRadius &&
                                  dropdownValue == selectedDropdownValue) {
                                var titles = document[
                                    'title']; // Replace 'title' with the name of your field
                                var data = document[
                                    'data']; // Replace 'data' with the name of your field
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Divider(
                                      color: Colors.white,
                                      height: 0,
                                      thickness: 1,
                                      indent: 25,
                                      endIndent: 25,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              title: titles,
                                              data: data,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(
                                            16), // Ajusta el margen según tus necesidades
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 47, 105,
                                              49), // Cambia el color de fondo
                                          borderRadius: BorderRadius.circular(
                                              25), // Redondea los bordes del contenedor
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              25), // Redondea los bordes del contenedor
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          '$titles',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          '$data',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Column(
                                                            children: <Widget>[
                                                              ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  'https://via.placeholder.com/50',
                                                                  width: 70,
                                                                  height: 70,
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox
                                    .shrink(); // If message is not nearby, return an empty SizedBox
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 47, 105, 49),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Testing(
                          title: 'Añadiendo Datos',
                          dropdownValue: selectedDropdownValue),
                    ),
                  );
                },
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _runLocationService() async {
    return await locationService.getCurrentLocation();
  }
}

class DetailsPage extends StatelessWidget {
  final String title;
  final String data;

  DetailsPage({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
