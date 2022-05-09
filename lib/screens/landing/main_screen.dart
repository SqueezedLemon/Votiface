import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../../model/user_model.dart';
import '../../services/blockchain/blockchain.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late BlockChain bc;
  List<Widget> screens = [
    VoteScreen(),
    EResult(),
    AccountScreen(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bc = Provider.of<BlockChain>(context, listen: false);
    bc.init();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
    });
    bc.userArea = loggedInUser.firstName!;
    print(loggedInUser.firstName);

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
