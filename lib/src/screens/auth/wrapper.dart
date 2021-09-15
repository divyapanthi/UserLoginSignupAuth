import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/src/screens/auth/login.dart';
import 'package:user_auth/src/screens/home_screen.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user != null){
      return HomeScreen();
    }else{
      return Login();
    }
  }
}
