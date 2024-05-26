import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Start'),
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
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isUseractive = false;

 @override
  void initState(){
    super.initState();
   FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
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
    }
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        
        leading:
        Visibility(
          visible: isUseractive,
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
               new GestureDetector(
                  onTap: ()async{
  
                  await FirebaseAuth.instance.signOut();
                  },
                child: Container(
                  
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.symmetric(
                 horizontal: 10.0),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 10.0),
                  ),
                ),
              ),),
            ]),),


      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
               new GestureDetector(
                  onTap: (){
  
                   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                child: Container(
                  
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Center(
                  child: Text(
                    "Login page",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30.0),
                  ),
                ),
              ),),
            ]),
             Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Center(
                  child: Text(
                    "Register page",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30.0),
                  ),
                ),
              ),
            ]),

          ],
        ),
      ),
    );
  }
}
