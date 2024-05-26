import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foraneoapp/testing.dart';
import 'firebase_options.dart';
import 'package:geolocator/geolocator.dart';
import 'locationService.dart';
import 'forum.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Testing(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocationService locationService = LocationService();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String inputValue = '';

  Future<void> handleSubmitted(String value) async {
    Position userLocation = await locationService.getCurrentLocation();
    print(userLocation.longitude);
    print(userLocation.altitude);
    FirebaseFirestore.instance.collection('forum').add({
      'msg': value,
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
      body: Center(),
    );
  }
}
