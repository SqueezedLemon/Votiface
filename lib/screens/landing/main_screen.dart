import 'package:flutter/material.dart';
import 'package:votiface/components/custom_bottom_nav_bar.dart';
import 'package:votiface/constants.dart';
import 'package:votiface/providers/nav_bar_provider.dart';
import 'package:votiface/screens/account/account_screen.dart';
import 'package:votiface/screens/auth/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:votiface/screens/landing/components/body.dart';
import 'package:votiface/screens/vote/vote_screen.dart';
import 'package:votiface/screens/wallet_info/wallet_info.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [
    VoteScreen(),
    EResult(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Consumer<NavItems>(
          builder: (context, navItems, child) =>
              Body(bodyContent: screens[navItems.selectedNavIndex]),
        ),
      ),
      bottomNavigationBar:
          Container(height: 0.13 * screen_height, child: CustomBottomNavBar()),
    );
  }
}
