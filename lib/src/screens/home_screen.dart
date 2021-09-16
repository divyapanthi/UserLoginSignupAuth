import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/src/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await loginProvider.logout();
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(loginProvider.user!.email!),
            ],
          ),
        ),
      ),
    );
  }
}
