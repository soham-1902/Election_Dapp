import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract () async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'), EthereumAddress.fromHex(contractAddress));
  
  return contract;
}

Future<String> callFunction(String functionName, List<dynamic> args, Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  
  final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethFunction, parameters: args), chainId: null, fetchChainIdFromNetworkId: true);

  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response = await callFunction('startElection', [name], ethClient, ownerPrivateKey);

  if (kDebugMode) {
    print('Election Started!');
  }

  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response = await callFunction('addCandidate', [name], ethClient, ownerPrivateKey);

  if (kDebugMode) {
    print('Candidate Added!');
  }

  return response;
}

Future<String> authorizeVoter(String voterAddress, Web3Client ethClient) async {
  var response = await callFunction('authorizeVoter', [EthereumAddress.fromHex(voterAddress)], ethClient, ownerPrivateKey);

  if (kDebugMode) {
    print('Voter Authorized!');
  }

  return response;
}

Future<List> getCandidateCount(Web3Client ethClient) async {
  List<dynamic> result = await ask('getCandidates', [], ethClient);
  
  return result;
}

Future<List<dynamic>> ask(String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result = ethClient.call(contract: contract, function: ethFunction, params: args);
  
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response = await callFunction('vote', [BigInt.from(candidateIndex)], ethClient, voterPrivateKey);

  if (kDebugMode) {
    print('Vote Counted!');
  }

  return response;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
    List<dynamic> result = await ask('getTotalVotes', [], ethClient);
    return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result = await ask('candidateInfo', [BigInt.from(index)], ethClient);
  return result;
}
