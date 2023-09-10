import 'package:flutter/material.dart';
import 'package:myapp/screens/camera_screen.dart';
import 'package:myapp/screens/image_processing.dart';
import 'package:myapp/screens/location.dart';
import 'package:myapp/screens/login.dart';
import 'package:myapp/screens/push_notification.dart';
import 'package:myapp/screens/registration.dart';
import 'package:myapp/screens/social_login_screen.dart';

class FeatureListScreen extends StatelessWidget {
  final Map<String, Widget> _featureScreens = {
    'Login': LoginScreen(),
    'User Authentication': RegistrationScreen(),
    'Push Notifications' : PushNotificationScreen(),
    'Geolocation' : LocationPage(),
    'Camera Integration': CameraPage(),
    'Image Processing': ImageProcessingScreen(),
    'Social Media login': SocialLoginScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text('Feature List', style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final featureDescription = _featureDescriptions[index];
            return GestureDetector(
              onTap: (){
                final selectedScreen = _featureScreens[featureDescription];
                if (selectedScreen != null) {
                  // Use Navigator to navigate to the selected screen
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => selectedScreen,
                  ));
                }
              },
              child: ListTile(
                title: Text(
                  _featureDescriptions[index],
                  style: TextStyle(color: Colors.white),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                tileColor: Colors.black,
                // Add a bottom line for each list item
                shape: Border(bottom: BorderSide(color: Colors.white)),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(height: 0),
          itemCount: _featureDescriptions.length,
        ),
      ),
    );
  }
}

List<String> _featureDescriptions = [
  'Login',
  'User Authentication',
  'Push Notifications',
  'Geolocation',
  'Camera Integration',
  'Image Processing',
  'Social Media login',
  'Analytics and Crash Reporting',
  'Device Sensors',
  'Deep Linking',
];

void main() => runApp(MaterialApp(home: FeatureListScreen()));
