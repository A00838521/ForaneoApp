import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foraneoapp/pages/testing.dart';
import 'firebase_options.dart';
import 'package:geolocator/geolocator.dart';
import 'locationService.dart';
import 'forum.dart';
import 'package:foraneoapp/footer.dart';
import 'pages/login.dart';
import 'package:foraneoapp/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: const MyHomePage(title: 'title'),
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
  bool isUseractive = false;
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
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          isUseractive = false;
        });
        print("User not active");
      } else {
        setState(() {
          isUseractive = true;
        });
        print("User active!");
        // dont show login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: Visibility(
          visible: isUseractive,
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 10.0),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Center(
                    child: Text(
                      "Login page",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 30.0),
                    ),
                  ),
                ),
              ),
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Center(
                    child: Text(
                      "Register page",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 30.0),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
