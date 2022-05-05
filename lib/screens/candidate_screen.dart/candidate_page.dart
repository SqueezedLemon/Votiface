import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votiface/screens/candidate_screen.dart/components/candidate_card.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../services/blockchain/blockchain.dart';

class CandidatePage extends StatefulWidget {
  static const routeName = '/candidate';
  const CandidatePage({Key? key}) : super(key: key);

  @override
  State<CandidatePage> createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  late List selectionList;
  late BlockChain bc;

  final _picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  File? image;

  @override
  void initState() {
    bc = Provider.of<BlockChain>(context, listen: false);
    selectionList = [for (var i = 0; i < bc.candidates.length; i++) true];
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
    print('after $selectionList');
  }

  handleCastVote() async {
    // take selfie
    await getImage();

    // validate image from backend service
    await validateImage();
  }

  Future<String> getIdToken() async {
    String? token = await user?.getIdTokenResult().then((value) => value.token);
    if (token != null) {
      return token;
    }
    return "";
  }

  Future<bool> validateImage() async {
    var l = await image!.length();
    print("image length is $l");

    var _userToken = await getIdToken();

    var uri = Uri.parse(
        "http://ce60-103-225-244-119.ngrok.io/face-recognition/check_face/"
        // "https://vote-face-recog.herokuapp.com/face-recognition/check_face/"
        );

    var request = http.MultipartRequest('POST', uri);
    request.fields['idToken'] = _userToken;

    request.files.add(
      http.MultipartFile.fromBytes("inputImage", image!.readAsBytesSync(),
          filename: "img.jpg"),
    );

    // print(request.files);
    var response = await request.send();
    print("After request this....");
    var responded = await http.Response.fromStream(response);
    final responseData = responded.body.toString();

    print("response status code ${response.statusCode}");
    print("Response data $responseData");

    final resJSON = json.decode(responseData);
    bool isValid = resJSON["faceID"];

    if (isValid) {
      print("it was valid");
    } else {
      print("it was it valid");
    }

    return false;
  }

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      print("all good bibek");
      setState(() {});
    } else {
      print('no image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(bc.candidates.length);
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
                        'Total Votes',
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
                    bc.voters_count.toString(),
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
                        itemCount: bc.candidates.length,
                        itemBuilder: (context, index) {
                          return CandidateCard(
                            isSelectable: selectionList[index],
                            selectedIndex: index,
                            selectionCallback: selectionCallback,
                            candidate_image_url: 'assets/ElectionBanner.png',
                            candidate_name: bc.candidates[index][0],
                            candidate_party_url: 'assets/logo.png',
                            candidate_party_name: bc.candidates[index][1],
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
                          child: ElevatedButton(
                            onPressed: () async {
                              //todo confirmation with popup
                              print("voting....");
                              await handleCastVote();
                              //todo face detection
                              //selectedCandidate = selectionList.indexWhere((element) => false)
                              // bc.submit('voteCandidate', [
                              //   selectionList.indexWhere((element) => false)
                              // ]);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              fixedSize: const Size(400, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90.0),
                              ),
                            ),
                            child: Text(
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
