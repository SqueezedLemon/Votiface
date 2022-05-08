import 'package:flutter/material.dart';
import 'package:votiface/screens/account/account_screen.dart';
import 'package:votiface/screens/candidate_screen.dart/candidate_page.dart';
import 'package:votiface/screens/landing/landing_screen.dart';
import 'package:votiface/screens/landing/main_screen.dart';
import 'package:votiface/screens/samanupatik_screen/samanupatik_page.dart';
import 'package:votiface/screens/vote/vote_screen.dart';
import 'screens/auth/auth_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LandingScreen.routeName: (ctx) => LandingScreen(),
  MainScreen.routeName: (ctx) => MainScreen(),
  AuthScreen.routeName: (ctx) => AuthScreen(),
  VoteScreen.routeName: (ctx) => VoteScreen(),
  AccountScreen.routeName: (ctx) => AccountScreen(),
  CandidatePage.routeName: (ctx) => CandidatePage(),
  SamanupatikPage.routeName: (ctx) =>SamanupatikPage(),

};
