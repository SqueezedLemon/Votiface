import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'package:http/http.dart';

class WalletInfoScreen extends StatefulWidget {
  static const routeName = '/account';
  const WalletInfoScreen({Key? key}) : super(key: key);

  @override
  _WalletInfoScreenState createState() => _WalletInfoScreenState();
}

class _WalletInfoScreenState extends State<WalletInfoScreen> {
  bool isLoading = true;
  String publicKey = "";
  String privateKey =
      'ccf8427c2704fec9f83aa916741f089efccb9fe6e5d89f506343c823eedbcbce';
  // String privateKey =
  //     '614aff264350728eed060541370810b678d49482bd6f957ce200d93ba18d51b2';
  String rpcUrl = 'http://192.168.0.109:8545';
  // String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  String contractAddress = "0x7B9031a6824a1C2f7757Eb6F4B7507eF60B64495";
  late Client httpClient;
  late Web3Client ethereumClient;
  late EthPrivateKey credentials;

  String contractName = "Voting";

  int voters_count = 0;
  List<dynamic> candidates = [[]];

  String getPublicKey(privateKey_) {
    credentials = EthPrivateKey.fromHex(privateKey_);
    privateKey = privateKey_;
    httpClient = Client();
    ethereumClient = Web3Client(rpcUrl, httpClient);
    publicKey = credentials.address.toString();
    return publicKey;
  }

  void doStorage() async {
    print("doing storage");
    final prefs = await SharedPreferences.getInstance();

    var sk = prefs.getString("sk") ?? "0x0";
    var pk = prefs.getString("pk") ?? "0x0";

    // keys already exists
    if (sk != "0x0" && pk != "0x0") {
      setState(() {
        privateKey = sk;
        publicKey = pk;
        isLoading = false;
      });

      print("All good");
    }

    sk = await generateRandomAddress();
    pk = getPublicKey(sk);

    await prefs.setString("sk", sk);
    await prefs.setString("pk", pk);

    setState(() {
      privateKey = sk;
      publicKey = pk;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // init(privateKey);
    doStorage();
  }

  Future<String> generateRandomAddress() async {
    var rng = Random.secure();
    EthPrivateKey random = EthPrivateKey.createRandom(rng);
    var address = await random.extractAddress();
    String private = bytesToHex(random.privateKey);
    return private;
  }

  Future<void> votersCount() async {
    setState(() {});
    List<dynamic> result = await query('voters_count', []);
    // print(result.length);
    voters_count = int.parse(result[0].toString());
    print(voters_count.toString());
    setState(() {});
  }

  Future<void> getCandidates() async {
    setState(() {});
    List<dynamic> result = await query('getCandidates', []);
    print(result[0]);
    candidates = result[0];
    print(candidates);

    setState(() {});
  }

  Future<DeployedContract> getContract() async {
    String contractJson =
        await rootBundle.loadString("assets/contract/Voting.json");
    var jsonAbi = jsonDecode(contractJson);
    var abi = jsonEncode(jsonAbi['abi']);

    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

  Future<void> submit(String functionName, List<dynamic> args) async {
    // EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await getContract();
    final ethFunction = contract.function(functionName);
    print(credentials.address);
    final result = await ethereumClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );
    print(result);
  }

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
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoutButton,
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () {
                votersCount();
              },
              child: Text("total Voters")),
        ),
        Text(
          voters_count.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
            onPressed: () {
              getCandidates();
            },
            child: Text("total_candidates")),
        Text(
          candidates.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        (candidates[0].isNotEmpty)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: candidates.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: ElevatedButton(
                            onPressed: () {
                              submit(
                                "voteCandidate",
                                [BigInt.from(index)],
                              );
                            },
                            child: Text(candidates[index][0]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : Text("press candidates "),
        // ElevatedButton(
        //     onPressed: () {
        //       generateRandomAddress();
        //     },
        //     child: Text("randomize address")),
        // // Text(
        //   privateKey,
        //   style: TextStyle(fontSize: 10),
        // ),
        Container(
          padding: EdgeInsets.all(3),
          child: QrImage(
            data: publicKey.toString(),
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
        Text(
          publicKey,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
