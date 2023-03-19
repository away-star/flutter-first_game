import 'package:flutter/material.dart';
import 'package:flutter_chat/breath.dart';
import 'package:flutter_chat/counter.dart';
import 'package:flutter_chat/game.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
 ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //把右上角的debug去掉
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat !',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Braeth(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //让这段文字居中
        centerTitle: true,
        title: const Text(
          'flutter chat !',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
          //解释一下下面这段代码在干嘛
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: _handleVoiceInput,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
      ChatMessage message = ChatMessage(
        text: text,
        isMe: true,
      );
      _messages.insert(0, message);
    });
  }

  void _handleVoiceInput() {
    // implement voice input
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;

  ChatMessage({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isMe
              ? CircleAvatar(
                  child: Text('Other'),
                )
              : SizedBox(),
          Container(
            margin: EdgeInsets.only(
              left: isMe ? 50.0 : 0.0,
              right: isMe ? 0.0 : 50.0,
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: isMe ? Radius.circular(16.0) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(16.0),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          isMe
              ? CircleAvatar(
                  child: Text('Me'),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
