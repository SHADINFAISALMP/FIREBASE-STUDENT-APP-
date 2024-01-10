// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_10/screen/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDCB7um9UvjLUaX1Twt6z0a2uBKdrMqdZE",
            authDomain: "student-record-6df32.firebaseapp.com",
            projectId: "student-record-6df32",
            storageBucket: "student-record-6df32.appspot.com",
            messagingSenderId: "218158296819",
            appId: "1:218158296819:web:952d46270b72d144089186",
            measurementId: "G-1W5RBX6EL6"));
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      title: "Student List",
      home: HomeScreeen(),
    );
  }
}
