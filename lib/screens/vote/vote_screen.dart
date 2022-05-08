import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:votiface/screens/candidate_screen.dart/candidate_page.dart';
import 'package:votiface/services/blockchain/blockchain.dart';

import '../vote/components/body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votiface/constants.dart';
import 'package:flutter/material.dart';

enum currectTab { active, upcoming }

var heading = 'Direct Election';
var subheading = '2022';
var supportingText = 'Open';

class VoteScreen extends StatefulWidget {
  static const routeName = '/vote';
  const VoteScreen({Key? key}) : super(key: key);

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  @override
  void initState() {
    Provider.of<BlockChain>(context, listen: false).init();
    super.initState();
  }

  var tab = currectTab.active;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Elections',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: double.infinity, height: kDefaultPadding),
          Column(
            children: [
              Card(
                elevation: 10.0,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ElectionBanner.png"),
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Text(
                            'Direct Election',
                            style: const TextStyle(
                                color: kTextPColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '2022',
                            style: const TextStyle(
                                color: kTextPColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 125.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              supportingText,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          ButtonBar(
                            children: [
                              TextButton(
                                child: const Text(
                                  'Vote',
                                  style: TextStyle(fontSize: 26),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(CandidatePage.routeName);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10.0,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ElectionBanner.png"),
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Text(
                            "Samanupatik Election",
                            style: const TextStyle(
                                color: kTextPColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            subheading,
                            style: const TextStyle(
                                color: kTextPColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 125.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              supportingText,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          ButtonBar(
                            children: [
                              TextButton(
                                child: const Text(
                                  'Vote',
                                  style: TextStyle(fontSize: 26),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(CandidatePage.routeName);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
