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

class SearchMessagesScreen extends StatefulWidget {
  const SearchMessagesScreen({Key? key}) : super(key: key);

  @override
  State<SearchMessagesScreen> createState() => _SearchMessagesScreenState();
}

class _SearchMessagesScreenState extends State<SearchMessagesScreen> with TickerProviderStateMixin {
  bool reverse = true;
  bool search=false;
  bool loading=true;
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  late ChatService chatService;
  late AuthService authService;
  late SocketService socketService;
  List<ChatMessage> _messages = [];
  bool _writting = false;
  @override
  void initState() {
    // TODO: implement initState
    
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
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
  loading=false;
});
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
      ),
      body: GestureDetector(
        onTap: (() {
          _focusNode.unfocus();
        }),
        child: Column(
          children: [
            const SizedBox(height: 4,),
            TextField(
               focusNode: _focusNode,
                cursorColor: const Color(0xFFfab400),
                style: const TextStyle(fontFamily: 'Poppins'),
                onChanged: (query) => _filterMessages(query),
                decoration: InputDecoration(
                  hintText: 'Search messages',
                  hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  prefixIcon: const Icon(Icons.search),
      
                  //prefixIconColor: Color(0xFFfab400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFfab400)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              _messages.isEmpty ?
               Flexible(
                 child: loading?
                 const Center(child: CircularProgressIndicator(color: Color(0xFFFF4040)) )
                 
                 :
                 Center(
                  child: search ? const Text('Theres no messages that match with the search',style: TextStyle(fontFamily: 'Poppins')) :Text('Theres no messages between you and ${userfriend.name}',style: TextStyle(fontFamily: 'Poppins')),
                           ),
               )
              :
      
            Flexible(
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: reverse ? true:false,
            )),
            const Divider(
              height: 1,
            ),
            
          ],
        ),
      ),
    );
  }
  _filterMessages(String query)async{
List<ChatMessage> results=[];
if(query.isNotEmpty){
for(ChatMessage msg in _messages){
  if(msg.text.toLowerCase().contains(query.toLowerCase())){
    results.add(msg);
  }
}
setState(() {
  _messages=results;
  reverse=false;
  search=true;
});
}if (query.isEmpty){
  
List<Msg> chat=await chatService.getChat(chatService.userfriend.uid);


final history=chat.map((m)=>ChatMessage(
  text: m.msg,
  uuid: m.from,
  animation: AnimationController(
    //..foward lanza inmediatamente el animationcontroller
            vsync: this, duration: const Duration(milliseconds: 0))..forward()));
setState(() {
  _messages=[];
  _messages.insertAll(0, history);
  reverse=true;
});
}


  }
}