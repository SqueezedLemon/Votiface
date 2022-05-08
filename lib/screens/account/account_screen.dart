import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:votiface/constants.dart';
import 'package:web3dart/web3dart.dart';
import 'package:votiface/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart';

import '../../services/blockchain/blockchain.dart';

const IconData upload = IconData(0xe695, fontFamily: 'MaterialIcons');

final FirebaseAuth auth = FirebaseAuth.instance;
File? image;
final User? user = auth.currentUser;
final uid = user?.uid;

// final idTokenResult = user?.getIdToken().then(String token);
final idTokenResult = user?.getIdTokenResult().then((value) => value.token);
bool isLoading = false;
class AccountScreen extends StatefulWidget {
  static const routeName = '/account';
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  FirebaseStorage storage = FirebaseStorage.instance;

  var profileImageUrl = "";
  var isProfileImageEmpty = true;
  var isProfileImageLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    print('uid $loggedInUser.uid');


    getAvatarUrlForProfile();
  }

  getAvatarUrlForProfile() async {
    var _url = "";
    var isEmpty = false;

    try {
      var url_img = await storage
          .ref()
          .child("profile-images/$uid.jpeg")
          // .child("profile-images/bibekUrkkkasdpkV73jfDwAnuiDbllOk2.jpeg")
          .getDownloadURL();

      _url = url_img;
      print("url was $url_img");
    } catch (e) {
      isEmpty = true;
    }

    setState(() {
      profileImageUrl = _url;
      isProfileImageEmpty = isEmpty;
      isProfileImageLoading = false;

      print(
          "state was $profileImageUrl $isProfileImageEmpty $isProfileImageLoading");
    });
  }
  Future<String> getIdToken() async {
    String? token = await user?.getIdTokenResult().then((value) => value.token);
    if (token != null) {
      return token;
    }
    return "";
  }

  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print('no image selected');
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });

    var _userToken = await getIdToken();

    // // network part
    // var uri = Uri.parse(
    //     "https://vote-face-recog.herokuapp.com/account-api/user/set_profile_image/");

    var uri = Uri.parse(
        "http://192.168.254.13:8000/account-api/user/set_profile_image/");
    var request = http.MultipartRequest('POST', uri);
    request.fields['idToken'] = _userToken;

    request.files.add(
      http.MultipartFile.fromBytes("profileImage", image!.readAsBytesSync(),
          filename: "$uid.jpg"),
    );

    print(request.files);

    var response = await request.send();
    print("After request this....");

    var responded = await http.Response.fromStream(response);
    final responseData = responded.body.toString();

    print("The data was ${responseData}");
    print("response code ${response.statusCode}");
    if (response.statusCode == 202) {
      setState(() {
        showSpinner = false;
      });
      print('image uploaded');
    } else {
      print('failed');
      setState(() {
        showSpinner = false;
      });
    }
  }

  // String privateKey =
  //     '614aff264350728eed060541370810b678d49482bd6f957ce200d93ba18d51b2';
  // // String rpcUrl = 'http://192.168.0.109:8545';
  // String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  // String contractAddress = "0x0da0A4EC7333aad77E6630340E0f5B791525f5AE";
  // late Client httpClient;
  // late Web3Client ethereumClient;
  // String contractName = "Voting";

  // int voters_count = 0;
  // List<dynamic> candidates = [[]];

  // @override
  // void initState() {
  //   super.initState();
  //   httpClient = Client();
  //   ethereumClient = Web3Client(rpcUrl, httpClient);
  // }

  // Future<void> votersCount() async {
  //   setState(() {});
  //   List<dynamic> result = await query('voters_count', []);
  //   print(result.length);
  //   voters_count = int.parse(result[0].toString());
  //   print(voters_count.toString());
  //   setState(() {});
  // }

  // Future<void> getCandidates() async {
  //   setState(() {});
  //   List<dynamic> result = await query('getCandidates', []);
  //   print(result[0]);
  //   candidates = result[0];
  //   print(candidates);

  //   setState(() {});
  // }

  // Future<DeployedContract> getContract() async {
  //   String abi = await rootBundle.loadString("assets/blockchain/abi.json");

  //   DeployedContract contract = DeployedContract(
  //     ContractAbi.fromJson(abi, contractName),
  //     EthereumAddress.fromHex(contractAddress),
  //   );

  //   return contract;
  // }

  // Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
  //   DeployedContract contract = await getContract();
  //   ContractFunction function = contract.function(functionName);
  //   List<dynamic> result = await ethereumClient.call(
  //       contract: contract, function: function, params: args);
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
    BlockChain bc = Provider.of<BlockChain>(context, listen: true);

    final logoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: kColor2,
      child: Container(
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
          onPressed: () {
            setState(() {
            isLoading = true;
          }); FirebaseAuth.instance.signOut();
          setState(() {
            isLoading = false;
          });},
          child: isLoading? CircularProgressIndicator(): const Text(
            "Logout",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
    final name = Text(
      "${loggedInUser.firstName} ${loggedInUser.secondName}",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 20, color: kTextColor, fontWeight: FontWeight.bold),
    );
    final email = Text("Email : ${loggedInUser.email}",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold));
    final citizenshipNumber = Text(
      "C No. : ${loggedInUser.citizenshipNumber}",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 20, color: kTextColor, fontWeight: FontWeight.bold),
    );

    // ignore: prefer_const_constructors

    final space = SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
    );
    final ySpace = SizedBox(
      width: MediaQuery.of(context).size.width * 0.05,
    );

    final profile = Row(
      children: [
        ySpace,
        const Text(
          "Profile",
          style: TextStyle(
              fontSize: 35, color: Colors.black, fontWeight: FontWeight.w900),
        )
      ],
    );

    // final imagepick = Column(children: [
    //   GestureDetector(
    //     onTap: () {
    //       getImage();
    //     },
    //     child: Container(
    //       child: image == null
    //           ? const Center(
    //               child: Text('Pick Image'),
    //             )
    //           : Center(
    //               child: Image.file(
    //                 File(image!.path).absolute,
    //                 height: 100,
    //                 width: 100,
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //     ),
    //   ),
    //   const SizedBox(
    //     height: 15,
    //   ),
    //   GestureDetector(
    //     onTap: () {
    //       uploadImage();
    //     },
    //     child: Container(
    //       height: 50,
    //       width: 200,
    //       color: Colors.green,
    //       child: const Center(child: Text('Upload')),
    //     ),
    //   )
    // ]);

    final imagepick = SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            ySpace,
           isProfileImageLoading? CircularProgressIndicator(): GestureDetector(
              onTap: () {
                getImage();
              },
              child: CircleAvatar(
                radius: 50,
                child: image == null
                    ? const Center(
                        child: Text('Pick Image'),
                      )
                    : CircleAvatar(
                        radius: 50,
                        child: Image.file(
                          File(image!.path).absolute,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
            ),
            ySpace,
            isProfileImageLoading? SizedBox(): GestureDetector(
              onTap: () {
                uploadImage();
              },
              child: Container(
                height: 30,
                width: 30,
                color: backColor,
                child: const Center(
                  child: Icon(Icons.upload),
                ),
              ),
            ),
            ySpace,
            Column(
              children: [name, citizenshipNumber],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.90,
      height: MediaQuery.of(context).size.height * 0.15,
    );

    final imageshow = SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            ySpace,
            isProfileImageLoading? CircularProgressIndicator(): CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            ySpace,
            Column(
              children: [name, citizenshipNumber],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.90,
      height: MediaQuery.of(context).size.height * 0.15,
    );

    // if (isProfileImageLoading) {
    //   return const CircularProgressIndicator();
    // }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          space,
          profile,
          space,
          isProfileImageEmpty ? imagepick : imageshow,
          space,
          Container(
          padding: EdgeInsets.all(3),
          child: QrImage(
            data: {'publicKey':bc.publicKey.toString(),'citizenship':loggedInUser.citizenshipNumber,'area':loggedInUser.area, }.toString(),
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
        SizedBox(height: 80,),
          logoutButton,
          // imageshow
        ],
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Align(
        //       alignment: Alignment.center,
        //       child: ElevatedButton(
        //           onPressed: () {
        //             votersCount();
        //           },
        //           child: Text("total Voters")),
        //     ),
        //     Text(
        //       voters_count.toString(),
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //     ),
        //     ElevatedButton(
        //         onPressed: () {
        //           getCandidates();
        //         },
        //         child: Text("total_candidates")),
        //     Text(
        //       candidates.toString(),
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //     ),
        //   ],
      ),
    );
  }
}
