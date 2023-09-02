import 'package:flutter/material.dart';
import 'package:myapp/screens/dashboard.dart';
import 'package:myapp/screens/login.dart';
import 'package:myapp/screens/main_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String dashboard = '/dashboard';
  static const String mainScreen = '/main_screen';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case mainScreen:
        return MaterialPageRoute(builder: (_) => FeatureListScreen());
      case dashboard:
      // Extract the arguments
        final args = settings.arguments as Map<String, dynamic>;
        final String emailOrUsername = args['emailOrUsername'];
        final String password = args['password'];
        return MaterialPageRoute(builder: (_) => DashboardScreen(emailOrUsername: emailOrUsername, password: password));
      default:
        return null;
    }
  }
}
