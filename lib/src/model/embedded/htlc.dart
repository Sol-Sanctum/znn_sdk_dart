import 'package:znn_sdk_dart/src/model/primitives.dart';
import 'dart:convert';

class HtlcInfo {
  Hash id;
  Address timeLocked;
  Address hashLocked;
  TokenStandard tokenStandard;
  int amount;
  int expirationTime;
  int hashType;
  int keyMaxSize;
  List<int> hashLock;

  HtlcInfo(
      {required this.id,
      required this.timeLocked,
      required this.hashLocked,
      required this.tokenStandard,
      required this.amount,
      required this.expirationTime,
      required this.hashType,
      required this.keyMaxSize,
      required this.hashLock});

  HtlcInfo.fromJson(Map<String, dynamic> json)
      : id = Hash.parse(json['id']),
        timeLocked = Address.parse(json['timeLocked']),
        hashLocked = Address.parse(json['hashLocked']),
        tokenStandard = TokenStandard.parse(json['tokenStandard']),
        amount = json['amount'],
        expirationTime = json['expirationTime'],
        hashType = json['hashType'],
        keyMaxSize = json['keyMaxSize'],
        hashLock = base64.decode(json['hashLock']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'timeLocked': timeLocked,
        'hashLocked': hashLocked,
        'tokenStandard': tokenStandard,
        'amount': amount,
        'expirationTime': expirationTime,
        'hashType': hashType,
        'keyMaxSize': keyMaxSize,
        'hashLock': hashLock
      };
}
