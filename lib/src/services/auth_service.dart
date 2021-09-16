import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  User? _user;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool?> register(String email, String password) async {
    setLoading(true);
    try {
      final authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = authResult.user;
      print(_user);
      setSuccessMessage("User Registered Successfully");
      setLoading(false);
      // return user;
      return true;
    } on SocketException {
      setMessage("No internet, please connect to internet");
    }
    catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }

  Future<bool?> login(String email, String password) async {
    setLoading(true);
    try {
      final authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = authResult.user;

      print(_user);
      notifyListeners();
      setLoading(false);
      // return user;
      return true;
    } on SocketException {
      setMessage("No internet, please connect to internet");
    }
    catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }


  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setSuccessMessage(success){
    _successMessage = success;
    notifyListeners();
  }

  User? get user => _user;
      //firebaseAuth.authStateChanges().map((event) => event);

}
