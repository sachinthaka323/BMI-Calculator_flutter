import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/firebase_options.dart';
import 'package:flutter_application_6/login.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About You',
      theme: ThemeData(
        primarySwatch:Colors.deepOrange,
        scaffoldBackgroundColor:Color.fromARGB(255, 209, 209, 209),
        
        
      ),
      home: FormScreen(),
      
    );
  }
}

