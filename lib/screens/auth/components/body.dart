import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'login_widget.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.40,
          width: double.infinity,
          child: Center(
            child: Text(
              'VOTIFACE LOGO',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: kTextPColor),
            ),
          ),
        ),
        LoginWidget(),
      ],
    );
  }
}
