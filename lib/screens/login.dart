import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/screens/dashboard.dart';
import 'package:myapp/biometric_auth.dart';
import 'package:myapp/screens/location.dart';
import 'package:myapp/screens/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String _email, _password;

void signIn(BuildContext context) async{
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: _email, password: _password)
      .catchError((onError){
    print(onError);
  }).then((authUser){
    if(authUser.user != null){
      Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>DashboardScreen(
                      emailOrUsername: _email,
                      password: _password))
              );
    }
  });
}
  // void validateEmailOrUsername(String value) {
  //   final emailRegex = RegExp(
  //     r'^vicky@gmail\.com$',
  //     caseSensitive: false,
  //   );
  //   final usernameRegex = RegExp(
  //     r'^Vicky$',
  //     caseSensitive: false,
  //   );
  //
  //   setState(() {
  //     isEmailOrUsernameValid =
  //         emailRegex.hasMatch(value) || usernameRegex.hasMatch(value);
  //   });
  // }
  //
  // void validateEmailOrUsernameatePassword(String value) {
  //   setState(() {
  //     isPasswordValid = value == 'samiVicky';
  //   });
  // }

  Future<void> loginWithFingerprint() async {
    final biometricAuth = BiometricAuth();
    String? emailOrUsername = _email;
    String? password = _password;
    await biometricAuth.authenticate(context, emailOrUsername!, password!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.black,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    _email = value!;
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
                  // controller: emailOrUsernameController,
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
                    // errorText: isEmailOrUsernameValid ? null : 'Invalid email or username',
                  ),
                  // onChanged: validateEmailOrUsername,
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  onSaved: (value) {
                    _password = value!;
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
                    // errorText: isPasswordValid ? null : 'Invalid password',
                  ),
                  // onChanged: validatePassword,
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();
                      signIn(context);
                      // if(_email == 'test@gmail.com' && _password == 'test@123'){
                      //     Navigator.push(context, MaterialPageRoute(
                      //         builder: (context)=>DashboardScreen(
                      //             emailOrUsername: _email,
                      //             password: _password))
                      //     );
                      // }else{
                      //   print('Invalid Login Details');
                      // }
                      // FocusScope.of(context).unfocus();
                      // print(_email);
                      // print(_password);
                    }
                    // String emailOrUsername = emailOrUsernameController.text;
                    // String password = passwordController.text;
                    // setState(() {
                    //   final emailRegex = RegExp(
                    //     r'^vicky@gmail\.com$',
                    //     caseSensitive: false,
                    //   );
                    //   final usernameRegex = RegExp(
                    //     r'^Vicky$',
                    //     caseSensitive: false,
                    //   );
                    //
                    //   isEmailOrUsernameValid = emailRegex.hasMatch(emailOrUsername) ||
                    //       usernameRegex.hasMatch(emailOrUsername);
                    //
                    //   isPasswordValid = password == 'samiVicky';
                    // });
                    // if (isEmailOrUsernameValid && isPasswordValid) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => DashboardScreen(
                    //         emailOrUsername: emailOrUsername,
                    //         password: password,
                    //       ),
                    //     ),
                    //   );
                    // }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
                SizedBox(height: 12.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: Text(
                    'New User!',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: loginWithFingerprint,
                  child: Text(
                    'Login with fingerprint',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
