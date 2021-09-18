import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/src/screens/auth/login.dart';
import 'package:user_auth/src/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                  "Welcome",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Create an account to continue",
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
                MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print("Email: ${_emailController.text}");
                      print("Password: ${_passwordController.text}");

                      final result = await loginProvider.register(_emailController.text.trim(),
                          _passwordController.text.trim());
                      if(result == true){
                        displaySnackbar(
                            snackBarContent: loginProvider.successMessage,
                            isErr: false);
                        Navigator.of(context).
                          push(MaterialPageRoute(builder: (context){
                            return Login();
                        }));
                      }else{
                        displaySnackbar(
                            snackBarContent: loginProvider.errorMessage,
                            isErr: true);
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
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                        child: Text("Login"))
                  ],
                ),
                SizedBox(
                  height: 20,
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
                validator: (val) => val!.length > 4
                    ? null
                    : "Password must be more than 4 characters.",
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
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val!.isNotEmpty ? null : "Please enter an email address",
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
