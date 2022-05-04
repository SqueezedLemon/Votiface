import 'dart:ui';
import '../vote/components/body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votiface/constants.dart';
import 'package:flutter/material.dart';

enum currectTab { active, upcoming }

var heading = 'National Election';
var subheading = '2022';
var supportingText = '5:45';

class VoteScreen extends StatefulWidget {
  static const routeName = '/vote';
  const VoteScreen({Key? key}) : super(key: key);

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  var tab = currectTab.active;
  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Elections',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: double.infinity, height: kDefaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tab = currectTab.active;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: (tab == currectTab.active)
                          ? kPrimaryColor
                          : backColor,
                      borderRadius: BorderRadius.circular(
                          (tab == currectTab.active) ? 20 : 0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Active",
                      style: TextStyle(
                        fontSize: 30,
                        color: (tab == currectTab.active)
                            ? kTextPColor
                            : kTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tab = currectTab.upcoming;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: (tab == currectTab.upcoming)
                          ? kPrimaryColor
                          : backColor,
                      borderRadius: BorderRadius.circular(
                          (tab == currectTab.upcoming) ? 20 : 0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Upcoming",
                      style: TextStyle(
                        fontSize: 30,
                        color: (tab == currectTab.upcoming)
                            ? kTextPColor
                            : kTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: kTextColor,
            ),
          ),
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 10.0,
              child: Column(
                children: [
                  ListTile(
                    title: Text(heading),
                    subtitle: Text(subheading),
                  ),
                  SizedBox(
                      height: 250.0,
                      child: Image.asset(
                        "assets/ElectionBanner.png",
                        fit: BoxFit.contain,
                      )),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(supportingText),
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        child: const Text(
                          'Vote',
                          style: const TextStyle(fontSize: 26),
                        ),
                        onPressed: () {/* ... */},
                      )
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ],
      ),
    );
  }
}
