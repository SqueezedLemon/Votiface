import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:votiface/constants.dart';
import 'package:votiface/screens/auth/components/body.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Body();
  }
}
