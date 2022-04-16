import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: backColor,
    backgroundColor: kPrimaryColor,
    fontFamily: "Lato",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

TextTheme textTheme() {
  return const TextTheme(
      bodyText1: TextStyle(
        color: kTextPColor,
      ),
      bodyText2: TextStyle(
        color: kTextColor,
        fontSize: 40,
      ),
      headline1: TextStyle(color: kTextPColor, fontSize: 50),
      headline5: TextStyle(color: kTextPColor));
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: kPrimaryColor,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  );
}
