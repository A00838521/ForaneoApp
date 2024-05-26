import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foraneoapp/login.dart';
import 'package:foraneoapp/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
  }

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
                _pickImage();
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text('Upload Image'),
            ),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      return;
    }

    try {
      // Upload image to Firebase Storage
      Reference storageReference = _storage.ref().child(
          'profile_pictures/${_auth.currentUser!.uid}/${Path.basename(_imageFile!.path)}');
      await storageReference.putFile(_imageFile!);

      // Get download URL
      String downloadURL = await storageReference.getDownloadURL();

      // Query Firestore collection for the document with the user's UID
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .where('id', isEqualTo: _auth.currentUser!.uid)
          .get();

      // Check if the document exists
      if (snapshot.docs.isNotEmpty) {
        // Update user profile picture URL in Firestore
        await snapshot.docs.first.reference.update({
          'profilePicture': downloadURL,
        });

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully'),
          ),
        );
      } else {
        // Document with user's UID not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User document not found'),
          ),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image'),
        ),
      );
    }
  }

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
