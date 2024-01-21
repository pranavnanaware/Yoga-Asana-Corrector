import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<fb.User?> signIn(String email, String password) async {
    try {
      fb.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      fb.User? user = userCredential.user;
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', user.email ?? '');
        prefs.setString('uid', user.uid);
        prefs.setString('displayName', user.displayName ?? '');
      }
      return user;
    } on fb.FirebaseAuthException catch (e) {
      // Handle authentication error
      return null;
    }
  }

  Future<fb.User?> signUp(
      String email, String password, String fname, String lname) async {
    try {
      fb.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      fb.User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName('$fname $lname');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', user.email ?? '');
        prefs.setString('uid', user.uid);
        prefs.setString('displayName', user.displayName ?? '');
      }
      return user;
    } on fb.FirebaseAuthException catch (e) {
      // Handle sign-up error
      return null;
    }
  }

  Future<String?> getCurrentUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }

  Future<String?> storeProfilePhoto(File photo) async {
    try {
      fb.User? user = _firebaseAuth.currentUser;
      if (user != null) {
        var fileRef = _firebaseStorage.ref().child(user.uid);
        await fileRef.putFile(photo);
        return await fileRef.getDownloadURL();
      }
      return null;
    } catch (e) {
      // Handle storage error
      return null;
    }
  }

  Future<fb.User?> updateCurrentUser(
      String displayName, String? photoUrl) async {
    try {
      fb.User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoUrl);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', user.email ?? '');
        prefs.setString('uid', user.uid);
        prefs.setString('displayName', user.displayName ?? '');
        return user;
      }
      return null;
    } catch (e) {
      // Handle update error
      return null;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _firebaseAuth.signOut();
  }
}
