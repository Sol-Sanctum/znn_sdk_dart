// For testing, may not keep this

import 'dart:convert';

import 'package:znn_sdk_dart/znn_sdk_dart.dart';
import 'dart:async';
import 'dart:io';

var node =
    "wss://my.hc1node.com:35998"; // "ws://127.0.0.1:35998"; // wss://my.hc1node.com:35998
final Zenon znnClient = Zenon();
int keyStore = 0;
String pass = "Pass-123456";
Address admin = Address.parse('z1qz8q0x3rs36z2kw8eltf8r323hlcn64jnujkuz');
//Address test = Address.parse('z1qr3uww8uqh75qnsuxqajegvwaesqynfglrare2');
TokenStandard zoge = TokenStandard.parse('zts1q5u994j2hq3lxt9tr6t3z2');
/*
TokenStandard tokenStandard1 =
    TokenStandard.parse('zts18m5mghyssfs9445eu5wzya'); // ZTS1, balance 1000000
TokenStandard tokenStandard2 =
    TokenStandard.parse('zts1nteqs92qrwj06tddmkqh86'); // ZTS2
TokenStandard tokenStandard3 =
    TokenStandard.parse('zts1p4ry2fpf69gzf0zeu83ndq'); // ZTS3
*/
String mrkaineZnn = 'z1qpxswrfnlll355wrx868xh58j7e2gu2n2u5czv';
String mrkaineEth = '0xb13857a4F3bc3b8AB205e06FD8b874692451ADc0';

//String tssPubKey = "AsAQx1M3LVXCuozDOqO5b9adj/PItYgwZFG/xTDBiZzT"; // I don't know how this is generated
String tssPubKey =
    "AnecDxNfn2FeJroQeBxjnW1Jcdc/o+xPyTGTRfxcUcHy"; // for testnet bridge?
String tssPrivKey =
    "tuSwrTEUyJI1/3y5J8L8DSjzT/AQG2IK3JG+93qhhhI="; // Found in go-zenon z_bridge_test.go

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

  await bridgeAllGetFunctions();
  //await bridgeTest();

  znnClient.wsClient.stop();
}

Future<void> bridgeAllGetFunctions() async {
  SecurityInfo getSecurityInfo =
      await znnClient.embedded.bridge.getSecurityInfo();
  print("getSecurityInfo()");
  print(getSecurityInfo.toJson());
  print("--------------");

  TimeChallengesList getTimeChallengesInfo =
      await znnClient.embedded.bridge.getTimeChallengesInfo();
  print("getTimeChallengesInfo()");
  print(getTimeChallengesInfo.toJson());
  print("--------------");

  BridgeInfo getBridgeInfo = await znnClient.embedded.bridge.getBridgeInfo();
  print("getBridgeInfo()");
  print(getBridgeInfo.toJson());
  print("--------------");

  OrchestratorInfo getOrchestratorInfo =
      await znnClient.embedded.bridge.getOrchestratorInfo();
  print("getOrchestratorInfo()");
  print(getOrchestratorInfo.toJson());
  print("--------------");

  BridgeNetworkInfo getNetworkInfo =
      await znnClient.embedded.bridge.getNetworkInfo(1, 1);
  print("getNetworkInfo()");
  print(getNetworkInfo.toJson());
  print("--------------");

  BridgeNetworkInfoList getAllNetworks =
      await znnClient.embedded.bridge.getAllNetworks();
  print("getAllNetworks()");
  print(getAllNetworks.toJson());
  print("--------------");

  /// example value on mainnet: {networkClass: 2, chainId: 1, id: 395726d33f6b2b0fa794490af1996f640d2c691ac3ad0187fbf0bb0eb94a79c3, toAddress: 0xfd9a7faa2e7f55111be2298e7baddced65f5384a, tokenStandard: zts1znnxxxxxxxxxxxxx9z4ulx, tokenAddress: 0xb2e96a63479c2edd2fd62b382c89d5ca79f572d3, amount: 90000000000, fee: 2700000000, signature: LBD6yJA8pJG1jn1cManSd5ZBxjHpZq7AFTqg/JQ6KdgTsIgAHaF23iJtQWjKZXwel262gXA7FyuTN/+1SziOEAA=, creationMomentumHeight: 4596286}
  try {
    print("getWrapTokenRequestById()");
    WrapTokenRequest getWrapTokenRequestById = await znnClient.embedded.bridge
        .getWrapTokenRequestById(Hash.parse(
            '395726d33f6b2b0fa794490af1996f640d2c691ac3ad0187fbf0bb0eb94a79c3'));
    print(getWrapTokenRequestById.toJson());
  } catch (e) {
    print(e);
  }
  print("--------------");

  WrapTokenRequestList getAllWrapTokenRequests =
      await znnClient.embedded.bridge.getAllWrapTokenRequests();
  print("getAllWrapTokenRequests()");
  print(getAllWrapTokenRequests.toJson());
  print("--------------");

  /// example value on mainnet: 0x44986ea5beb006f81909cc72613648b1eac0aa0b
  print("getAllWrapTokenRequestsByToAddress()");
  WrapTokenRequestList getAllWrapTokenRequestsByToAddress =
      await znnClient.embedded.bridge.getAllWrapTokenRequestsByToAddress(
          '0x44986ea5beb006f81909cc72613648b1eac0aa0b');
  print(getAllWrapTokenRequestsByToAddress.toJson());
  print("--------------");

  print("getAllWrapTokenRequestsByToAddressNetworkClassAndChainId()");
  WrapTokenRequestList
      getAllWrapTokenRequestsByToAddressNetworkClassAndChainId = await znnClient
          .embedded.bridge
          .getAllWrapTokenRequestsByToAddressNetworkClassAndChainId(
              '0x44986ea5beb006f81909cc72613648b1eac0aa0b', 2, 1);
  print(getAllWrapTokenRequestsByToAddressNetworkClassAndChainId.toJson());
  print("--------------");

  print("getAllUnsignedWrapTokenRequests()");
  WrapTokenRequestList getAllUnsignedWrapTokenRequests =
      await znnClient.embedded.bridge.getAllUnsignedWrapTokenRequests();
  print(getAllUnsignedWrapTokenRequests.toJson());
  print("--------------");

  /// example value on mainnet: {registrationMomentumHeight: 4543372, networkClass: 2, chainId: 1, transactionHash: 00149ed5a387f0d8abdb21bd20e334d6d3b046fca08081925f8e34fa3c13534d, logIndex: 74, toAddress: z1qr9vtwsfr2n0nsxl2nfh6l5esqjh2wfj85cfq9, tokenAddress: 0xb2e96a63479c2edd2fd62b382c89d5ca79f572d3, tokenStandard: zts1znnxxxxxxxxxxxxx9z4ulx, amount: 485000000, signature: QPQwxC20ItxXJySGrR+PJMEvv3YbeOaD5tpSAxMAigdtnTT/WBx6HlCTxExmmFcVZGtH/misEDRIQ9QyREVqQQA=, redeemed: 1, revoked: 0}
  try {
    print("getUnwrapTokenRequestByHashAndLog()");
    UnwrapTokenRequest getUnwrapTokenRequestByHashAndLog =
        await znnClient.embedded.bridge.getUnwrapTokenRequestByHashAndLog(
            Hash.parse(
                '00149ed5a387f0d8abdb21bd20e334d6d3b046fca08081925f8e34fa3c13534d'),
            74);
    print(getUnwrapTokenRequestByHashAndLog.toJson());
  } catch (e) {
    print(e);
  }
  print("--------------");

  print("getAllUnwrapTokenRequests()");
  UnwrapTokenRequestList getAllUnwrapTokenRequests =
      await znnClient.embedded.bridge.getAllUnwrapTokenRequests();
  print(getAllUnwrapTokenRequests.toJson());
  print("--------------");

  print("getAllUnwrapTokenRequestsByToAddress()");
  UnwrapTokenRequestList getAllUnwrapTokenRequestsByToAddress =
      await znnClient.embedded.bridge.getAllUnwrapTokenRequestsByToAddress(
          'z1qr9vtwsfr2n0nsxl2nfh6l5esqjh2wfj85cfq9');
  print(getAllUnwrapTokenRequestsByToAddress.toJson());
  print("--------------");

  print("getFeeTokenPair()");
  ZtsFeesInfo getFeeTokenPair =
      await znnClient.embedded.bridge.getFeeTokenPair(znnZts);
  print(getFeeTokenPair.toJson());
  print("--------------");
}

Future<void> bridgeTest() async {
  /// Response: JSON-RPC error -32000: method not found in the abi
  print("setRedeemDelay()");
  AccountBlockTemplate setRedeemDelay =
      znnClient.embedded.bridge.setRedeemDelay(91);
  setRedeemDelay = await znnClient.send(setRedeemDelay);
  print(setRedeemDelay.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/2d4e250a003d80cff256d3351bb219b93903838e4bb14974cea4636df26f63ae
  print("wrapToken()");
  AccountBlockTemplate wrapToken =
      znnClient.embedded.bridge.wrapToken(2, 1, mrkaineEth, BigInt.one, znnZts);
  wrapToken = await znnClient.send(wrapToken);
  print(wrapToken.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/88405daf9776da7b2e280bebef0a8561c57e38ddb7a7d9a2648c18138a6f659f
  // No errors, nothing changed?
  print("updateWrapRequest()");
  AccountBlockTemplate updateWrapRequest = znnClient.embedded.bridge
      .updateWrapRequest(
          Hash.parse(
              'a874c389e6b5a0773bcac084b4f75ca7fdf9239beed01be661e8b8374f2fd665'),
          "MJJIM7BYaNy/IgIC+laMnR4GDUw6dDw+lPTqziEKT+cBJSvZgshmB4kuK04uKr4oGKExQpSucqEjxqX8uYdPKwA=");
  updateWrapRequest = await znnClient.send(updateWrapRequest);
  print(updateWrapRequest.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/e47b5de444867049a0a577f0325103f356755ea9874675f36224358a79eee5c8
  // No errors, nothing changed?
  print("halt()");
  AccountBlockTemplate halt = znnClient.embedded.bridge.halt(
      "MJJIM7BYaNy/IgIC+laMnR4GDUw6dDw+lPTqziEKT+cBJSvZgshmB4kuK04uKr4oGKExQpSucqEjxqX8uYdPKwA=");
  halt = await znnClient.send(halt);
  print(halt.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/388e04a25385310b905026994d18ce184b2103e372061e5d1badaa0376b30aaf
  // No errors, nothing changed?
  print("changeTssECDSAPubKey()");
  AccountBlockTemplate changeTssECDSAPubKey = znnClient.embedded.bridge
      .changeTssECDSAPubKey(
          tssPubKey,
          "BEOdWOPxouaEsVRo3Sd7+Bz0Zj8El75oB7Xv6P0ic63jMW0Z+AXoHgsTEOMnOKqGVtci4fJw7Sx+1CiV1RFKp2c=",
          "AsAQx1M3LVXCuozDOqO5b9adj/PItYgwZFG/xTDBiZzT");
  changeTssECDSAPubKey = await znnClient.send(changeTssECDSAPubKey);
  print(changeTssECDSAPubKey.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/e28082f2c6b007f54b7e2e0500a5b50d5063763aa4c49acf82a2a2e5294ad455
  // No errors, nothing changed?
  print("redeem()");
  AccountBlockTemplate redeem = znnClient.embedded.bridge.redeem(
      Hash.parse(
          '74086e54338b0e0ac5c26c9852dc9de05559143bd4e5de757c2fb26b823e7d1c'),
      241);
  redeem = await znnClient.send(redeem);
  print(redeem.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/6f45d4f97f32a7b31c1c534a6da16cabca4f6eecce3e67ce667d857720635a84
  // No errors, nothing changed?
  print("unwrapToken()");
  AccountBlockTemplate unwrapToken = znnClient.embedded.bridge.unwrapToken(
    2,
    1,
    Hash.parse(
        '00149ed5a387f0d8abdb21bd20e334d6d3b046fca08081925f8e34fa3c13534d'),
    74,
    Address.parse('z1qz8q0x3rs36z2kw8eltf8r323hlcn64jnujkuz'),
    "0xa98706106f7710d743186031be2245f33acea106",
    BigInt.parse('485000000'),
    "QPQwxC20ItxXJySGrR+PJMEvv3YbeOaD5tpSAxMAigdtnTT/WBx6HlCTxExmmFcVZGtH/misEDRIQ9QyREVqQQA=",
  );
  unwrapToken = await znnClient.send(unwrapToken);
  print(unwrapToken.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/1697c9b69dee21980afef6fe0b086fc55745e3190f54f58c5dcadbe2ca406031
  // No errors, nothing changed?
  print("proposeAdministrator()");
  AccountBlockTemplate proposeAdministrator = znnClient.embedded.bridge
      .proposeAdministrator(
          Address.parse('z1qz8q0x3rs36z2kw8eltf8r323hlcn64jnujkuz'));
  proposeAdministrator = await znnClient.send(proposeAdministrator);
  print(proposeAdministrator.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/0e56ff5e786c2b295343edf5ca22f73dae69260fb2f7ef2a6f7a5903b23a9d98
  // No errors, nothing changed?
  print("setNetwork()");
  AccountBlockTemplate setNetwork = znnClient.embedded.bridge.setNetwork(
    321,
    321,
    "TEST",
    "0xa98706106f7710d743186031be2245f33acea106",
    '{"Data": "Don\'t trust. Verify."}',
  );
  setNetwork = await znnClient.send(setNetwork);
  print(setNetwork.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/ce6afaad86c74018427c56ce67b41c8d8c8b1de1fe548b90c7c39c970c5f7da7
  // No errors, nothing changed?
  print("removeNetwork()");
  AccountBlockTemplate removeNetwork =
      znnClient.embedded.bridge.removeNetwork(321, 0);
  removeNetwork = await znnClient.send(removeNetwork);
  print(removeNetwork.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/b2b7421bdad0876398d2fd15d434d8c506e00b96b09e169dcc17d1902abbc579
  // No errors, nothing changed?
  print("setTokenPair()");
  AccountBlockTemplate setTokenPair = znnClient.embedded.bridge.setTokenPair(
    2,
    1,
    qsrZts,
    "0xa98706106f7710d743186031be2245f33acea106",
    true,
    true,
    false,
    BigInt.parse("100000000"),
    300,
    90,
    '{"Data": "Don\'t trust. Verify."}',
  );
  setTokenPair = await znnClient.send(setTokenPair);
  print(setTokenPair.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/efe9918311af04623e5b25c7f1dc0821c1c826c3db849d5f723d08766b6ab226
  // No errors, nothing changed?
  print("setNetworkMetadata()");
  AccountBlockTemplate setNetworkMetadata =
      znnClient.embedded.bridge.setNetworkMetadata(
    2,
    1,
    '{"Data": "Don\'t trust. Verify. <3"}',
  );
  setNetworkMetadata = await znnClient.send(setNetworkMetadata);
  print(setNetworkMetadata.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/732a495642c6e617c4c35aace7d25bcf0e3cbea0cccbde4530ffc8ff8e9b9e34
  // No errors, nothing changed?
  print("removeTokenPair()");
  AccountBlockTemplate removeTokenPair = znnClient.embedded.bridge
      .removeTokenPair(
          321, 0, zoge, "0xa98706106f7710d743186031be2245f33acea106");
  removeTokenPair = await znnClient.send(removeTokenPair);
  print(removeTokenPair.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/3f5831f0f10ef1ab048eb5f860214b589ff82e32a801946d8929cde01026b217
  // No errors, nothing changed?
  print("unhalt()");
  AccountBlockTemplate unhalt = znnClient.embedded.bridge.unhalt();
  unhalt = await znnClient.send(unhalt);
  print(unhalt.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/939f4ed4e647a08254cd777632d52e6ce2357f3d07d0bd58656c8fcf7ccdfbad
  // No errors, nothing changed?
  print("emergency()");
  AccountBlockTemplate emergency = znnClient.embedded.bridge.emergency();
  emergency = await znnClient.send(emergency);
  print(emergency.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/85ec518635287bf2adef09f95776936ad39637310934975623c858faba9f831f
  // No errors, nothing changed?
  print("changeAdministrator()");
  AccountBlockTemplate changeAdministrator = znnClient.embedded.bridge
      .changeAdministrator(
          Address.parse('z1qz8q0x3rs36z2kw8eltf8r323hlcn64jnujkuz'));
  changeAdministrator = await znnClient.send(changeAdministrator);
  print(changeAdministrator.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/1cff5978de2cc0ea39c3e5db54fe5e7339dc279c2de03a2ecb3db9540a53a60c
  // No errors, nothing changed?
  print("setAllowKeyGen()");
  AccountBlockTemplate setAllowKeyGen =
      znnClient.embedded.bridge.setAllowKeyGen(true);
  setAllowKeyGen = await znnClient.send(setAllowKeyGen);
  print(setAllowKeyGen.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/a22aee2518a20e745b6ea62af60d29053f79d4a8ebbd50a7b9cae01052b0716c
  // No errors, nothing changed?
  print("setBridgeMetadata()");
  AccountBlockTemplate setBridgeMetadata = znnClient.embedded.bridge
      .setBridgeMetadata('{"Data": "Don\'t trust. Verify."}');
  setBridgeMetadata = await znnClient.send(setBridgeMetadata);
  print(setBridgeMetadata.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/75f0fff12b4862adf227e3e25561e3b75d9cd890a0537e826db7b40a87efa126
  // No errors, nothing changed?
  print("revokeUnwrapRequest()");
  AccountBlockTemplate revokeUnwrapRequest = znnClient.embedded.bridge
      .revokeUnwrapRequest(
          Hash.parse(
              '74086e54338b0e0ac5c26c9852dc9de05559143bd4e5de757c2fb26b823e7d1c'),
          241);
  revokeUnwrapRequest = await znnClient.send(revokeUnwrapRequest);
  print(revokeUnwrapRequest.toJson());
  print("--------------");

  // Confirmation:
  // No errors, nothing changed?
  print("nominateGuardians()");
  AccountBlockTemplate nominateGuardians =
      znnClient.embedded.bridge.nominateGuardians([
    Address.parse('z1qz8q0x3rs36z2kw8eltf8r323hlcn64jnujkuz'),
    Address.parse(mrkaineZnn),
    Address.parse(mrkaineZnn),
    Address.parse(mrkaineZnn),
    Address.parse(mrkaineZnn),
  ]);
  nominateGuardians = await znnClient.send(nominateGuardians);
  print(nominateGuardians.toJson());
  print("--------------");

  // Confirmation: https://zenonhub.io/explorer/transaction/2d6b5440493b095c0b85e9cb482540a6639cdfe82db8c8e6b8be895b6049dfbf
  // No errors, nothing changed?
  print("setOrchestratorInfo()");
  AccountBlockTemplate setOrchestratorInfo =
      znnClient.embedded.bridge.setOrchestratorInfo(10, 10, 10, 10);
  setOrchestratorInfo = await znnClient.send(setOrchestratorInfo);
  print(setOrchestratorInfo.toJson());
  print("--------------");
}
