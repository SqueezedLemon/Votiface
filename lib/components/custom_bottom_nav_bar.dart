import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votiface/providers/nav_bar_provider.dart';

import '../constants.dart';

enum MenuState {
  home,
  vote,
  account,
}

class CustomBottomNavBar extends StatefulWidget {
  // final Function changeIndex;
  const CustomBottomNavBar({
    Key? key,
    // required this.changeIndex,
  }) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  MenuState selectedMenu = MenuState.home;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: IconButton(
              icon: Icon(
                selectedMenu == MenuState.home
                    ? Icons.home_filled
                    : Icons.home_outlined,
              ),
              iconSize: 40,
              onPressed: () {
                Provider.of<NavItems>(context, listen: false).changeNavIndex(0);
                setState(() {
                  selectedMenu = MenuState.home;
                });
              },
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(
                selectedMenu == MenuState.vote
                    ? Icons.how_to_vote
                    : Icons.how_to_vote_outlined,
              ),
              iconSize: 40,
              onPressed: () {
                Provider.of<NavItems>(context, listen: false).changeNavIndex(1);
                setState(() {
                  selectedMenu = MenuState.vote;
                });
              },
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(
                selectedMenu == MenuState.account
                    ? Icons.person
                    : Icons.person_outline,
              ),
              iconSize: 40,
              onPressed: () {
                Provider.of<NavItems>(context, listen: false).changeNavIndex(2);
                setState(() {
                  selectedMenu = MenuState.account;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
