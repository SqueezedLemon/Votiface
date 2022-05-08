import 'package:flutter/material.dart';

class EResult extends StatefulWidget {
  const EResult({ Key? key }) : super(key: key);

  @override
  State<EResult> createState() => _EResultState();
}

class _EResultState extends State<EResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child:Text('Results'),),
    );
  }
}