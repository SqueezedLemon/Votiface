import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final Widget bodyContent;
  const Body({Key? key, required this.bodyContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: bodyContent,
    );
  }
}
