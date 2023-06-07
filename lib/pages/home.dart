
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/pages/election_info.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Client? httpClient;
  late Web3Client ethClient;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Election'),
      ),
        body: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter election name'
                ),
              ),
              const SizedBox(height: 50,),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(onPressed: () async {
                  if(textEditingController.text.isNotEmpty) {
                    await startElection(textEditingController.text, ethClient);
                  }
                  
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionInfo(ethClient: ethClient, electionName: textEditingController.text)));
                }, child:
                  const Text('Start Election'),
                ),
              )
            ],
          ),
        ),
    );
  }
}
