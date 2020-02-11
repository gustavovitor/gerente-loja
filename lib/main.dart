import 'package:flutter/material.dart';
import 'package:gerenteloja/screens/login_screen.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    brightness: Brightness.dark,
    accentColor: Color.fromRGBO(255, 0, 102, 1)
  ),
  debugShowCheckedModeBanner: false,
  home: LoginScreen(),
));
