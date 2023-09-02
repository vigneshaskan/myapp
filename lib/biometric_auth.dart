import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/screens/dashboard.dart';

class BiometricAuth {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> authenticate(BuildContext context, String emailOrUsername, String password) async {
    bool isAuthenticated = false;

    try {
      List<BiometricType> availableBiometrics = await _localAuthentication.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: 'Authenticate with your fingerprint',
          biometricOnly: true,
        );
      }
    } catch (e) {
      print('Authentication failed: $e');
    }

    if (isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            emailOrUsername: emailOrUsername,
            password: password,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Authentication Failed'),
            content: Text('Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
