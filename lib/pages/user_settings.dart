import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foraneoapp/main.dart';
import 'package:foraneoapp/pages/login.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('User Settings'),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            size: 25.0,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(
                  title: 'Main page',
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text('User Settings'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _signOut();
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle logout
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login page or any other page as needed
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
      // Handle error if needed
    }
  }
}
