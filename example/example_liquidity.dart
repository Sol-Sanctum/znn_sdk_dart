// For testing, may not keep this

import 'package:znn_sdk_dart/znn_sdk_dart.dart';
import 'dart:async';
import 'dart:io';

var node = "wss://my.hc1node.com:35998";
final Zenon znnClient = Zenon();
int keyStore = 0;
String pass = "Pass-123456";
Address admin = Address.parse('z1qz8q0x3rs36z2kw8eltf8r323hlcn64jnujkuz');
TokenStandard zoge = TokenStandard.parse('zts1q5u994j2hq3lxt9tr6t3z2');

Address exampleAddress =
    Address.parse('z1qppk2p26xwwzu5w4zyzwknrx28whvjgy9ukc6h');

Future<void> main() async {
  await znnClient.wsClient.initialize(node, retry: false);
  await znnClient.ledger.getFrontierMomentum().then((value) {
    chainId = value.chainIdentifier.toInt();
  });

  List<File> allKeyStores = await znnClient.keyStoreManager.listAllKeyStores();
  File keyStoreFile = allKeyStores[keyStore];

  znnClient.defaultKeyStore =
      await znnClient.keyStoreManager.readKeyStore(pass, keyStoreFile);
  znnClient.defaultKeyStorePath = keyStoreFile;
  znnClient.defaultKeyPair = znnClient.defaultKeyStore!.getKeyPair(0);
  Address address = (await znnClient.defaultKeyPair!.address)!;
  print("Unlocked: ${address.toString()}");
  print("--------------");

  await liquidityAllGetFunctions(address);
  //await liquidityTest(address);

  znnClient.wsClient.stop();
}

Future<void> liquidityAllGetFunctions(Address address) async {
  print("getLiquidityInfo()");
  LiquidityInfo getLiquidityInfo =
      await znnClient.embedded.liquidity.getLiquidityInfo();
  print(getLiquidityInfo.toJson());
  for (TokenTuple tuple in getLiquidityInfo.tokenTuples) {
    print("   ${tuple.toJson()}");
  }
  print("--------------");

  print("getSecurityInfo()");
  SecurityInfo getSecurityInfo =
      await znnClient.embedded.liquidity.getSecurityInfo();
  print(getSecurityInfo.toJson());
  print("--------------");

  print("getLiquidityStakeEntriesByAddress()");
  LiquidityStakeList getLiquidityStakeEntriesByAddress = await znnClient
      .embedded.liquidity
      .getLiquidityStakeEntriesByAddress(exampleAddress);
  print(getLiquidityStakeEntriesByAddress.toJson());
  print("--------------");

  print("getUncollectedReward()");
  RewardDeposit getUncollectedReward =
      await znnClient.embedded.liquidity.getUncollectedReward(exampleAddress);
  print(getUncollectedReward.toJson());
  print("--------------");

  print("getFrontierRewardByPage()");
  RewardHistoryList getFrontierRewardByPage = await znnClient.embedded.liquidity
      .getFrontierRewardByPage(exampleAddress);
  print(getFrontierRewardByPage.toJson());
  print("--------------");

  print("getTimeChallengesInfo()");
  TimeChallengesList getTimeChallengesInfo =
      await znnClient.embedded.liquidity.getTimeChallengesInfo();
  print(getTimeChallengesInfo.toJson());
  print("--------------");
}

Future<void> liquidityTest(Address address) async {
  /*
  /// Error: JSON-RPC error -32000: address cannot call this method
  /// Requires: SporkAddress
  // Confirmation:
  print("fund()");
  AccountBlockTemplate fund =
      znnClient.embedded.liquidity.fund(BigInt.one, BigInt.one);
  fund = await znnClient.send(fund);
  print(fund.toJson());
  print("--------------");

  /// Error: JSON-RPC error -32000: address cannot call this method
  /// Requires: SporkAddress
  // Confirmation:
  print("burnZnn()");
  AccountBlockTemplate burnZnn =
      znnClient.embedded.liquidity.burnZnn(BigInt.one);
  //burnZnn = await znnClient.send(burnZnn);
  print(burnZnn.toJson());
  print("--------------");
   */

  TokenStandard tokenStandard1 = TokenStandard.parse(
      'zts18m5mghyssfs9445eu5wzya'); // ZTS1, balance 1000000
  TokenStandard tokenStandard2 =
      TokenStandard.parse('zts1nteqs92qrwj06tddmkqh86'); // ZTS2
  TokenStandard tokenStandard3 =
      TokenStandard.parse('zts1p4ry2fpf69gzf0zeu83ndq'); // ZTS3

  List<String> tokenStandards = [
    tokenStandard1.toString(),
    tokenStandard2.toString(),
    tokenStandard3.toString()
  ];
  List<int> znnPercentages = [5000, 2500, 2500];
  List<int> qsrPercentages = [5000, 2500, 2500];
  List<int> minAmounts = [1, 100, 10];

  /// ABI ERROR: type 'double' is not a subtype of type 'int' in type cast
  /// Issue on line 97 of /lib/src/abi/abi_types -> "as int" when the value evaluates as a double
  /// We can floor() or ceiling() the value but it won't produce the right result
  ///   -> JSON-RPC error -32000: invalid unpack method data
  // Confirmation:
  print("setTokenTuple()");
  AccountBlockTemplate setTokenTuple = znnClient.embedded.liquidity
      .setTokenTuple(
          tokenStandards, znnPercentages, qsrPercentages, minAmounts);
  print(setTokenTuple.toJson());
  setTokenTuple = await znnClient.send(setTokenTuple);
  print(setTokenTuple.toJson());
  print("--------------");

  /*
  // Confirmation: https://zenonhub.io/explorer/transaction/0bb5c3df37320cf6355f9113f9a7e7d18e023b2669253eb400abf9078ba4974c
  print("liquidityStake()");
  AccountBlockTemplate liquidityStake = znnClient.embedded.liquidity
      .liquidityStake(30 * 24 * 60 * 60, BigInt.one, znnZts);
  liquidityStake = await znnClient.send(liquidityStake);
  print(liquidityStake.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/2f1d5e6be03329132aef19f57baf5b7e3d5a1781db76b72982645d3a900db7b6
  print("cancelLiquidityStake()");
  AccountBlockTemplate cancelLiquidityStake = znnClient.embedded.liquidity
      .cancelLiquidityStake(Hash.parse(
          'adbd7e19d101c0d90dbbb5ac7298bcae3cc0760b8fc970598edffdd336523892'));
  cancelLiquidityStake = await znnClient.send(cancelLiquidityStake);
  print(cancelLiquidityStake.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/f0c4668a140f9dd932d18b359a125b2525060d8dd192945240b5ece15c70c962
  print("unlockLiquidityStakeEntries()");
  AccountBlockTemplate unlockLiquidityStakeEntries =
      znnClient.embedded.liquidity.unlockLiquidityStakeEntries(
          TokenStandard.parse('zts17d6yr02kh0r9qr566p7tg6'));
  unlockLiquidityStakeEntries =
      await znnClient.send(unlockLiquidityStakeEntries);
  print(unlockLiquidityStakeEntries.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/881e60a30cf22e0dc3fb1e0d772e272758a296b4ebd59a8bb2ad5bb53d4522f8
  print("setAdditionalReward()");
  AccountBlockTemplate setAdditionalReward = znnClient.embedded.liquidity
      .setAdditionalReward(10000000000, 50000000000);
  setAdditionalReward = await znnClient.send(setAdditionalReward);
  print(setAdditionalReward.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/03ed2354c88ab1ca7a859b04a20fc114137aed1a58a875878d428d6954b66e5d
  print("nominateGuardians()");
  AccountBlockTemplate nominateGuardians = znnClient.embedded.liquidity
      .nominateGuardians([admin, address, address, address, address]);
  nominateGuardians = await znnClient.send(nominateGuardians);
  print(nominateGuardians.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/61e57839d032f2ace65a20a60383c6a3020067e141316ab1ede302b2f78fc4d8
  print("proposeAdministrator()");
  AccountBlockTemplate proposeAdministrator =
      znnClient.embedded.liquidity.proposeAdministrator(admin);
  proposeAdministrator = await znnClient.send(proposeAdministrator);
  print(proposeAdministrator.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/c2cf0c16e3cc28b0a8ea95a25d0eba653f81b0d52a937c25632dc768cf646f93
  print("setIsHalted()");
  AccountBlockTemplate setIsHalted =
      znnClient.embedded.liquidity.setIsHalted(true);
  setIsHalted = await znnClient.send(setIsHalted);
  print(setIsHalted.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/b362c46c32fe1d61cad6346a0c6795b49bfcf473f06532ca0e065a7b337e919b
  print("changeAdministrator()");
  AccountBlockTemplate changeAdministrator =
      znnClient.embedded.liquidity.changeAdministrator(admin);
  changeAdministrator = await znnClient.send(changeAdministrator);
  print(changeAdministrator.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/05a3591b2e6519c6be2402e7a43ff57e7bc69e4d21f6ab69fb43151a7513a702
  print("update()");
  AccountBlockTemplate update = znnClient.embedded.liquidity.update();
  update = await znnClient.send(update);
  print(update.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/688d51d9df07bda0cd6da6a9fbb6e12a77b0824defd7d7907ac4f9fa86dc71a9
  print("donate()");
  AccountBlockTemplate donate =
      znnClient.embedded.liquidity.donate(BigInt.one, znnZts);
  donate = await znnClient.send(donate);
  print(donate.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/8b186a1df68d05c34be5b80469d99f874337d6d420b4da8b9681c6fabf89ea83
  print("collectReward()");
  AccountBlockTemplate collectReward =
      znnClient.embedded.liquidity.collectReward();
  collectReward = await znnClient.send(collectReward);
  print(collectReward.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/8a98e4f362b60f844bd5ead5b87738c204ad425e139eaea4282e69a3cce60a0e
  print("emergency()");
  AccountBlockTemplate emergency = znnClient.embedded.liquidity.emergency();
  emergency = await znnClient.send(emergency);
  print(emergency.toJson());
  print("--------------");
   */
}
