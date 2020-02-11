import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final IconData icon;
  final Stream<String> stream;
  final Function(String) onChanged;

  CustomTextFormField({@required this.hintText, @required this.icon, this.obscure = false, @required this.stream, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: onChanged,
            decoration: InputDecoration(icon: Icon(icon), hintText: hintText, errorText: snapshot.hasError ? snapshot.error : null),
            obscureText: obscure,
          );
        });
  }
}
