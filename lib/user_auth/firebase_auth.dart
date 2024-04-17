// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import '../global_files/helpers.dart';

// Helpers helpers = Helpers();

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'email-already-in-use') {
        log('The email address is already in use.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The email address is already in use.')));
        // helpers.showToast(message: 'The email address is already in use.');
      } else {
        log('An error occurred: ${e.code}');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill the required fields')));
        // helpers.showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      log('Logged IN');

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('You are Logged in')));
    } on FirebaseAuthException catch (e) {
      log('Logged error ${e.code}');
      if (e.code == 'user-not-found') {
        log('LNo user Found with this Email');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'invalid-credential') {
        log('Password incorrect');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password did not match')));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code)));
      }
    }
    return null;
  }
}
