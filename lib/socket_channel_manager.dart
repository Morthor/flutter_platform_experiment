import 'socket_channel_manager_for_others_stub.dart'
  if (dart.library.io) 'socket_channel_manager_for_others.dart'
  if (dart.library.html) 'socket_channel_manager_for_web.dart';


abstract class SocketChannelManager {
  static SocketChannelManager _instance;

  static SocketChannelManager get instance {
    _instance ??= getManager();
    return _instance;
  }

  dynamic connect(uri);
}