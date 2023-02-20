import 'package:znn_sdk_dart/src/client/client.dart';
import 'package:znn_sdk_dart/src/embedded/embedded.dart';
import 'package:znn_sdk_dart/src/model/model.dart';
import 'package:znn_sdk_dart/src/model/primitives.dart';

class HtlcApi {
  late Client client;

  void setClient(Client client) {
    this.client = client;
  }

  // RPC
  Future<HtlcInfo> getById(Hash id) async {
    var response = await client
        .sendRequest('embedded.htlc.getById', [id.toString()]);
    return HtlcInfo.fromJson(response!);
  }

  Future<bool> getProxyUnlockStatus(Address address) async {
    return await client.sendRequest(
        'embedded.htlc.getProxyUnlockStatus', [address.toString()]);
  }

  // Contract methods
  AccountBlockTemplate create(Token token, int? amount, Address hashLocked,
      int expirationTime, int hashType, int keyMaxSize, List<int>? hashLock) {
    return AccountBlockTemplate.callContract(
        htlcAddress,
        token.tokenStandard,
        amount!,
        Definitions.htlc.encodeFunction('Create',
            [hashLocked, expirationTime, hashType, keyMaxSize, hashLock]));
  }

  AccountBlockTemplate reclaim(Hash id) {
    return AccountBlockTemplate.callContract(htlcAddress, znnZts, 0,
        Definitions.htlc.encodeFunction('Reclaim', [id.getBytes()]));
  }

  AccountBlockTemplate unlock(Hash id, List<int>? preimage) {
    return AccountBlockTemplate.callContract(htlcAddress, znnZts, 0,
        Definitions.htlc.encodeFunction('Unlock', [id.getBytes(), preimage]));
  }

  AccountBlockTemplate denyProxy() {
    return AccountBlockTemplate.callContract(htlcAddress, znnZts, 0,
        Definitions.htlc.encodeFunction('DenyProxyUnlock', []));
  }

  AccountBlockTemplate allowProxy() {
    return AccountBlockTemplate.callContract(htlcAddress, znnZts, 0,
        Definitions.htlc.encodeFunction('AllowProxyUnlock', []));
  }
}
