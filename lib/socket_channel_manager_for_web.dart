import 'socket_channel_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketChannelManagerForWeb extends SocketChannelManager {
  @override
  connect(uri) {
    return WebSocketChannel.connect(Uri.parse(uri));
  }
}

SocketChannelManager getManager() => SocketChannelManagerForWeb();
