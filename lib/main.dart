import 'package:flutter/material.dart';
import 'package:flutter_platform_experiment/production_server_address.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_platform_experiment/socket_channel_manager.dart';

// Production flag
const bool PRODUCTION = true;

void main() => runApp(
  MaterialApp(home: MyApp()),
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var channel;
  TextEditingController _textEditingController = TextEditingController();
  List<String> messages = List<String>.empty(growable: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    webSocketConnect();
  }

  @override
  void dispose() {
    channel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Platform - $platform'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: reconnectToWebSocket
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            MessageList(messages),
            Controls(
              textEditingController: _textEditingController,
              sendMessage: sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  // Actions
  void sendMessage(){
    String message = _textEditingController.text;
    if(message!= null && message != ''){
      sendToWebSocket(_textEditingController.text);
      _textEditingController.clear();
    }
  }

  // Operations
  void sendToWebSocket(String message) {
    channel.sink.add('$platform: $message');
  }

  Future<bool> webSocketConnect() async {
    try{
      channel = SocketChannelManager.instance.connect(webSocketServer());
      print('WebSocket Connected');

      channel.stream.listen((snapshot) {
        setState(() {
          messages.insert(0, snapshot.toString());
        });
      });
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  void reconnectToWebSocket(){
    webSocketConnect().then((connected) {
      if(connected) {
        showSnackMessage('Connected');
      } else{
        showSnackMessage('Failed to connect');
      }
    });
  }

  void showSnackMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  // Address helper method
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

  // Platform String helper
  String get platform => getPlatform();

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

// UI Widgets
class MessageList extends StatelessWidget {
  final List<String> messages;

  MessageList(this.messages);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Message(messages[index]);
        }
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function sendMessage;

  Controls({
    @required this.textEditingController,
    @required this.sendMessage
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: textEditingController,
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
    );
  }
}

class Message extends StatelessWidget {
  final String message;

  Message(this.message);

  @override
  Widget build(BuildContext context) {
    List<String> _complexMessage = message.split(':');
    return TextBubble(
      platform: _complexMessage[0],
      message: _complexMessage[1].trimRight().toString(),
    );
  }
}

class TextBubble extends StatelessWidget {
  final String platform;
  final String message;

  TextBubble({
    @required this.message,
    @required this.platform
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: platform+': ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
          TextSpan(
            text: message,
            style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 30,
            ),
          ),
        ]
      ),
    );
  }
}
