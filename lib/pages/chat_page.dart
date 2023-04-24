import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/widgets/chat_message.dart';
import 'package:provider/provider.dart';
import '../models/messagesResponse.dart';
import '../models/user.dart';
import '../services/socket_service.dart';
import '../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  late ChatService chatService;
  late AuthService authService;
  late SocketService socketService;
  List<ChatMessage> _messages = [];
  bool _writting = false;
  bool _loading=true;
  @override
  void initState() {
    // TODO: implement initState
   
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('msg-personal', _listenMsg);
    _history(chatService.userfriend.uid);
     super.initState();
  }

 void _history(String uid)async{

List<Msg> chat=await chatService.getChat(uid);

final history=chat.map((m)=>ChatMessage(
  text: m.msg,
  uuid: m.from,
  animation: AnimationController(
    //..foward lanza inmediatamente el animationcontroller
            vsync: this, duration: const Duration(milliseconds: 0))..forward()));
setState(() {
  _messages.insertAll(0, history);
  _loading=false;
});
 }


  void _listenMsg(dynamic data) {
    ChatMessage msg = ChatMessage(
        text: data['msg'],
        uuid: data['from'],
        animation: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final User userfriend = chatService.userfriend;
    return Scaffold(
      backgroundColor: const Color(0xFFFCCE73),
      appBar: AppBar(
          backgroundColor: const Color(0xFFfab400),
          title: Column(children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFF4040),
              maxRadius: 14,
              child: Text(userfriend.name.substring(0, 1),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white)),
            ),
            const SizedBox(height: 3),
            Text(
              userfriend.name,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
            ),
          ]),
          centerTitle: true,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, 'users');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: (() => Navigator.pushNamed(context, 'friend')),
            )
          ]),
      body: GestureDetector(
        onTap: (){
          _focusNode.unfocus();
        },
        child: Column(
          children: [
            _messages.isEmpty? 
            ( _loading ?
              const Flexible
              (child: Center(child: CircularProgressIndicator(color: Color(0xFFFF4040))))
            :
             Flexible(
              child: Center(
                child: Text('Theres no messages between you and ${userfriend.name}',style: TextStyle(fontFamily: 'Poppins')),
            
              ),
            ))
           
            :
            Flexible(
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  _inputChat() {
    final socketService = Provider.of<SocketService>(context);
     final status = socketService.serverStatus;
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            focusNode:_focusNode,
            enabled: status==ServerStatus.Online ? true :false,
            style: const TextStyle(fontFamily: 'Poppins'),
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (String text) {
              setState(() {
                if (text.trim().isNotEmpty) {
                  _writting = true;
                } else {
                  _writting = false;
                }
              });
            },
            decoration:  InputDecoration.collapsed(
                hintText: status==ServerStatus.Online ? 'Message' :'Connect to send messages',
                hintStyle: const TextStyle(fontFamily: 'Poppins')),
         
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _writting
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                    child: const Text(
                      'Send',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: const IconThemeData(color: Color(0xFFFF4040)),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _writting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      text: text,
      uuid: authService.user.uid,
      animation: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animation.forward();

    setState(() {
      _writting = false;
    });
    socketService.emit('msg-personal', {
      'from': authService.user.uid,
      'to': chatService.userfriend.uid,
      'msg': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animation.dispose();
    }

    socketService.socket.off('msg-personal');
    super.dispose();
  }
}
