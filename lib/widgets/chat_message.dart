import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';


class ChatMessage extends StatelessWidget {
final String text;
final String uuid;
final AnimationController animation;


  const ChatMessage({
    super.key,
    required this.text,
    required this.uuid,
    required this.animation});

  @override
  Widget build(BuildContext context) {
    final authService=Provider.of<AuthService>(context,listen: false);
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animation,curve: Curves.easeOut),
        child: Container(
         child: uuid==authService.user.uid
         ?_myMessage()
         :_friendMessage()
          
        ),
      ),
    );
  }
  
  _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
        right: 5,
        bottom:5,
        left:50),
        decoration:  BoxDecoration(
          color: const Color(0xFFFF5151),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(text,style: const TextStyle(fontFamily: 'Poppins',color:Colors.white),),
      ),
      );
  }
  
  _friendMessage() {
   return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
        left: 5,
        bottom:5,
        right:50),
        decoration:  BoxDecoration(
          color: const Color(0xFFFF6C7C),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(text,style: const TextStyle(fontFamily: 'Poppins',color:Colors.white),),
      ),
      );
  }
}