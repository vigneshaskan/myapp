// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';
import 'package:myapp/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My New App',
      theme: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.black,
        textTheme: const TextTheme(
          headline6: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: LoginScreen(), // Your initial screen
      ),
      initialRoute: AppRoutes.mainScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

