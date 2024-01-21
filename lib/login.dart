import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:yoga_asana/home.dart';
import 'package:yoga_asana/register.dart';
import 'package:yoga_asana/util/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Login({required this.cameras});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailInputController = TextEditingController();
  TextEditingController _pwdInputController = TextEditingController();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else {
      // Regular expression for email validation
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);

      if (!regex.hasMatch(value)) {
        return 'Email format is invalid';
      } else {
        return null;
      }
    }
  }

  String? pwdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 32.0),
          child: Form(
            key: _loginFormKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Image.asset('assets/images/yoga1.png'),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailInputController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: emailValidator,
                ),
                SizedBox(height: 32.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: _pwdInputController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: pwdValidator,
                ),
                SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.all(14.0),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: _onRegister,
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(cameras: widget.cameras),
      ),
    );
  }

  void _login() async {
    Auth auth = Auth();
    if (_loginFormKey.currentState!.validate()) {
      try {
        UserCredential userCredential = (await auth.signIn(
          _emailInputController.text,
          _pwdInputController.text,
        )) as UserCredential;

        User? user = userCredential.user;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                email: user.email!,
                uid: user.uid,
                displayName: user.displayName ?? '',
                photoUrl: user.photoURL ?? '',
                cameras: widget.cameras,
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message ?? "An error occurred"),
              actions: <Widget>[
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error: ' + e.toString());
      }
    }
  }
}
