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

class SamanupatikPage extends StatefulWidget {
  static const routeName = '/samanupatik';
  const SamanupatikPage({Key? key}) : super(key: key);

  @override
  State<SamanupatikPage> createState() => _SamanupatikPageState();
}

class _SamanupatikPageState extends State<SamanupatikPage> {
  late List candidateList = [['name', 'Congress'],['biraje', 'Maoist']];
  // late BlockChain bc;

  // final _picker = ImagePicker();
  // User? user = FirebaseAuth.instance.currentUser;

  // File? image;

  // bool isLoading = false;

    

  // @override
  // void initState() {
  //   bc = Provider.of<BlockChain>(context, listen: false);
  //   selectionList = [for (var i = 0; i < bc.candidates.length; i++) true];
  //   super.initState();
  // }

  void selectionCallback(int selectedIndex) {
    // print('before $selectionList $selectedIndex');
    // setState(() {
    //   selectionList = [
    //     for (var i = 0; i < selectionList.length; i++)
    //       if (i == selectedIndex) false else true
    //   ];
    // });
    print('after ');
  }

  // castVote() async{
  //    String privateKey =
  //     '00a74f50d4de0f74113cb3d5c63d01816f8885171182d8d0007e997959e703768c';

  //   String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  //   String contractAddress = "0x910C23D26b8Ab871a6c8c3570aBB0D2d381e3726";
    
  //   late Web3Client ethereumClient;
  //   late EthPrivateKey credentials;
  //   late Client httpClient;


  //   String publicKey = "";
  //   String contractName = "Voting";

  //   credentials = EthPrivateKey.fromHex(privateKey);
  //   httpClient = Client();
  //   ethereumClient = Web3Client(rpcUrl, httpClient);
  //   publicKey = credentials.address.toString();

  //   DeployedContract contract = await getContract(contractName,contractAddress);

                                
  //   final ethFunction = contract.function("voteCandidate");
  //   print(credentials.address);
  //   final result = await ethereumClient.sendTransaction(
  //     credentials,
  //     Transaction.callContract(
  //       contract: contract,
  //       function: ethFunction,
  //       parameters: [BigInt.from(0)],
  //     ),
  //     fetchChainIdFromNetworkId: true,
  //     chainId: null,
  //   );
  // }

  // Future<DeployedContract> getContract(String contractName, String contractAddress) async {
  //   String contractJson =
  //       await rootBundle.loadString("assets/blockchain/Voting.json");
  //   var jsonAbi = jsonDecode(contractJson);
  //   var abi = jsonEncode(jsonAbi['abi']);

  //   DeployedContract contract = DeployedContract(
  //     ContractAbi.fromJson(abi, contractName),
  //     EthereumAddress.fromHex(contractAddress),
  //   );

  //   return contract;
  // }


  // Future<bool> handleCastVote() async {
  //   // take selfie
  //   await getImage();

  //   // validate image from backend service
  //   return await validateImage();
  //   // await castVote();
  // }

  // Future<String> getIdToken() async {
  //   String? token = await user?.getIdTokenResult().then((value) => value.token);
  //   if (token != null) {
  //     return token;
  //   }
  //   return "";
  // }

  // Future<bool> validateImage() async {
  //   var l = await image!.length();
  //   print("image length is $l");

  //   var _userToken = await getIdToken();

  //   print("user token is  $_userToken");

  //   // change uri to local
  //   var uri = Uri.parse(
  //       "http://192.168.254.13:8000/face-recognition/check_face/"
  //       // "http://ce60-103-225-244-119.ngrok.io/face-recognition/check_face/"
  //       // "https://vote-face-recog.herokuapp.com/face-recognition/check_face/"
  //       );

  //   var request = http.MultipartRequest('POST', uri);
  //   request.fields['idToken'] = _userToken;

  //   request.files.add(
  //     http.MultipartFile.fromBytes("inputImage", image!.readAsBytesSync(),
  //         filename: "img.jpg"),
  //   );

  //   // print(request.files);
  //   var response = await request.send();
  //   print("After request this....");
  //   var responded = await http.Response.fromStream(response);
  //   final responseData = responded.body.toString();

  //   print("response status code ${response.statusCode}");
  //   print("Response data $responseData");

  //   final resJSON = json.decode(responseData);
  //   bool isValid = resJSON["faceID"];

  //   if (isValid) {
  //     print("it was valid");
  //     return true;
  //   }
  //   print("it was invalid valid");
  //   return false;
  // }

  // Future getImage() async {
  //   final pickedFile =
  //       await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);

  //   if (pickedFile != null) {
  //     image = File(pickedFile.path);
  //     print("all good bibek");
  //     setState(() {});
  //   } else {
  //     print('no image selected');
  //   }
  // }

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
                    '50',
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
                        itemCount: candidateList.length,
                        itemBuilder: (context, index) {
                          return CandidateCard(
                            isSelectable: true,
                            selectedIndex: index,
                            selectionCallback: selectionCallback,
                            candidate_image_url: 'assets/ElectionBanner.png',
                            candidate_name: candidateList[index][0],
                            candidate_party_url: 'assets/logo.png',
                            candidate_party_name: candidateList[index][1],
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

                              
                            onPressed: (){},
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
