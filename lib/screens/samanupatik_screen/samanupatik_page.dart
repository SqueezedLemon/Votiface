import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:votiface/screens/candidate_screen.dart/components/candidate_card.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../services/blockchain/blockchain.dart';
import 'components/samanupatik_card.dart';

class SamanupatikPage extends StatefulWidget {
  static const routeName = '/samanupatik';
  const SamanupatikPage({Key? key}) : super(key: key);

  @override
  State<SamanupatikPage> createState() => _SamanupatikPageState();
}

class _SamanupatikPageState extends State<SamanupatikPage> {
  // late List candidateList = [
  //   ['name', 'Congress'],
  //   ['biraje', 'Maoist']
  // ];
  late List selectionList;
  late BlockChain bc;

  final _picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  File? image;

  bool isLoading = false;

  @override
  void initState() {
    bc = Provider.of<BlockChain>(context, listen: false);
    selectionList = [for (var i = 0; i < bc.parties.length; i++) true];
    super.initState();
  }

  void selectionCallback(int selectedIndex) {
    print('before $selectionList $selectedIndex');
    setState(() {
      selectionList = [
        for (var i = 0; i < selectionList.length; i++)
          if (i == selectedIndex) false else true
      ];
    });
    print('after $selectionList ');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Image.asset('assets/ElectionBanner.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(Icons.data_array),
                      const Text(
                        'Total Voters',
                        style: const TextStyle(
                          color: Color.fromARGB(87, 0, 0, 0),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    bc.party_vote_count.toString(),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timer,
                      ),
                      const Text(
                        'Voting Closes at 4pm Aug 04, 2022',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: bc.parties.length,
                        itemBuilder: (context, index) {
                          return SamanupatikCard(
                            isSelectable: selectionList[index],
                            selectedIndex: index,
                            selectionCallback: selectionCallback,
                            party_name: bc.parties[index][0],
                            party_url: 'assets/logo.png',
                          );
                        },
                      ),
                      // CandidateCard(
                      //   candidate_image_url: 'assets/ElectionBanner.png',
                      //   candidate_name: 'Biraj Motherfucker',
                      //   candidate_party_url: 'assets/logo.png',
                      //   candidate_party_name: 'Nepali Congress',
                      // ),
                      // CandidateCard(
                      //   candidate_image_url: 'assets/ElectionBanner.png',
                      //   candidate_name: 'Biraj Motherfucker',
                      //   candidate_party_url: 'assets/logo.png',
                      //   candidate_party_name: 'Nepali Congress',
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            fixedSize: const Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                          ),
                          child:
                              // isLoading ? CircularProgressIndicator() :
                              ElevatedButton(
                            // onPressed: () async {
                            //   //todo confirmation with popup
                            //   print("voting....");
                            //   setState(() {
                            //     isLoading = true;
                            //   });
                            //   var isValid = await handleCastVote();

                            //   if(isValid){
                            //     // toast message face id success
                            //     Fluttertoast.showToast(msg: "Face Id success");

                            //     //todo face detection
                            //     var id = selectionList.indexWhere((element) => element==false);
                            //     print(id);

                            //       bc.submit('voteCandidate', [BigInt.from(id)],);

                            //     // vote success
                            //     Fluttertoast.showToast(msg: "Vote Success");

                            //   }else{
                            //     // toast msg invalid
                            //     Fluttertoast.showToast(msg: "Invalid Face ID");

                            //   }
                            //   setState(() {
                            //     isLoading = false;

                            onPressed: () async {
                              var id = selectionList.indexWhere(
                                          (element) => element == false);
                              setState(() {
                                isLoading = true;
                              });
                              await bc.submit(
                                        'voteParty',
                                        [BigInt.from(id)],
                                      );
                              
                                      setState(() {
                                        isLoading = false;
                                      });
                              await bc.init();
                              Navigator.of(context).popAndPushNamed('/vote');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              fixedSize: const Size(400, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90.0),
                              ),
                            ),
                            child: isLoading? CircularProgressIndicator(): Text(
                              'Submit Vote',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
