import 'package:znn_sdk_dart/src/api/embedded/accelerator.dart';
import 'package:znn_sdk_dart/src/api/embedded/htlc.dart';
import 'package:znn_sdk_dart/src/api/embedded/spork.dart';
import 'package:znn_sdk_dart/src/api/embedded/pillar.dart';
import 'package:znn_sdk_dart/src/api/embedded/plasma.dart';
import 'package:znn_sdk_dart/src/api/embedded/sentinel.dart';
import 'package:znn_sdk_dart/src/api/embedded/stake.dart';
import 'package:znn_sdk_dart/src/api/embedded/swap.dart';
import 'package:znn_sdk_dart/src/api/embedded/token.dart';
import 'package:znn_sdk_dart/src/client/client.dart';

class EmbeddedApi {
  late Client client;

  late PillarApi pillar;
  late PlasmaApi plasma;
  late SentinelApi sentinel;
  late StakeApi stake;
  late SwapApi swap;
  late TokenApi token;
  late AcceleratorApi accelerator;
  late SporkApi spork;
  late HtlcApi htlc;

  void setClient(Client client) {
    this.client = client;
    pillar.setClient(client);
    plasma.setClient(client);
    sentinel.setClient(client);
    stake.setClient(client);
    swap.setClient(client);
    token.setClient(client);
    accelerator.setClient(client);
    spork.setClient(client);
    htlc.setClient(client);
  }

  EmbeddedApi() {
    pillar = PillarApi();
    plasma = PlasmaApi();
    sentinel = SentinelApi();
    stake = StakeApi();
    swap = SwapApi();
    token = TokenApi();
    accelerator = AcceleratorApi();
    spork = SporkApi();
    htlc = HtlcApi();
  }
}
