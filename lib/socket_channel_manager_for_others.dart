import 'package:flutter_platform_experiment/socket_channel_manager.dart';
import 'package:web_socket_channel/io.dart';

class SocketChannelManagerForOthers extends SocketChannelManager {
  @override
  connect(url) {
    return IOWebSocketChannel.connect(url);
  }
}

SocketChannelManager getManager() => SocketChannelManagerForOthers();

