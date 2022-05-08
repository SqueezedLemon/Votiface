import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:votiface/services/blockchain/blockchain.dart';
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
  // String privateKey =
  //     'e90415fb148e28b92a5024c27e6ca008cd05c8e0f01c723f02c44ae590380f32';
  // // String privateKey =
  // //     '614aff264350728eed060541370810b678d49482bd6f957ce200d93ba18d51b2';
  // // String rpcUrl = 'http://192.168.17.113:8545';
  // String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  // String contractAddress = "0x910C23D26b8Ab871a6c8c3570aBB0D2d381e3726";
  // late Client httpClient;
  // late Web3Client ethereumClient;
  late EthPrivateKey credentials;
  String publicKey = "";
  // String contractName = "Voting";
  late BlockChain bc;
  // int voters_count = 0;
  List<dynamic> candidates = [[]];

  // castVote() async{

  //   String privateKey =
  //     '6d78569f54898fec4b76ec3835ab0408c0b3bd1fa7e9f81436bf78ecec9a92df';

  //   String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  //   String contractAddress = "0x910C23D26b8Ab871a6c8c3570aBB0D2d381e3726";
  //   late Client httpClient;
  //   late Web3Client ethereumClient;
  //   late EthPrivateKey credentials;

  //   String publicKey = "";
  //   String contractName = "Voting";

  //   credentials = EthPrivateKey.fromHex(privateKey);
  //   httpClient = Client();
  //   ethereumClient = Web3Client(rpcUrl, httpClient);
  //   publicKey = credentials.address.toString().trim();

  //   DeployedContract contract = await getContract();

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

  // void init(privateKey_) {
  //   credentials = EthPrivateKey.fromHex(privateKey_);
  //   privateKey = privateKey_;
  //   httpClient = Client();
  //   ethereumClient = Web3Client(rpcUrl, httpClient);
  //   publicKey = credentials.address.toString().trim();
  //   print(publicKey);
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
  }

  // Future<void> generateRandomAddress() async {
  //   var rng = Random.secure();
  //   EthPrivateKey random = EthPrivateKey.createRandom(rng);
  //   var address = await random.extractAddress();
  //   String private = bytesToHex(random.privateKey);
  //   print(private);
  //   init(private);
  // }

  // Future<void> votersCount() async {
  //   setState(() {});
  //   List<dynamic> result = await query('voters_count', []);
  //   // print(result.length);
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

  // Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
  //   DeployedContract contract = await getContract();
  //   ContractFunction function = contract.function(functionName);
  //   List<dynamic> result = await ethereumClient.call(
  //       contract: contract, function: function, params: args);
  //   return result;
  // }

  // Future<void> submit(String functionName, List<dynamic> args) async {
  //   // EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  //   DeployedContract contract = await getContract();
  //   final ethFunction = contract.function(functionName);
  //   print(credentials.address);
  //   final result = await ethereumClient.sendTransaction(
  //     credentials,
  //     Transaction.callContract(
  //       contract: contract,
  //       function: ethFunction,
  //       parameters: args,
  //     ),
  //     fetchChainIdFromNetworkId: true,
  //     chainId: null,
  //   );
  //   print(result);
  // }

  @override
  Widget build(BuildContext context) {
    bc = Provider.of<BlockChain>(context, listen: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () {
                bc.votersCount();
              },
              child: Text("total Voters")),
        ),
        Text(
          bc.voters_count.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
            onPressed: () {
              bc.getCandidates();
            },
            child: Text("total_candidates")),
        Text(
          bc.candidates.toString(),
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
                              bc.submit(
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
            : Text("press candidates"),
        ElevatedButton(
            onPressed: () {
              bc.generateRandomAddress();
            },
            child: Text("randomize address")),
        Text(
          bc.privateKey,
          style: TextStyle(fontSize: 10),
        ),
        Container(
          padding: EdgeInsets.all(3),
          child: QrImage(
            data: bc.publicKey.toString(),
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
        Text(
          bc.publicKey,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
