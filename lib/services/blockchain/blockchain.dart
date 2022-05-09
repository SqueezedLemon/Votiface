import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:votiface/screens/account/account_screen.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as web3t;

import 'package:http/http.dart';

import '../../model/user_model.dart';

class BlockChain extends ChangeNotifier {
  String privateKey =
      '00a74f50d4de0f74113cb3d5c63d01816f8885171182d8d0007e997959e703768c';
  // String privateKey =
  //     '614aff264350728eed060541370810b678d49482bd6f957ce200d93ba18d51b2';
  String rpcUrl = 'http://192.168.254.102:7545';
  // String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  String contractAddress = "0x533DfF271a15aD7Cf8eD4Af860BDe5a9751e3889";
  late Client httpClient;
  late Web3Client ethereumClient;
  late EthPrivateKey credentials;
  String publicKey = "";
  String contractName = "Voting";
  late List<dynamic> userData;
  int voter_count = 0;
  int party_vote_count = 0;
  int candidate_vote_count = 0;
  List<dynamic> candidates = [[]];
  List<dynamic> parties = [[]];
  late bool has_voted_candidate;
  late bool has_voted_party;
  late BigInt userArea;
  Future<void> init() async{
    credentials = EthPrivateKey.fromHex(privateKey);
    privateKey = privateKey;
    httpClient = Client();
    ethereumClient = Web3Client(rpcUrl, httpClient);
    publicKey = credentials.address.toString();
    await getVoteState();
    userArea = userData[1];
    has_voted_candidate = userData[3];
    has_voted_party = userData[4];
    await getCandidates();
    // await getCandidates(int.parse(userData[1]));

    voterCount();
    candidateVoteCount();
    partyVoteCount();
    getParties();
    
    notifyListeners();
  }

  Future<void> generateRandomAddress() async {
    var rng = Random.secure();
    EthPrivateKey random = EthPrivateKey.createRandom(rng);
    var address = await random.extractAddress();
    privateKey = bytesToHex(random.privateKey);

    init();
    notifyListeners();
  }

  Future<void> getVoteState() async {
    List<dynamic> result =
        await query('voters', [EthereumAddress.fromHex(publicKey)]);
        userData = result;
    print("voter $result");
  }

  void voterCount() async {
    List<dynamic> result = await query('voter_count', []);
    // print(result.length);
    voter_count = int.parse(result[0].toString());
    notifyListeners();
  }

  void partyVoteCount() async {
    List<dynamic> result = await query('party_vote_count', []);
    // print(result.length);
    party_vote_count = int.parse(result[0].toString());
    notifyListeners();
  }

  void candidateVoteCount() async {
    List<dynamic> result = await query('candidate_vote_count', []);
    // print(result.length);
    candidate_vote_count = int.parse(result[0].toString());
    notifyListeners();
  }

  Future<void> getCandidates() async {
    print('call here');
  //  print('fjhsjhfbsjhd $userData[1]}');
    List<dynamic> result = await query('getCandidates', [userArea]);
    candidates = result[0];
    print(candidates);

    notifyListeners();
  }

  void getParties() async {
    List<dynamic> result = await query('getParties', []);
    parties = result[0];
    print(parties);
    notifyListeners();
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

  Future<DeployedContract> getContract() async {
    String contractJson =
        await rootBundle.loadString("assets/blockchain/Voting.json");
    var jsonAbi = jsonDecode(contractJson);
    var abi = jsonEncode(jsonAbi['abi']);

    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  Future<void> submit(String functionName, List<dynamic> args) async {
    // EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await getContract();
    final ethFunction = contract.function(functionName);
    print(credentials.address);
    final result = await ethereumClient.sendTransaction(
      credentials,
      web3t.Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );
    print(result);
  }
}
