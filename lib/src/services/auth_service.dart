import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  User? _user;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleUser; //field for user that has signed in
  GoogleSignInAccount get googleUser => _googleUser!;

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
      setMessage(e.toString().trim());
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

  Future<void> googleSignIn() async {

    if(_googleUser!=null) {
      final GoogleSignInAuthentication googleAuth = await _googleUser!
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final UserCredential userCredential = await firebaseAuth
            .signInWithCredential(credential);

        _user = userCredential.user;
      } on FirebaseAuthException catch(e){
        if(e.code == 'account-exists-with-different-credential'){
          setMessage("The account already exists with different credential.");
        }
        else if(e.code == 'invalid-credential'){
          setMessage("Error occured while accessing credentials. Try again.");
        }
      }catch(e){
        setMessage("Error occured using google sign-in. Please try again.");
      }
    }


    // try {
    //   final googleUser = await _googleSignIn.signIn(); //
    //
    //   if (googleUser == null) return;
    //   _googleUser = googleUser;
    //
    //   setLoading(true);
    //   final googleAuth = await googleUser.authentication;
    //
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //
    //   await firebaseAuth.signInWithCredential(credential);
    //   _user = firebaseAuth.currentUser;
    //   setLoading(false);
    //
    // } catch (e) {
    //   print(e.toString());
    // }




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
