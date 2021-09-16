import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/src/screens/auth/login.dart';
import 'package:user_auth/src/services/auth_service.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot){
        if (snapshot.hasError) {
          return ErrorWidget("Err");
        } else if (snapshot.hasData) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthServices>.value(value: AuthServices()),
                // StreamProvider<User?>.value(
                //     value: AuthServices().user,
                //     initialData: null,
                // ),
              ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.purple,
              ),
              home: Login(),
            ),
          );
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}

