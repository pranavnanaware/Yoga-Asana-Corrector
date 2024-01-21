import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_asana/home.dart';
import 'package:yoga_asana/login.dart';
import 'package:yoga_asana/register.dart';
import 'package:yoga_asana/util/user.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? email = prefs.getString('email');
  String? uid = prefs.getString('uid');
  String? displayName = prefs.getString('displayName');
  String? photoUrl = prefs.getString('photoUrl');

  User user = User();
  user.setUser({
    'email': email,
    'displayName': displayName,
    'uid': uid,
    'photoUrl': photoUrl,
  });

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  runApp(
    email != null && uid != null
        ? MyApp(
            email: user.email!,
            uid: user.uid!,
            displayName: user.displayName!,
            photoUrl: user.photoUrl!,
            cameras: cameras!,
          )
        : MyApp(
            cameras: cameras!,
            displayName: '',
            email: '',
            photoUrl: '',
            uid: '',
          ),
  );
}

class MyApp extends StatelessWidget {
  final String email;
  final String uid;
  final String displayName;
  final String photoUrl;
  final List<CameraDescription> cameras;

  const MyApp({
    required this.email,
    required this.uid,
    required this.displayName,
    required this.photoUrl,
    required this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yoga Guru',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: (email != null && uid != null) ? '/' : '/login',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(
              email: email,
              uid: uid,
              displayName: displayName,
              photoUrl: photoUrl,
              cameras: cameras,
            ),
        '/login': (BuildContext context) => Login(
              cameras: cameras,
            ),
        'register': (BuildContext context) => Register(
              cameras: [],
            ),
      },
    );
  }
}
