import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/blockchain/blockchain.dart';

class EResult extends StatefulWidget {
  const EResult({ Key? key }) : super(key: key);

  @override
  State<EResult> createState() => _EResultState();
}

class _EResultState extends State<EResult> {
  @override
  Widget build(BuildContext context) {
    //  BlockChain bc = await  Provider.of<BlockChain>(context, listen: false);
    //   var winningCandidate =await bc.query("winningCandidate", [bc.userArea]);
    //   var winningParty=await bc.query("winningParty", []);
    //   print(winningParty);
    //   print(winningCandidate);
    return Container(
      child: Center(child:Text('Results'),),
    );
  }
}