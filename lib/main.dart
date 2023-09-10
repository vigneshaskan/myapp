// main.dart
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myapp/screens/main_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcmToken : $fcmToken');
  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(MyApp());
  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
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
        child: FeatureListScreen(), // Your initial screen
      ),
      initialRoute: AppRoutes.mainScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

