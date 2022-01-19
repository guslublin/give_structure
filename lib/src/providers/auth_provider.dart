import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  FirebaseAuth _firebaseAuth;
  BuildContext context;

  AuthProvider(){
    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser(){
    return _firebaseAuth.currentUser;
  }

  bool isSignedIn(){
    final currentUser = _firebaseAuth.currentUser;
    if(currentUser == null){
      return false;
    } else {
      return true;
    }
  }

  void checkIfUserIsLogged(BuildContext context, String typeUser){
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null && typeUser != null){
        print("El usuario está logueado");
        if (typeUser == 'client'){
          Navigator.pushNamedAndRemoveUntil(context, 'client/map', (Route<dynamic> route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (Route<dynamic> route) => false);
        }
        /*Navigator.pushNamed(
          context, 'client/map',
        );*/
      } else {
        print("El usuario no está logueado");
      }
    });
  }

  Future<bool> login(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch(error) {
      print(error);
      errorMessage = error.code;
    }

    if (errorMessage != null){
      return Future.error(errorMessage);
    }

    return true;
  }

  Future<bool> register(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch(error) {
      print(error);
      errorMessage = error.code;
    }

    if (errorMessage != null){
      return Future.error(errorMessage);
    }

    return true;
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }
}