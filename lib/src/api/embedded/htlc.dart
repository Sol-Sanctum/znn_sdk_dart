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
  Future<HtlcInfo> getHtlcInfoById(Hash id) async {
    var response = await client
        .sendRequest('embedded.htlc.getHtlcInfoById', [id.toString()]);
    return HtlcInfo.fromJson(response!);
  }

  Future<HtlcInfoList> getHtlcInfosByTimeLockedAddress(Address address, {int pageIndex = 0, int pageSize = rpcMaxPageSize}) async {
    var response = await client
        .sendRequest('embedded.htlc.getHtlcInfosByTimeLockedAddress', [address.toString(), pageIndex, pageSize]);
    return HtlcInfoList.fromJson(response!);
  }

  Future<HtlcInfoList> getHtlcInfosByHashLockedAddress(Address address, {int pageIndex = 0, int pageSize = rpcMaxPageSize}) async {
    var response = await client
        .sendRequest('embedded.htlc.getHtlcInfosByHashLockedAddress', [address.toString(), pageIndex, pageSize]);
    return HtlcInfoList.fromJson(response!);
  }

  // Contract methods
  AccountBlockTemplate create(Token token, int? amount, Address hashLocked, int expirationTime, int hashType, int keyMaxSize, List<int>? hashLock) {
    return AccountBlockTemplate.callContract(
        htlcAddress,
        token.tokenStandard,
        amount!,
        Definitions.htlc.encodeFunction('CreateHtlc', [
          hashLocked,
          expirationTime,
          hashType,
          keyMaxSize,
          hashLock]));
  }

  AccountBlockTemplate reclaim(Hash id) {
    return AccountBlockTemplate.callContract(htlcAddress, znnZts, 0,
        Definitions.htlc.encodeFunction('ReclaimHtlc', [id.getBytes()]));
  }

  AccountBlockTemplate unlock(Hash id, List<int>? preimage) {
    return AccountBlockTemplate.callContract(htlcAddress, znnZts, 0,
        Definitions.htlc.encodeFunction('UnlockHtlc', [id.getBytes(), preimage]));
  }
}