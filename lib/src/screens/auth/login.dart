import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/src/core/constants/validators/global_auth_validator.dart';
import 'package:user_auth/src/screens/auth/register.dart';
import 'package:user_auth/src/screens/home_screen.dart';
import 'package:user_auth/src/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Sign in to continue",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 30,
                ),
                buildEmailField(),
                SizedBox(
                  height: 30,
                ),
                buildPasswordField(),
                SizedBox(
                  height: 30,
                ),
                _buildLoginButton(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Or login with",
                  style: TextStyle(color: Colors.grey),
                ),
                IconButton(
                    icon: SvgPicture.asset("assets/icons/google.svg"),
                    onPressed: () async {
                      await loginProvider.googleSignIn();
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Register();
                          }));
                        },
                        child: Text("Register"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      validator: (val) =>
          GlobalAuthValidator.validatePassword(_passwordController.text),
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(Icons.vpn_key),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (val) =>
          GlobalAuthValidator.validateEmail(_emailController.text),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    final loginProvider = Provider.of<AuthServices>(context);
    return MaterialButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          print("Email: ${_emailController.text}");
          print("Password: ${_passwordController.text}");

          final result = await loginProvider.login(
              _emailController.text.trim(), _passwordController.text.trim());

          if (result != true) {
            displaySnackbar(
              snackBarContent: loginProvider.errorMessage,
              isErr: true);
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          }
        }
      },
      height: 60,
      minWidth: double.infinity,
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: loginProvider.isLoading
          ? CircularProgressIndicator()
          : Text(
              "Login",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
    );
  }

  void displaySnackbar({snackBarContent, bool? isErr}) {
    final snackBar = SnackBar(
        content: Text(snackBarContent,
      style: TextStyle(color: isErr! ? Colors.red : Colors.green),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
