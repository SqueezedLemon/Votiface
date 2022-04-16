import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votiface/providers/nav_bar_provider.dart';
import 'package:votiface/routes.dart';
import 'package:votiface/screens/landing/landing_screen.dart';
import 'package:votiface/screens/landing/main_screen.dart';
import 'package:votiface/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        title: 'Votiface',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        initialRoute: LandingScreen.routeName,
        routes: routes,
      ),
    );
  }
}
