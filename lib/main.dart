import 'package:flutter/material.dart';
import 'package:itp/screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarBus',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue
      ),
      home: HomeScreen(),
    );
  }
}


