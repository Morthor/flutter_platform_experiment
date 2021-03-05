import 'package:flutter/material.dart';
import 'package:flutter_platform_experiment/production_server_address.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_platform_experiment/socket_channel_manager.dart';

const bool PRODUCTION = false;

String webSocketServer(){
  if(PRODUCTION){
    return PROD_SERVER;
  }else {
    if (UniversalPlatform.isAndroid) {
      return 'ws://10.0.2.2:3000';
    } else {
      return 'ws://127.0.0.1:3000';
    }
  }
}

void main() => runApp(
  MaterialApp(home: MyApp()),
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var channel;

  // final HtmlWebSocketChannel
  TextEditingController _textEditingController = TextEditingController();
  List<String> messages = [];



  @override
  void initState() {
    channel = SocketChannelManager.instance.connect(webSocketServer());

    channel.stream.listen((snapshot) {
      print(snapshot.toString());
      setState(() {
        messages.insert(0, snapshot.toString());
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Platform'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Text(messages[index] == null
                      ? ""
                      : '${messages[index]}',
                  style: TextStyle(
                    fontSize: 30,
                  ));
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    onFieldSubmitted: (_) => sendMessage(),
                    autofocus: true,
                  ),
                ),
                TextButton.icon(
                  onPressed: sendMessage,
                  icon: Icon(Icons.send),
                  label: Text("Send")
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendToWebSocket(String message) {
    String platform = getPlatform();
    channel.sink.add('$platform: $message');
  }

  void sendMessage(){
    sendToWebSocket(_textEditingController.text);
    _textEditingController.clear();
  }

  String getPlatform(){
    if(UniversalPlatform.isWeb)
      return 'Web';

    if(UniversalPlatform.isAndroid)
      return 'Android';

    if(UniversalPlatform.isFuchsia)
      return 'Fuchsia';

    if(UniversalPlatform.isIOS)
      return 'iOS';

    if(UniversalPlatform.isLinux)
      return 'Linux';

    if(UniversalPlatform.isMacOS)
      return 'MacOS';

    if(UniversalPlatform.isWindows)
      return 'Windows';

    return 'Platform?';
  }
}