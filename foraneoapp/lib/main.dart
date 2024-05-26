import 'package:flutter/material.dart';
import 'package:foraneoapp/widgets/wid_footer.dart';
import 'package:foraneoapp/pages/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body:HomePage(),
        bottomNavigationBar: Footer(), // Insert your Footer widget here
      ),
    );
  }
}