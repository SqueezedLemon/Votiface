import 'dart:ui';

import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Account Screen',
        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      ),
    );
  }
}
