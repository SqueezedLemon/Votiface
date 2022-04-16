import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import 'package:http/http.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String privateKey =
      '614aff264350728eed060541370810b678d49482bd6f957ce200d93ba18d51b2';
  // String rpcUrl = 'http://192.168.0.109:8545';
  String rpcUrl = 'https://kovan.infura.io/v3/5eddb680b6cf4ea0936f900b9269b4e9';
  String contractAddress = "0x0da0A4EC7333aad77E6630340E0f5B791525f5AE";
  late Client httpClient;
  late Web3Client ethereumClient;
  String contractName = "Voting";

  int voters_count = 0;
  List<dynamic> candidates = [[]];

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethereumClient = Web3Client(rpcUrl, httpClient);
  }

  Future<void> votersCount() async {
    setState(() {});
    List<dynamic> result = await query('voters_count', []);
    print(result.length);
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
    String abi = await rootBundle.loadString("assets/abi.json");

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
      ],
    );
  }
}
