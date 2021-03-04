import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/auth_services.dart';
import 'package:firebase_flutter/home.dart';
import 'package:flutter/material.dart';

import 'auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth',
        home: FirebaseAuth.instance.currentUser != null ? Home() : AuthWrapper());
  }
}
