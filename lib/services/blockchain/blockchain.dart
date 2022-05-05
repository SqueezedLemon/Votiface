import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'package:http/http.dart';

class BlockChain extends ChangeNotifier {
  String privateKey =
      'e90415fb148e28b92a5024c27e6ca008cd05c8e0f01c723f02c44ae590380f32';
  // String privateKey =
  //     '614aff264350728eed060541370810b678d49482bd6f957ce200d93ba18d51b2';
  // String rpcUrl = 'http://192.168.17.113:8545';
  String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  String contractAddress = "0x910C23D26b8Ab871a6c8c3570aBB0D2d381e3726";
  late Client httpClient;
  late Web3Client ethereumClient;
  late EthPrivateKey credentials;
  String publicKey = "";
  String contractName = "Voting";

  int voters_count = 0;
  List<dynamic> candidates = [[]];

  void init() {
    credentials = EthPrivateKey.fromHex(privateKey);
    privateKey = privateKey;
    httpClient = Client();
    ethereumClient = Web3Client(rpcUrl, httpClient);
    publicKey = credentials.address.toString();
    votersCount();
    getCandidates();
  }

  void votersCount() async {
    List<dynamic> result = await query('voters_count', []);
    // print(result.length);
    voters_count = int.parse(result[0].toString());
  }

  void getCandidates() async {
    List<dynamic> result = await query('getCandidates', []);
    candidates = result[0];
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

  void submit(String functionName, List<dynamic> args) async {
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
}
