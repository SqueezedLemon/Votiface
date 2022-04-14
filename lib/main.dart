import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votiface/providers/nav_bar_provider.dart';
import 'package:votiface/routes.dart';
import 'package:votiface/screens/landing/main_screen.dart';
import 'package:votiface/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavItems(),
        ),
      ],
      child: MaterialApp(
        title: 'Toy Choir',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        initialRoute: MainScreen.routeName,
        routes: routes,
      ),
    );
  }
}
