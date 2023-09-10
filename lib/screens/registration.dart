import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/dashboard.dart';
import 'package:myapp/screens/login.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> regFormKey = GlobalKey<FormState>();
  late String _regEmail, _regPassword;

  void signUp(BuildContext context) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _regEmail, password: _regPassword)
        .catchError((onError) {
      print(onError);
    }).then((authUser) {
      if (authUser.user != null) {
        print(authUser.user?.email);
        Navigator.pop(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => LoginScreen()));
      }
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isUsernameValid = true;
  bool isPasswordValid = true;

  void validateEmail(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$',
      caseSensitive: false,
    );

    setState(() {
      isEmailValid = emailRegex.hasMatch(value);
    });
  }

  void validateUsername(String value) {
    setState(() {
      isUsernameValid = value.isNotEmpty;
    });
  }

  void validatePassword(String value) {
    setState(() {
      isPasswordValid = value.isNotEmpty;
    });
  }

  void register() {
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    setState(() {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$',
        caseSensitive: false,
      );

      isEmailValid = emailRegex.hasMatch(email);
      isUsernameValid = username.isNotEmpty;
      isPasswordValid = password.isNotEmpty;
    });

    if (isEmailValid && isUsernameValid && isPasswordValid) {
      // Perform registration logic here
      // You can navigate to the dashboard screen or show a success message

      // Navigating to the dashboard screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            emailOrUsername: email,
            password: password,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.black,
        child: Form(
          key: regFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _regEmail = value!;
                },
                validator: (email) {
                  if (email!.isEmpty) {
                    return 'Please Enter Email';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email)) {
                    return 'Invalid Email Format';
                  } else
                    return null;
                },
                // controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                  ),
                  // errorText: isEmailValid ? null : 'Invalid email',
                ),
                // onChanged: onChangevalidateEmail,
              ),
              SizedBox(height: 12.0),
              TextFormField(
                onSaved: (value) {
                  _regPassword = value!;
                },
                validator: (password) {
                  if (password!.isEmpty) {
                    return 'Please enter the password';
                  } else if (password.length < 8) {
                    return 'Password must be 8 character';
                  } else {
                    return null;
                  }
                },
                // controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                  ),
                  // errorText: isPasswordValid ? null : 'Password is required',
                ),
                // onChanged: validatePassword,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (regFormKey.currentState!.validate()) {
                    regFormKey.currentState?.save();
                    signUp(context);
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
