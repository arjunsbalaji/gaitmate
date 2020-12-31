import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  
  Future <void> signOut() async {
    await _firebaseAuth.signOut();
  }
  
  Future signIn({String email, String password, context}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email:email, password:password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      print (e.message);
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.message),
            actions: <Widget>[
              TextButton(child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },)
            ],
          );}
      );
    }
  }

  Future signUp({String email, String password, context}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return 'Signed up';
    } on FirebaseAuthException catch (e) {
      print (e.message);
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.message),
            actions: <Widget>[
              TextButton(child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },)
            ],
          );}
      );
    }
  }
}