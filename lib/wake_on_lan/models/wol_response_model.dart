// Package imports:
import 'package:wake_on_lan/wake_on_lan.dart';

// Project imports:
import 'package:network_arch/utils/enums.dart';

class WolResponse {
  WolResponse(this.ipv4, this.mac, this.packetBytes, this.status);

  final IPv4Address ipv4;
  final MACAddress mac;
  final List<int> packetBytes;
  final WolStatus status;
}