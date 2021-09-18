import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final String? snackbarContent;
  final Color? color;

  const CustomSnackbar({Key? key, @required this.snackbarContent, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
        content: Text(snackbarContent!,
        style: TextStyle(
          color: color ??  Colors.redAccent,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
