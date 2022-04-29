import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:votiface/constants.dart';
import 'package:web3dart/web3dart.dart';
import 'package:votiface/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
File? image;
final User? user = auth.currentUser;
final uid = user?.uid;

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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

    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    var uri = Uri.parse(
        'https://vote-face-recog.herokuapp.com/account-api/user/set_profile_image/');

    var request = new http.MultipartRequest('POST', uri);

    request.fields['idToken'] = "$uid";

    var multiport = new http.MultipartFile('image', stream, length);

    request.files.add(multiport);

    var response = await request.send();

    print(response.stream.toString());
    if (response.statusCode == 200) {
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
    final logoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.deepPurpleAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
        onPressed: () => FirebaseAuth.instance.signOut(),
        child: const Text(
          "Logout",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final name = Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      color: Colors.yellow,
      child: Text(
        "${loggedInUser.firstName} ${loggedInUser.secondName}",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
    final email = Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      color: Colors.yellow,
      child: Text(
        "${loggedInUser.email}",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
    final citizenshipNumber = Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      color: Colors.yellow,
      child: Text(
        "${loggedInUser.citizenshipNumber}",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );

    final imagepick = Column(children: [
      GestureDetector(
        onTap: () {
          getImage();
        },
        child: Container(
          child: image == null
              ? const Center(
                  child: Text('Pick Image'),
                )
              : Container(
                  child: Center(
                    child: Image.file(
                      File(image!.path).absolute,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      GestureDetector(
        onTap: () {
          uploadImage();
        },
        child: Container(
          height: 50,
          width: 200,
          color: Colors.green,
          child: const Center(child: Text('Upload')),
        ),
      )
    ]);

    return Column(
      children: [imagepick, name, email, citizenshipNumber, logoutButton],
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
    );
  }
}
